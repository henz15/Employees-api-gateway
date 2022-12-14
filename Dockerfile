FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Employees-api-gateway.csproj", "./"]
RUN dotnet restore "Employees-api-gateway.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "Employees-api-gateway.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Employees-api-gateway.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Employees-api-gateway.dll"]
