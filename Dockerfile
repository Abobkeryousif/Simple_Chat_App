FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY ["src/SignalR.csproj", "src/"]

RUN dotnet restore "src/SignalR.csproj"

COPY src/. ./src/

WORKDIR /src/src

RUN dotnet build "SignalR.csproj" -c Release -o /app/build
RUN dotnet publish "SignalR.csproj" -c Release -o /app/publish /p:UseAppHost=false
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "SignalR.dll"]    