#!/bin/bash

echo "======= Instalando Sonar Scaner"
sudo dotnet tool install --tool-path=/usr/bin dotnet-sonarscanner --version 4.10.0
echo "======= Inicializando análisis"
sudo dotnet sonarscanner begin /o:gerardoat /k:gerardoat_pocdevops /d:sonar.host.url=https://sonarcloud.io /version:$(buildId)
echo "======= Compilando código"
sudo dotnet build src --configuration Release
echo "======= Finalizando análisis"
sudo dotnet sonarscanner end
