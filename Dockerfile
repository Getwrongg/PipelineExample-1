FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["PipelineExample/PipelineExample.csproj", "PipelineExample/"]
RUN dotnet restore "PipelineExample/PipelineExample.csproj"

COPY . .
WORKDIR /src/PipelineExample
RUN dotnet publish "PipelineExample.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "PipelineExample.dll"]