# gdal-docker
[![dockeri.co](http://dockeri.co/image/webmapp/gdal-docker)](https://hub.docker.com/r/webmapp/gdal-docker/)  
[![Build Status](https://travis-ci.org/webmapp/gdal-docker.svg?branch=master)](https://travis-ci.org/webmapp/gdal-docker)

GDAL Docker container with AWSCLI, read/write support for file geodatabases via ESRI File Geodatabase API 1.5 and Microsoft ODBC 13.1 driver with SQLCMD and BCP.

## Examples
* Convert an ArcGIS Server service to GeoJSON
```
docker run -v $PWD:/data -it webmapp/gdal-docker \
ogr2ogr -f GeoJSON /data/test.json \
"http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/Hydrography/Watershed173811/FeatureServer/0/query?where=objectid+%3D+objectid&outfields=*&f=json" OGRGeoJSON
```

* Convert the same ArcGIS Server service to file geodatabase, giving the layer a name
```
docker run -v $PWD:/data -it webmapp/gdal-docker \
ogr2ogr -f FileGDB /data/test.gdb \
"http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/Hydrography/Watershed173811/FeatureServer/0/query?where=objectid+%3D+objectid&outfields=*&f=json" OGRGeoJSON \
-nln watershed
```

* Load a file geodatabase from the web into Postgresql.  
First, get layer info from the zipped fgdb...
```
docker run -it webmapp/gdal-docker ogrinfo "http://biogeo.ucdavis.edu/data/gadm2.8/gdb/AFG_adm_gdb.zip"
ERROR 6: Update from remote service not supported
Had to open data source read-only.
INFO: Open of `http://biogeo.ucdavis.edu/data/gadm2.8/gdb/AFG_adm_gdb.zip'
      using driver `OpenFileGDB' successful.
1: AFG_adm0 (Multi Polygon)
2: AFG_adm1 (Multi Polygon)
3: AFG_adm2 (Multi Polygon)
```
Then load into Postgres using the selected layer name from ogrinfo.
```
docker run -it webmapp/gdal-docker ogr2ogr -f "PostgreSQL" PG:"host=myhost user=myloginname dbname=mydbname password=mypassword" \
"http://biogeo.ucdavis.edu/data/gadm2.8/gdb/AFG_adm_gdb.zip" AFG_adm0
```

## Formats
The following formats are supported:
```
PCIDSK -raster,vector- (rw+v): PCIDSK Database File
netCDF -raster,vector- (rw+s): Network Common Data Format
PDF -raster,vector- (w+): Geospatial PDF
ESRI Shapefile -vector- (rw+v): ESRI Shapefile
MapInfo File -vector- (rw+v): MapInfo File
UK .NTF -vector- (ro): UK .NTF
OGR_SDTS -vector- (ro): SDTS
S57 -vector- (rw+v): IHO S-57 (ENC)
DGN -vector- (rw+): Microstation DGN
OGR_VRT -vector- (rov): VRT - Virtual Datasource
REC -vector- (ro): EPIInfo .REC
Memory -vector- (rw+): Memory
BNA -vector- (rw+v): Atlas BNA
CSV -vector- (rw+v): Comma Separated Value (.csv)
GML -vector- (rw+v): Geography Markup Language (GML)
GPX -vector- (rw+v): GPX
KML -vector- (rw+v): Keyhole Markup Language (KML)
GeoJSON -vector- (rw+v): GeoJSON
OGR_GMT -vector- (rw+): GMT ASCII Vectors (.gmt)
GPKG -raster,vector- (rw+vs): GeoPackage
SQLite -vector- (rw+v): SQLite / Spatialite
ODBC -vector- (rw+): ODBC
WAsP -vector- (rw+v): WAsP .map format
PGeo -vector- (ro): ESRI Personal GeoDatabase
MSSQLSpatial -vector- (rw+): Microsoft SQL Server Spatial Database
PostgreSQL -vector- (rw+): PostgreSQL/PostGIS
OpenFileGDB -vector- (rov): ESRI FileGDB
FileGDB -vector- (rw+): ESRI FileGDB
XPlane -vector- (rov): X-Plane/Flightgear aeronautical data
DXF -vector- (rw+v): AutoCAD DXF
Geoconcept -vector- (rw+): Geoconcept
GeoRSS -vector- (rw+v): GeoRSS
GPSTrackMaker -vector- (rw+v): GPSTrackMaker
VFK -vector- (ro): Czech Cadastral Exchange Data Format
PGDUMP -vector- (w+v): PostgreSQL SQL dump
OSM -vector- (rov): OpenStreetMap XML and PBF
GPSBabel -vector- (rw+): GPSBabel
SUA -vector- (rov): Tim Newport-Peace's Special Use Airspace Format
OpenAir -vector- (rov): OpenAir
OGR_PDS -vector- (rov): Planetary Data Systems TABLE
WFS -vector- (rov): OGC WFS (Web Feature Service)
HTF -vector- (rov): Hydrographic Transfer Vector
AeronavFAA -vector- (rov): Aeronav FAA
Geomedia -vector- (ro): Geomedia .mdb
EDIGEO -vector- (rov): French EDIGEO exchange format
GFT -vector- (rw+): Google Fusion Tables
SVG -vector- (rov): Scalable Vector Graphics
CouchDB -vector- (rw+): CouchDB / GeoCouch
Cloudant -vector- (rw+): Cloudant / CouchDB
Idrisi -vector- (rov): Idrisi Vector (.vct)
ARCGEN -vector- (rov): Arc/Info Generate
SEGUKOOA -vector- (rov): SEG-P1 / UKOOA P1/90
SEGY -vector- (rov): SEG-Y
XLS -vector- (ro): MS Excel format
ODS -vector- (rw+v): Open Document/ LibreOffice / OpenOffice Spreadsheet
XLSX -vector- (rw+v): MS Office Open XML spreadsheet
ElasticSearch -vector- (rw+): Elastic Search
Walk -vector- (ro): Walk
Carto -vector- (rw+): Carto
AmigoCloud -vector- (rw+): AmigoCloud
SXF -vector- (ro): Storage and eXchange Format
Selafin -vector- (rw+v): Selafin
JML -vector- (rw+v): OpenJUMP JML
PLSCENES -raster,vector- (ro): Planet Labs Scenes API
CSW -vector- (ro): OGC CSW (Catalog  Service for the Web)
VDV -vector- (rw+v): VDV-451/VDV-452/INTREST Data Format
TIGER -vector- (rw+v): U.S. Census TIGER/Line
AVCBin -vector- (ro): Arc/Info Binary Coverage
AVCE00 -vector- (ro): Arc/Info E00 (ASCII) Coverage
HTTP -raster,vector- (ro): HTTP Fetching Wrapper
```
