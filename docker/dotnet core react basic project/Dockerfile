#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

RUN apt-get update && apt-get -y install sudo && apt-get -y install curl

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get install -y nodejs

# FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# installing sudo, because we need it for nodejs
RUN apt-get update && apt-get -y install sudo && apt-get -y install curl

# installing nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get install -y nodejs

WORKDIR /src
COPY ["DotNetCoreReact.csproj", "/"]
RUN dotnet restore "/DotNetCoreReact.csproj"
COPY . .
WORKDIR "/src"
RUN sudo chmod -R 777 ClientApp
RUN dotnet build "DotNetCoreReact.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetCoreReact.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetCoreReact.dll"]

# building the image
# sudo docker build -t reactdotnetimg .
# running the container
# sudo docker run -it --name=reactdotnet --rm  -p8010:80 reactdotnetimg