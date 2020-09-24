#!/bin/bash

ROOTPATH=$1
VERSIONANALISIS=$2
ls -l
echo "======= Instalando Sonar Scaner Path: $ROOTPATH"
dotnet tool install --tool-path=$ROOTPATH --version 4.10.0
ls -l
echo "======= Inicializando análisis Versión: $VERSIONANALISIS"
dotnet sonarscanner begin /o:gerardoat /k:gerardoat_pocdevops /d:sonar.host.url=https://sonarcloud.io /version:$VERSIONANALISIS
echo "======= Compilando código"
dotnet build src --configuration Release
echo "======= Finalizando análisis"
dotnet sonarscanner end
