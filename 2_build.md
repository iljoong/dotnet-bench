# Build an ASP.NET App

## Install

Install [.NET core 2.2 SDK](https://dotnet.microsoft.com/download) on developer's PC or VM.

## Create a simple API app

```
dotnet new webapi -o dncbench
cd dncbench
```

For test purpose, disable HTTPS redirection by update source code in `Startup.cs`.

```
//app.UseHttpsRedirection();
```

## Update api code

[`src\dncbench\Controllers\ValuesController.cs`](.\src\dncbench\Controllers\ValuesController.cs)

```
    static string[] _values = {"Apple", "Banana", "Cat", "Dog", "Elephant", "Flower", "Goose", "Hat", "Ice", "Jelly"};

    // GET api/values
    [HttpGet]
    public ActionResult<IEnumerable<string>> Get()
    {
        Random rand = new Random();
        int r = rand.Next(10);

        return new string[] { "value1", "value2", _values[r] };
    }
```

## Run app

```
dotnet run
```

## Test api

```
curl -i http://localhost:5000/api/values
```

For how to build asp.net core app, please refer [ASP.NET Core document](https://docs.microsoft.com/en-us/aspnet/core/tutorials/razor-pages/?view=aspnetcore-2.2) site.

