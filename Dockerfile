FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY ["SignalR.csproj", "./"]

RUN dotnet restore "SignalR.csproj"
COPY . .

RUN dotnet build "SignalR.csproj" -c Release -o /app/build
RUN dotnet publish "SignalR.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

COPY --from=build /app/publish .
EXPOSE 8000 

ENTRYPOINT ["dotnet" ,"SignalR.dll"]