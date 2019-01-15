# Deloy an ASP.NET App

## Build package(zip)

Publish and zip application.

```
dotnet publish -c Release -o ..\out
Compress-Archive -Path ..\out\* -DestinationPath ..\apiapp.zip
```

Once package is created, deploy to target VMs.

> Note that you will need to separate build/package for `http.sys` enabled application. See [`src/dncbench/Program.cs`](./src/dncbench/Program.cs) for how to update. 

## Deploy to Windows VM

You will need winrm to copy files to remote Windows VM.

```
$hostName='hostip'
$winrmPort = '5986'

# Get the credentials of the machine
$cred = Get-Credential

# copy local file to remote dir
$soptions = New-PSSessionOption -SkipCACheck -SkipCNCheck
$session= New-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL
Copy-Item –Path .\dncbench\src\apiapp.zip –Destination 'C:\Users\azure' –ToSession $session

# Connect to the remote VM
Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL

# unzip package and restart IIS
Expand-Archive C:\Users\azure\apiapp.zip -DestinationPath C:\inetpub\wwwroot -Force

net stop was /y
net start w3svc
```

## Deploy to Linux VM

Configure proxy setting in `/etc/nginx/sites-available/default`

```
server {
    listen        80 default_server;
    location / {
        proxy_pass         http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }
}
```

restart `Nginx`

```
sudo nginx -s stop
sudo nginx
```

From dev pc/vm, copy package to target VM using `scp`.

```
scp .\dncbench\src\apiapp.zip azure@dnclxvm:~/
unzip apiapp.zip
```

## Build Docker image

Copy [Dockerfile](./src/Dockerfile) to publish folder (e.g., `out`) and build docker image

```
docker build -t dncbench .
```

run docker

```
docker run -e ASPNETCORE_ENVIRONMENT=Production -e DOTNET_PRINT_TELEMETRY_MESSAGE=false -p 5000:80 -d dncbench
```
