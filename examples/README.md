## gdal-docker examples

### ogr2ogr
Convert an ArcGIS Server service to GeoJSON
```
$ docker run -v $PWD:/data webmapp/gdal-docker \
ogr2ogr -f GeoJSON watershed.json \
"http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/Hydrography/Watershed173811/FeatureServer/0/query?where=objectid+%3D+objectid&outfields=*&f=json" OGRGeoJSON
```

Convert the same ArcGIS Server service to file geodatabase, giving the layer a name
```
$ docker run -v $PWD:/data webmapp/gdal-docker \
ogr2ogr -f FileGDB hydrography.gdb \
"http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/Hydrography/Watershed173811/FeatureServer/0/query?where=objectid+%3D+objectid&outfields=*&f=json" OGRGeoJSON \
-nln watershed
```

Load a file geodatabase from the web into Postgresql.  
First, get layer info from the zipped fgdb...
```
$ docker run webmapp/gdal-docker ogrinfo "http://biogeo.ucdavis.edu/data/gadm2.8/gdb/AFG_adm_gdb.zip"
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
$ docker run webmapp/gdal-docker ogr2ogr -f "PostgreSQL" PG:"host=myhost user=myloginname dbname=mydbname password=mypassword" \
"http://biogeo.ucdavis.edu/data/gadm2.8/gdb/AFG_adm_gdb.zip" AFG_adm0
```
