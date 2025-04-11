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
exec java -Xms$XMS -Xmx$XMX -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar spigot-*.jar nogui $ARGS 
