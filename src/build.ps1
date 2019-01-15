# publish app

dotnet publish -c Release -o ..\out dncbench

# zip package

Compress-Archive -Path .\out\* -DestinationPath apiapp_nginx.zip -Force