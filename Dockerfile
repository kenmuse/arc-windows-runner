# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2022
ARG RUNNER_OS=win
ARG RUNNER_ARCH=x64
ARG RUNNER_VERSION
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.4.0
ARG DOCKER_VERSION=24.0.6

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';$ProgressPreference='silentlyContinue';"]

WORKDIR /home/runner


RUN `
    ###############################
    #   Install Actions Runner
    ###############################
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v${env:RUNNER_VERSION}/actions-runner-${env:RUNNER_OS}-${env:RUNNER_ARCH}-${env:RUNNER_VERSION}.zip -OutFile actions-runner.zip;  `
    Add-Type -AssemblyName System.IO.Compression.FileSystem; `
    [System.IO.Compression.ZipFile]::ExtractToDirectory('actions-runner.zip', $PWD); `
    Remove-Item -Path actions-runner.zip -Force; `
    ###############################
    #   Install Runner Container Hooks
    ###############################
    Invoke-WebRequest -OutFile runner-container-hooks.zip -Uri https://github.com/actions/runner-container-hooks/releases/download/v${env:RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${env:RUNNER_CONTAINER_HOOKS_VERSION}.zip;`
    [System.IO.Compression.ZipFile]::ExtractToDirectory('runner-container-hooks.zip', (Join-Path -Path $PWD -ChildPath 'k8s')); `
    Remove-Item -Path runner-container-hooks.zip -Force; `
    ###############################
    #   Install Git Using Choco    
    ###############################
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); `
    choco install git.install --params "'/GitAndUnixToolsOnPath'" -y; `
    choco feature enable -n allowGlobalConfirmation
