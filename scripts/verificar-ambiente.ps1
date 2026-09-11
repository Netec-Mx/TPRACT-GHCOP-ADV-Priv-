<#
.SYNOPSIS
    Verificacion del ambiente para el taller de GitHub Copilot.

.DESCRIPTION
    Diagnostica el puesto de trabajo: presencia y version de las herramientas requeridas y
    conectividad a los dominios que GitHub Copilot necesita. No instala ni modifica nada.

    Equivalente funcional de scripts/verificar-ambiente.sh: mismas versiones minimas,
    mismos dominios, mismas categorias de resultado y mismos codigos de salida.

.PARAMETER SinRed
    Omite las comprobaciones de conectividad. Tambien se acepta --sin-red.

.PARAMETER Ayuda
    Muestra la ayuda y termina. Tambien se acepta --ayuda.

.PARAMETER Version
    Muestra la version del script y termina. Tambien se acepta --version.

.EXAMPLE
    pwsh -File verificar-ambiente.ps1

.EXAMPLE
    pwsh -File verificar-ambiente.ps1 -SinRed

.NOTES
    Codigo de salida 0 si el ambiente esta apto, 1 si falta un requisito obligatorio,
    2 si se pasa una opcion no reconocida.
    Compatible con Windows PowerShell 5.1 y PowerShell 7 o superior.
#>

[CmdletBinding()]
param(
    [switch]$SinRed,
    [switch]$Ayuda,
    [switch]$Version,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Extra
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Version del script y requisitos minimos
# ---------------------------------------------------------------------------

$VersionScript = '1.0.0'

# Version minima exigida por herramienta. Debe coincidir con docs/00-setup-ambiente.md
# y con scripts/verificar-ambiente.sh.
$MinGit    = '2.40'
$MinJdk    = '21'
$MinDotnet = '8.0'
$MinNode   = '22'
$MinCode   = '1.95'
$MinMaven  = '3.9'

# Dominios obligatorios para que GitHub Copilot funcione.
$DominiosObligatorios = @(
    'github.com',
    'api.github.com',
    'api.githubcopilot.com',
    'proxy.individual.githubcopilot.com',
    'copilot-proxy.githubusercontent.com',
    'default.exp-tas.com'
)

# Dominios recomendados. Su ausencia advierte pero no reprueba el ambiente.
$DominiosRecomendados = @(
    'copilot-telemetry.githubusercontent.com',
    'marketplace.visualstudio.com'
)

$TimeoutRed = 8

# ---------------------------------------------------------------------------
# Estado acumulado
# ---------------------------------------------------------------------------

$script:DetalleFallas = [System.Collections.Generic.List[string]]::new()
$script:DetalleAvisos = [System.Collections.Generic.List[string]]::new()

# ---------------------------------------------------------------------------
# Salida en pantalla
# ---------------------------------------------------------------------------

$script:UsarColor = $true
if ($env:NO_COLOR) { $script:UsarColor = $false }

function Write-Linea {
    param(
        [string]$Texto,
        [string]$Color
    )
    if ($script:UsarColor -and $Color) {
        Write-Host $Texto -ForegroundColor $Color
    }
    else {
        Write-Host $Texto
    }
}

function Write-Titulo {
    param([string]$Texto)
    Write-Host ''
    Write-Linea -Texto "== $Texto ==" -Color 'Cyan'
}

function Write-Ok {
    param([string]$Texto)
    if ($script:UsarColor) {
        Write-Host '  [ OK ] ' -ForegroundColor Green -NoNewline
        Write-Host $Texto
    }
    else {
        Write-Host "  [ OK ] $Texto"
    }
}

function Write-Falla {
    param([string]$Texto)
    if ($script:UsarColor) {
        Write-Host '  [FALLA] ' -ForegroundColor Red -NoNewline
        Write-Host $Texto
    }
    else {
        Write-Host "  [FALLA] $Texto"
    }
    $script:DetalleFallas.Add($Texto)
}

function Write-Aviso {
    param([string]$Texto)
    if ($script:UsarColor) {
        Write-Host '  [AVISO] ' -ForegroundColor Yellow -NoNewline
        Write-Host $Texto
    }
    else {
        Write-Host "  [AVISO] $Texto"
    }
    $script:DetalleAvisos.Add($Texto)
}

function Show-Uso {
    @'
Uso: pwsh -File verificar-ambiente.ps1 [opciones]

Diagnostica el ambiente del taller de GitHub Copilot. No instala ni modifica nada.

Opciones:
  -SinRed,  --sin-red     Omite las comprobaciones de conectividad.
  -Ayuda,   --ayuda       Muestra esta ayuda y termina.
  -Version, --version     Muestra la version del script y termina.

Codigo de salida:
  0   El ambiente esta apto.
  1   Falta al menos un requisito obligatorio.
'@ | Write-Host
}

# ---------------------------------------------------------------------------
# Utilidades
# ---------------------------------------------------------------------------

# Extrae el primer numero con formato X, X.Y o X.Y.Z del texto recibido.
# Se toma el primero y no el ultimo porque las herramientas suelen imprimir su version al
# inicio y un identificador de compilacion despues: "git version 2.54.0 (Apple Git-157)".
function Get-NumeroVersion {
    param([string]$Texto)

    if ([string]::IsNullOrWhiteSpace($Texto)) { return $null }

    $encontrado = [regex]::Match($Texto, '[0-9]+(\.[0-9]+){0,2}')
    if ($encontrado.Success) { return $encontrado.Value }
    return $null
}

# Devuelve el componente numerico en la posicion indicada, o 0 si la version no lo trae.
function Get-ComponenteVersion {
    param(
        [string]$Version,
        [int]$Indice
    )

    $partes = $Version -split '\.'
    if ($Indice -ge $partes.Count) { return 0 }

    $valor = 0
    if ([int]::TryParse($partes[$Indice], [ref]$valor)) { return $valor }
    return 0
}

# Devuelve $true si $Encontrada es mayor o igual que $Minima.
# Solo se comparan los componentes presentes en el minimo, de modo que "21.0.1" cumpla "21".
function Test-VersionSuficiente {
    param(
        [string]$Encontrada,
        [string]$Minima
    )

    $total = ($Minima -split '\.').Count

    for ($i = 0; $i -lt $total; $i++) {
        $parteEnc = Get-ComponenteVersion -Version $Encontrada -Indice $i
        $parteMin = Get-ComponenteVersion -Version $Minima -Indice $i

        if ($parteEnc -gt $parteMin) { return $true }
        if ($parteEnc -lt $parteMin) { return $false }
    }

    return $true
}

function Test-Herramienta {
    param(
        [string]$Etiqueta,
        [string]$Binario,
        [string]$Minima,
        [bool]$Obligatoria,
        [string[]]$Argumentos
    )

    $comando = Get-Command $Binario -ErrorAction SilentlyContinue
    if (-not $comando) {
        if ($Obligatoria) {
            Write-Falla "$Etiqueta no esta instalado o no esta en el PATH (se requiere $Minima o superior)"
        }
        else {
            Write-Aviso "$Etiqueta no esta instalado o no esta en el PATH (recomendado $Minima o superior)"
        }
        return
    }

    $salida = $null
    try {
        # Varias herramientas escriben su version en el flujo de error, por eso 2>&1.
        $salida = (& $Binario @Argumentos 2>&1 | Out-String)
    }
    catch {
        Write-Aviso "$Etiqueta esta instalado pero no respondio al consultar su version"
        return
    }

    $encontrada = Get-NumeroVersion -Texto $salida
    if (-not $encontrada) {
        Write-Aviso "$Etiqueta esta instalado pero no se pudo determinar su version"
        return
    }

    if (Test-VersionSuficiente -Encontrada $encontrada -Minima $Minima) {
        Write-Ok "$Etiqueta $encontrada (minimo $Minima)"
    }
    elseif ($Obligatoria) {
        Write-Falla "$Etiqueta $encontrada es anterior al minimo exigido $Minima"
    }
    else {
        Write-Aviso "$Etiqueta $encontrada es anterior al minimo recomendado $Minima"
    }
}

# Comprueba que un dominio sea alcanzable por HTTPS.
# Cualquier respuesta del servidor cuenta como exito: lo que se valida es que la red deje
# pasar la conexion, no que el endpoint devuelva 200. Se usa Invoke-WebRequest y no una
# conexion TCP directa para que la comprobacion respete el proxy configurado en el sistema.
function Test-Dominio {
    param([string]$Destino)

    try {
        $parametros = @{
            Uri             = "https://$Destino"
            TimeoutSec      = $TimeoutRed
            UseBasicParsing = $true
            ErrorAction     = 'Stop'
        }
        $null = Invoke-WebRequest @parametros
        return $true
    }
    catch {
        # Un codigo de estado HTTP de error significa que el servidor respondio, es decir
        # que la red dejo pasar la conexion. Solo los errores de transporte reprueban.
        #
        # La unica senal fiable es que la excepcion traiga una respuesta adjunta:
        # HttpResponseException en PowerShell 7 y WebException en Windows PowerShell 5.1
        # la traen poblada, mientras que un fallo de DNS o de conexion la deja nula.
        #
        # No se usa FullyQualifiedErrorId para decidir: PowerShell reporta el mismo
        # identificador WebCmdletWebResponseException tanto para un 404 legitimo como para
        # un dominio que no resuelve, de modo que discriminar por ahi daria por alcanzable
        # cualquier dominio bloqueado.
        $excepcion = $_.Exception

        if ($excepcion.PSObject.Properties.Name -contains 'Response' -and
            $null -ne $excepcion.Response) {
            return $true
        }

        return $false
    }
}

function Test-Dominios {
    param(
        [string[]]$Lista,
        [bool]$Obligatorios
    )

    foreach ($destino in $Lista) {
        if (Test-Dominio -Destino $destino) {
            Write-Ok "$destino alcanzable"
        }
        elseif ($Obligatorios) {
            Write-Falla "$destino no es alcanzable, revisar proxy, firewall o lista blanca"
        }
        else {
            Write-Aviso "$destino no es alcanzable, funcionalidad degradada pero el taller es viable"
        }
    }
}

# ---------------------------------------------------------------------------
# Argumentos
# ---------------------------------------------------------------------------

# Se aceptan tanto los parametros idiomaticos de PowerShell como las opciones con guion
# doble del script de shell, para que ambos se invoquen igual en la documentacion.
if ($Extra) {
    foreach ($argumento in $Extra) {
        switch ($argumento) {
            '--sin-red' { $SinRed = $true }
            '--ayuda'   { $Ayuda = $true }
            '--help'    { $Ayuda = $true }
            '-h'        { $Ayuda = $true }
            '--version' { $Version = $true }
            default {
                Write-Host "Opcion no reconocida: $argumento" -ForegroundColor Red
                Write-Host ''
                Show-Uso
                exit 2
            }
        }
    }
}

if ($Ayuda) {
    Show-Uso
    exit 0
}

if ($Version) {
    Write-Host "verificar-ambiente.ps1 $VersionScript"
    exit 0
}

# ---------------------------------------------------------------------------
# Ejecucion
# ---------------------------------------------------------------------------

Write-Linea -Texto 'Verificacion de ambiente, taller de GitHub Copilot' -Color 'Cyan'
Write-Host "Script version $VersionScript"

$descripcionSistema = [System.Environment]::OSVersion.VersionString
Write-Host "Sistema: $descripcionSistema"
Write-Host "PowerShell: $($PSVersionTable.PSVersion)"
Write-Host "Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

Write-Titulo 'Herramientas obligatorias'
Test-Herramienta -Etiqueta 'Git' -Binario 'git' -Minima $MinGit -Obligatoria $true -Argumentos @('--version')
Test-Herramienta -Etiqueta 'JDK' -Binario 'java' -Minima $MinJdk -Obligatoria $true -Argumentos @('-version')
Test-Herramienta -Etiqueta 'SDK de .NET' -Binario 'dotnet' -Minima $MinDotnet -Obligatoria $true -Argumentos @('--version')
Test-Herramienta -Etiqueta 'Node.js' -Binario 'node' -Minima $MinNode -Obligatoria $true -Argumentos @('--version')
Test-Herramienta -Etiqueta 'Visual Studio Code' -Binario 'code' -Minima $MinCode -Obligatoria $true -Argumentos @('--version')

Write-Titulo 'Herramientas recomendadas'
Test-Herramienta -Etiqueta 'Apache Maven' -Binario 'mvn' -Minima $MinMaven -Obligatoria $false -Argumentos @('--version')

if (Get-Command 'code' -ErrorAction SilentlyContinue) {
    $extensiones = @()
    try {
        $extensiones = @(& code --list-extensions 2>$null | ForEach-Object { $_.ToLowerInvariant() })
    }
    catch {
        $extensiones = @()
    }

    foreach ($extension in @('github.copilot', 'github.copilot-chat')) {
        if ($extensiones -contains $extension) {
            Write-Ok "Extension $extension instalada"
        }
        else {
            Write-Aviso "Extension $extension no encontrada en Visual Studio Code"
        }
    }
}

if (-not $SinRed) {
    Write-Titulo 'Conectividad obligatoria de GitHub Copilot'
    Test-Dominios -Lista $DominiosObligatorios -Obligatorios $true

    Write-Titulo 'Conectividad recomendada'
    Test-Dominios -Lista $DominiosRecomendados -Obligatorios $false
}
else {
    Write-Titulo 'Conectividad'
    Write-Host '  Omitida por --sin-red'
}

# ---------------------------------------------------------------------------
# Resumen
# ---------------------------------------------------------------------------

Write-Titulo 'Resumen'

$totalFallas = $script:DetalleFallas.Count
$totalAvisos = $script:DetalleAvisos.Count

if ($totalFallas -eq 0 -and $totalAvisos -eq 0) {
    Write-Linea -Texto '  Ambiente apto. Todos los requisitos obligatorios y recomendados estan cubiertos.' -Color 'Green'
    exit 0
}

if ($totalFallas -eq 0) {
    Write-Linea -Texto "  Ambiente apto con $totalAvisos advertencia(s). Los requisitos obligatorios estan cubiertos." -Color 'Green'
    Write-Host ''
    Write-Host '  Advertencias:'
    foreach ($linea in $script:DetalleAvisos) { Write-Host "    - $linea" }
    exit 0
}

Write-Linea -Texto "  Ambiente NO apto. Faltan $totalFallas requisito(s) obligatorio(s)." -Color 'Red'
Write-Host ''
Write-Host '  Requisitos faltantes:'
foreach ($linea in $script:DetalleFallas) { Write-Host "    - $linea" }

if ($totalAvisos -gt 0) {
    Write-Host ''
    Write-Host '  Advertencias adicionales:'
    foreach ($linea in $script:DetalleAvisos) { Write-Host "    - $linea" }
}

Write-Host ''
Write-Host '  Revisa docs/00-setup-ambiente.md para los pasos de instalacion.'
exit 1
