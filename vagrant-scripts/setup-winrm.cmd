@echo off
rem used to fix issues with vagrant 1.8.5
rem https://github.com/mitchellh/vagrant/issues/7489
winrm set winrm/config/winrs @{MaxShellsPerUser="30"}
winrm set winrm/config/winrs @{MaxConcurrentUsers="30"}
winrm set winrm/config/winrs @{MaxProcessesPerShell="30"}
winrm set winrm/config/service @{MaxConcurrentOperationsPerUser="50"}
