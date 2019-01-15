# ASP.NET Core's hosting/deployment options benchmark

Unlike .NET framework, .NET Core support various plaforms and technologies. You may want to test various options for your application.

This document provides general guideline for testing various ASP.NET Core hosting/deployment options in Azure.

## Hosting/Deployment options

You may consider to test 8 different options.

- Windows
    - [IIS + In-process](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/?view=aspnetcore-2.2#iis-options)
    - [IIS + Out-of-process (Kestrel)](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/?view=aspnetcore-2.2#iis-options)
    - [Self-hosted (Kestrel)](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-2.2)
    - [Self-hosted (http.sys)](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/httpsys?view=aspnetcore-2.2)
    - [Docker + Self-hosted (Kestrel)](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/?view=aspnetcore-2.2)
    
- Linux
    - [Nginx/Apache + Kestrel](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-2.2)
    - [Self-hosted (Kestrel)](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-2.2)
    - [Docker + Self-hosted (Kestrel)](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/?view=aspnetcore-2.2)

For more information, please refer ['Host and deploy ASP.NET Core'](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/?view=aspnetcore-2.2) document.


> Sample api app (default app with small modification) is provided for the test puprose. It is recommend to use your own api app.

## Content

1. [Azure Setup](./1_setup.md)

2. [Build App](./2_build.md)

3. [Deploy App](./3_deploy.md)

4. [Test Hosting Options](./4_test.md)

5. [Load Test](./5_loadtest.md)




