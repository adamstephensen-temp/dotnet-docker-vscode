FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src
COPY ["dotnet-docker-vscode.csproj", "./"]
RUN dotnet restore "./dotnet-docker-vscode.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dotnet-docker-vscode.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "dotnet-docker-vscode.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "dotnet-docker-vscode.dll"]
