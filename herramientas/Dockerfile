# Imagen de gates del repositorio de construccion.
#
# Reproduce, en lo que importa para los gates, el ambiente de la maquina virtual del
# taller: JDK 25, Maven, SDK de .NET 10, Node 24, Git y Bash. Las imagenes base van fijadas
# por version y por digest, para que la imagen se pueda reconstruir igual.
#
# La construccion necesita red. Deja precargadas las dependencias de Maven, de NuGet y del
# servidor MCP, de modo que los gates corran despues sin red, como en clase.
#
# No se usa directamente. La construye y la ejecuta scripts/gates.sh.

FROM maven:3.9.16-eclipse-temurin-25@sha256:93b8a14ea2f412782e4e842651273b4d903e35cc496284f178fbbe2d67d00976 AS jdk
FROM node:24.21.0-bookworm-slim@sha256:0e0ff40c39bc087845bfb27465a0df4ea419520094bc35842ff83dd8cbe6f9b6 AS node

FROM mcr.microsoft.com/dotnet/sdk:10.0.401@sha256:35d40304542c8689331f8cab17c65926cdf48fe711e289321d71924b230a7d29

COPY --from=jdk /opt/java/openjdk /opt/java/openjdk
COPY --from=jdk /usr/share/maven /usr/share/maven
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

ENV JAVA_HOME=/opt/java/openjdk \
    PATH=/opt/java/openjdk/bin:/usr/share/maven/bin:$PATH \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_NOLOGO=1 \
    TZ=America/Lima

# Cache de dependencias. Se compila y se prueba una vez cada escenario con red, que es lo
# mismo que pide docs/00-setup-ambiente.md al construir la imagen de la maquina virtual.
COPY escenario/java /precarga/escenario/java
COPY escenario/dotnet /precarga/escenario/dotnet
COPY escenario/datos /precarga/escenario/datos
RUN cd /precarga/escenario/java && mvn -B -q clean package && mvn -B -q dependency:tree \
    && cd /precarga/escenario/dotnet \
    && dotnet test LiquidacionComercios.Pruebas \
    && dotnet build LiquidacionComercios -c Release \
    && rm -rf /precarga

# Dependencias del servidor MCP, que gates.sh copia dentro del repositorio en cada corrida.
COPY mcp/servidor-local/package.json mcp/servidor-local/package-lock.json /opt/mcp/
RUN cd /opt/mcp && npm ci --no-audit --no-fund

# Validador de workflows de GitHub Actions con el parser oficial, @actions/workflow-parser,
# de github.com/actions/languageservices, con version exacta en su package-lock.json.
COPY herramientas/validar-workflows/package.json herramientas/validar-workflows/package-lock.json /opt/validar-workflows/
RUN cd /opt/validar-workflows && npm ci --no-audit --no-fund

RUN java -version && mvn -v && dotnet --version && node --version && git --version && bash --version | head -1
