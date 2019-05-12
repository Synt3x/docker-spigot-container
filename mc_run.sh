#!/bin/sh
set -e

# buildtools folder
rm -R -f /buildtools
mkdir -p /buildtools
cd /buildtools

# download latest buildtools to and compile latest spigot
wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -P /buildtools/
java -jar BuildTools.jar --rev $VERSION

# minecraft folder
mkdir -p /minecraft
rm -f /minecraft/spigot-*.jar
cd /minecraft

# copy spigot jar-file
cp /buildtools/spigot-*.jar /minecraft/

# eula
if [ ! -f /minecraft/eula.txt ]; then
  if [ "$EULA" != "0" ]; then
    echo -e "eula=true\n" > /minecraft/eula.txt
  fi
fi

# start minecraft server
exec java -Xms$XMS -Xmx$XMX -jar spigot-*.jar $ARGS
