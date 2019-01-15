# Test Hosting/Deployment Options

## 1. Windows IIS+In-proc

On target WinVM, modify `web.config` by adding `hostingModel="InProcess"`.

```
      <aspNetCore processPath="dotnet" arguments=".\dncbench.dll" stdoutLogEnabled="false" stdoutLogFile=".\logs\stdout" hostingModel="InProcess" />
```

On target WinVM, restart IIS.

```
net stop was /y
net start w3svc
```

On client, test api by calling url. Notice that you will get a response from `Microsoft-IIS/10.0 server`

```
curl -i http://winvm/api/values

HTTP/1.1 200 OK
Transfer-Encoding: chunked
Content-Type: application/json; charset=utf-8
Server: Microsoft-IIS/10.0
X-Powered-By: ASP.NET
Date: ...

["value1","value2","Hat"]
```

## 2. Windows IIS+Out-of-proc

On target WinVM, modify `web.config` by removing `hostingModel="InProcess"`

```
      <aspNetCore processPath="dotnet" arguments=".\dncbench.dll" stdoutLogEnabled="false" stdoutLogFile=".\logs\stdout" />
```

On target WinVM, restart IIS.

```
net stop was /y
net start w3svc
```

On client, test api by calling url. Notice that you will get a response from `Kestrel server`.

```
curl -i http://winvm/api/values

HTTP/1.1 200 OK
Transfer-Encoding: chunked
Content-Type: application/json; charset=utf-8
Server: Kestrel
X-Powered-By: ASP.NET
Date: ...

["value1","value2","Jelly"]
```

## 3. Windows Self-hosted (Kestrel)

On target WinVM, run app directly as below.

```
Expand-Archive -DestinationPath . apiapp.zip
$env:ASPNETCORE_URLS="http://*:5000"
dotnet dncbench.dll
```

You may need to configure firewall to allow in-bound traffic of port 5000 before running apiapp.

```
netsh advfirewall firewall add rule name="ASPNETCORE" dir=in action=allow protocol=TCP localport=5000
```

On client, test api by calling url. You will get a response from `Kestrel server` but notice that you won't get `X-Powered-By` header.

```
curl -i 52.231.72.241:5000/api/values

HTTP/1.1 200 OK
Date: ...
Content-Type: application/json; charset=utf-8
Server: Kestrel
Transfer-Encoding: chunked

["value1","value2","Banana"]
```

## 4. Windows Self-hosted (Http.sys)

You need different build for `http.sys` enabled app.

On target WinVM, run app directly.

```
Expand-Archive -DestinationPath . apiapp_httpsys.zip
$env:ASPNETCORE_URLS="http://*:5000"
dotnet dncbench.dll
```

On client, test api by calling url. Notice that you will get a response from `Microsoft-HTTPAPI/2.0 server`.

```
curl -i 52.231.72.241:5000/api/values

HTTP/1.1 200 OK
Transfer-Encoding: chunked
Content-Type: application/json; charset=utf-8
Server: Microsoft-HTTPAPI/2.0
Date: ...

["value1","value2","Hat"]
```

## 5. Windows Docker Self-hosted (Kestrel)

You need to build docker image before run this. Please refer [./src/docker](./src/docker)

On target WinVM, run docker image.

```
docker run -e ASPNETCORE_ENVIRONMENT=Production -e DOTNET_PRINT_TELEMETRY_MESSAGE=false -p 5000:80 -d dncbench
```

On client, test api by calling url. The resonse is the same as kestrel self-hosted.

```
curl -i 52.231.72.241:5000/api/values

HTTP/1.1 200 OK
Date: ...
Content-Type: application/json; charset=utf-8
Server: Kestrel
Transfer-Encoding: chunked

["value1","value2","Flower"]
```

## 6. Linux Nginx + Self-hosted (Kestrel)

On target LinuxVM, run app directly.

```
dotnet dncbench.dll
```

On client, test api by calling url. Notice that you will get resonse from `nginx/1.10.3`.

```
curl -i 52.231.67.220/api/values

HTTP/1.1 200 OK
Server: nginx/1.10.3 (Ubuntu)
Date: ...
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: keep-alive

["value1","value2","Banana"]
```

## 7. Linux Self-hosted (Kestrel)

On target LinuxVM, run app directly.

```
export ASPNETCORE_URLS="http://*:5000"
dotnet dncbench.dll
```

On client, test api by calling url. The resonse is the same as kestrel self-hosted in Windows.

```
curl -i 52.231.67.220:5000/api/values

HTTP/1.1 200 OK
Date: ...
Content-Type: application/json; charset=utf-8
Server: Kestrel
Transfer-Encoding: chunked

["value1","value2","Dog"]
```

## 8. Linux Docker Self-hosted (Kestrel)

On target LinuxVM, run docker image.

```
docker run -e ASPNETCORE_ENVIRONMENT=Production -e DOTNET_PRINT_TELEMETRY_MESSAGE=false -p 5000:80 -d dncbench
```

On client, test api by calling url. The resonse is the same as kestrel self-hosted in Windows.

```
curl -i 52.231.67.220:5000/api/values

HTTP/1.1 200 OK
Date: ...
Content-Type: application/json; charset=utf-8
Server: Kestrel
Transfer-Encoding: chunked

["value1","value2","Dog"]
```