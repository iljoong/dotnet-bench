#
# powershell script
#

$hostName='hostip'
$winrmPort = '5986'

# Get the credentials of the machine
$cred = Get-Credential

# Connect to the machine
$soptions = New-PSSessionOption -SkipCACheck -SkipCNCheck
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL

# Install IIS
Install-WindowsFeature Web-Server,Web-Asp-Net45,NET-Framework-Features

# https://dotnet.microsoft.com/download
Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/d4592a50-b583-434a-bcda-529e506a7e0d/b1fee3bb02e4d5b831bd6057af67a91b/dotnet-sdk-2.2.101-win-x64.exe -outfile $env:temp\dotnet-sdk-2.2.101-win-x64.exe
Start-Process $env:temp\dotnet-sdk-2.2.101-win-x64.exe -ArgumentList '/quiet' -Wait

# https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/?view=aspnetcore-2.2
Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/48adfc75-bce7-4621-ae7a-5f3c4cf4fc1f/9a8e07173697581a6ada4bf04c845a05/dotnet-hosting-2.2.0-win.exe -outfile $env:temp\dotnet-hosting-2.2.0-win.exe 
Start-Process $env:temp\dotnet-hosting-2.2.0-win.exe  -ArgumentList '/quiet' -Wait

# Restart the web server so that system PATH updates take effect
net stop was /y
net start w3svc

# copy local file to remote dir
$session= New-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL
Copy-Item -Path C:\Users\azure\dncbench\src\apiapp.zip -Destination 'C:\Users\azure' -ToSession $session

# winrm then unzip
Expand-Archive .\apiapp.zip -DestinationPath C:\inetpub\wwwroot -Force

# edit remote file
psedit filename
