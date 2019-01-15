FROM microsoft/dotnet:2.2-aspnetcore-runtime
WORKDIR /app

# copy and build everything else
COPY . ./app
ENTRYPOINT ["dotnet", "./app/dncbench.dll"]