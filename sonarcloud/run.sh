#!/bin/bash

sudo dotnet tool install --tool-path=/usr/bin dotnet-sonarscanner --version 4.10.0
sudo dotnet sonarscanner begin /o:gerardoat /k:gerardoat_pocdevops /d:sonar.host.url=https://sonarcloud.io /version:$(buildId)
sudo dotnet build src --configuration Release
sudo dotnet sonarscanner end
