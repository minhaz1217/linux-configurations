# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

COPY Dotnetcore_APIv2.sln .
COPY Dotnetcore_APIv2/Dotnetcore_APIv2.csproj Dotnetcore_APIv2/Dotnetcore_APIv2.csproj

COPY . ./

RUN dotnet publish Dotnetcore_APIv2 -c Release -o out

FROM mcr.microsoft.com/dotnet/sdk:5.0
WORKDIR /app
COPY --from=build-env /app/out/ .
CMD ["dotnet", "Dotnetcore_APIv2.dll"]
