## Use unix socket for Linux/Nginx 

https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-2.2#bind-to-a-unix-socket

### 1. Update Source code

You need to install `Libuv` package for enabling linux socket.

```
dotnet add package Microsoft.AspNetCore.Server.Kestrel.Transport.Libuv
```
https://github.com/aspnet/Announcements/issues/296
https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-2.2#transport-configuration


You also need to update startup code to listen unix socket.

```
        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseLibuv()
                .UseStartup<Startup>()
                .ConfigureKestrel((context, options) =>
                {
                    options.ListenUnixSocket("/tmp/kestrel-test.sock");
                });
```

### 2. Update ngnix config

Update `/etc/nginx/sites-available/default`

```
server {
    listen        80 default_server;
    location / {
        proxy_pass         http://unix:/tmp/api.sock:/;
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

### 3.Run dotnet

```
dotnet dncbench.dll

Hosting environment: Production
Content root path: /home/iljoong/dncbench/src/out
Now listening on: http://unix:/tmp/api.sock
Application started. Press Ctrl+C to shut down.
```

Note that `nginx` needs an permission to write to `/tmp/api.sock`. Add permision by following command.

```
sudo chown www-data:www-data /tmp/api.sock
```

### Trobuleshooting

Test unix socket using `curl`.

```
curl --unix-socket /tmp/api.sock http:/api/values
```

### Reference

https://www.lloydkinsella.net/2018/03/12/using-net-core-kestrel-with-nginx-and-unix-sockets/

