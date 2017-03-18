FROM ubuntu:16.10
MAINTAINER Cole Howard <cole@webmapp.com>

ENV GDAL_VERSION 2.1.3
ENV GDAL_SOURCE http://download.osgeo.org/gdal/2.1.3/gdal-${GDAL_VERSION}.tar.gz
ENV FGDB_VERSION 1_5_64
ENV FGDB_SOURCE https://github.com/Esri/file-geodatabase-api/blob/master/FileGDB_API_1.5/FileGDB_API_${FGDB_VERSION}.tar.gz

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
  build-essential \
  curl \
  awscli \
  unixodbc-dev \
  python-dev \
  python-numpy \
  libspatialite-dev \
  sqlite3 \
  libpq-dev \
  libcurl4-gnutls-dev \
  libproj-dev \
  libxml2-dev \
  libgeos-dev \
  libnetcdf-dev \
  libpoppler-dev \
  libspatialite-dev \
  libhdf4-alt-dev \
  libhdf5-serial-dev


ENV NEW_FGDB_SOURCE https://raw.githubusercontent.com/Esri/file-geodatabase-api/master/FileGDB_API_1.5/FileGDB_API_1_5_64gcc51.tar.gz
RUN curl -o /usr/local/src/filgdb_api.tar.gz ${NEW_FGDB_SOURCE} && \
  tar -xzvf /usr/local/src/filgdb_api.tar.gz -C /usr/local
  #rm /usr/local/src/filegdb_api.tar.gz

RUN curl -o /usr/local/src/gdal-${GDAL_VERSION}.tar.gz ${GDAL_SOURCE} && \
  tar -xzvf /usr/local/src/gdal-${GDAL_VERSION}.tar.gz -C /usr/local/src && \
  cd /usr/local/src/gdal-${GDAL_VERSION} && \
  ./configure \
  --with-python \
  --with-spatialite \
  --with-pg \
  --with-curl \
  --with-odbc \
  --with-fgdb=/usr/local/FileGDB_API-64gcc51 && \
  make && make install && ldconfig
  #rm /usr/local/src/gdal-${GDAL_VERSION}.tar.gz && \
  #rm -R /usr/local/src/gdal-${GDAL_VERSION}

CMD ["/bin/bash"]
