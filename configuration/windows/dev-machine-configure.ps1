#########
#
# Powershell script to configure windows base dev machine using Chocolatey.
# Scripts needs to be run with an unrestricted execution policy.
# Author: Robert Northard
#
#########

Write-Host "INFO: Configuring machine"
Write-Host "INFO: Installing Chocolatey"
iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))

Write-Host "INFO: Installing base applications from Chocolatey"

$packages = @("git","ruby","chefdk","python","putty", "virtualbox", "vagrant", "GoogleChrome", "atom", "netbeans-jee")

foreach ($package in $packages) {
	Write-Host "INFO: Installing $package"
 	chocolatey install $package -y
}

Write-Host "INFO: Base machine configured."
