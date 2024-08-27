# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2022
ARG RUNNER_OS=win
ARG RUNNER_ARCH=x64
ARG RUNNER_VERSION
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.6.1

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';$ProgressPreference='silentlyContinue';"]

WORKDIR /home/runner

RUN `
  ###############################################################################################
  #   Install Actions Runner
  #   You must always install the runner, and you want the latest version to avoid the restrictions
  #   applied to out-of-date runners.
  #   https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/autoscaling-with-self-hosted-runners#:~:text=Warning,-Any%20updates%20released
  ###############################################################################################
  Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v${env:RUNNER_VERSION}/actions-runner-${env:RUNNER_OS}-${env:RUNNER_ARCH}-${env:RUNNER_VERSION}.zip -OutFile actions-runner.zip;`
  Add-Type -AssemblyName System.IO.Compression.FileSystem;`
  [System.IO.Compression.ZipFile]::ExtractToDirectory('actions-runner.zip', $PWD);`
  Remove-Item -Path actions-runner.zip -Force;`
  ###############################################################################################
  #   Install Runner Container Hooks
  #   While it is possible to include these hooks, Windows runners can't use these today. 
  #   GitHub documents that you must use Linux runners for Docker container actions, job containers,
  #   or service containers.
  #   See also https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#jobsjob_idservices
  #   and https://github.com/actions/runner/issues/904
  ###############################################################################################
  # Invoke-WebRequest -OutFile runner-container-hooks.zip -Uri https://github.com/actions/runner-container-hooks/releases/download/v${env:RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${env:RUNNER_CONTAINER_HOOKS_VERSION}.zip;`
  # [System.IO.Compression.ZipFile]::ExtractToDirectory('runner-container-hooks.zip', (Join-Path -Path $PWD -ChildPath 'k8s'));`
  # Remove-Item -Path runner-container-hooks.zip -Force;`
  ###############################################################################################
  #   Install Git Using Choco
  #   Runners should have access to the latest version of Git and Git LFS, which we can
  #   install using Choco. This also makes a Bash shell available on Windows for scripting.
  #   You may want to include other tools and script engines as well.
  ###############################################################################################
  Set-ExecutionPolicy Bypass -Scope Process -Force;`
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;`
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));`
  choco install git.install --params "'/GitAndUnixToolsOnPath'" -y;`
  choco feature enable -n allowGlobalConfirmation;`
  ###############################################################################################
  #   Install Docker CLI Using Choco
  #   It's important to know that Windows doesn't support nested containers, so you can't
  #   use a Docker-in-Docker on Windows. That frequently limits the value of having the
  #   Docker CLI available on your images.
  ###############################################################################################
  choco install docker-cli docker-compose -force;
