FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# copy ONLY csproj first (clean restore layer)
COPY weatherapi.csproj ./
RUN dotnet restore

# copy source AFTER restore
COPY . ./

# HARD CLEAN inside container
RUN rm -rf obj bin

# FORCE NO apphost generation issue
RUN dotnet publish -c Release -o /out \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

ENV ASPNETCORE_URLS=http://+:80

EXPOSE 80

COPY --from=build /out .

ENTRYPOINT ["dotnet", "weatherapi.dll"]