FROM ubuntu:16.10
MAINTAINER Cole Howard <cole@webmapp.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    build-essential \
    curl \
    zip \
    apt-transport-https \
    python-dev \
    python-pip \
    python-setuptools \
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
    libhdf5-serial-dev && \
    pip install awscli

RUN curl --silent --show-error \
    https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl --silent --show-error \
    https://packages.microsoft.com/config/ubuntu/16.10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive apt-get -y install \
    unixodbc-dev \
    msodbcsql=13.1.4.0-1

ENV FGDB_SOURCE https://raw.githubusercontent.com/Esri/file-geodatabase-api/master/FileGDB_API_1.5/FileGDB_API_1_5_64gcc51.tar.gz
RUN curl --silent --show-error -o /usr/local/src/filgdb_api.tar.gz ${FGDB_SOURCE} && \
    tar -xzvf /usr/local/src/filgdb_api.tar.gz -C /usr/local

ENV GDAL_VERSION 2.1.3
ENV GDAL_SOURCE http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz
RUN curl --silent --show-error -o /usr/local/src/gdal-${GDAL_VERSION}.tar.gz ${GDAL_SOURCE} && \
    tar -xzvf /usr/local/src/gdal-${GDAL_VERSION}.tar.gz -C /usr/local/src && \
    cd /usr/local/src/gdal-${GDAL_VERSION} && \
    ./configure \
    --with-python \
    --with-geos \
    --with-spatialite \
    --with-pg \
    --with-curl \
    --with-libkml \
    --with-wfs \
    --with-odbc=/opt/microsoft/msodbcsql/lib64 \
    --with-fgdb=/usr/local/FileGDB_API-64gcc51 && \
    make && make install && ldconfig

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/FileGDB_API-64gcc51/lib
CMD ["ogr2ogr", "--formats"]
