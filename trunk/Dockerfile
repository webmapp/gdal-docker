FROM ubuntu:16.04
MAINTAINER Cole Howard <cole@webmapp.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    build-essential \
    wget \
    curl \
    ca-certificates \
    apt-transport-https \
    zip \
    unzip \
    locales \
    python-dev \
    libspatialite-dev \
    sqlite3 \
    libpq-dev \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    libfreexl-dev \
    libproj-dev \
    libxml2-dev \
    libgeos-dev \
    libnetcdf-dev \
    libpoppler-dev \
    libhdf4-alt-dev \
    libhdf5-serial-dev && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8 && \
    curl --silent --show-error --retry 3 https://bootstrap.pypa.io/get-pip.py | python && \
    mkdir -p /data

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN curl --silent --show-error \
    https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl --silent --show-error \
    https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    unixodbc-dev \
    msodbcsql=13.1.4.0-1 \
    mssql-tools && \
    rm -rf /var/lib/apt/lists/*

ENV FGDB_SOURCE https://raw.githubusercontent.com/Esri/file-geodatabase-api/master/FileGDB_API_1.5/FileGDB_API_1_5_64gcc51.tar.gz
RUN curl --silent --show-error -o /usr/local/src/filgdb_api.tar.gz ${FGDB_SOURCE} && \
    tar -xzvf /usr/local/src/filgdb_api.tar.gz -C /usr/local && \
    rm /usr/local/FileGDB_API-64gcc51/lib/libstdc++.so.6 && \
    ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/local/FileGDB_API-64gcc51/lib/libstdc++.so.6

ENV GDAL_SOURCE https://github.com/OSGeo/gdal/archive/trunk.zip
RUN wget -O /usr/local/src/gdal-trunk.zip ${GDAL_SOURCE} && \
    unzip /usr/local/src/gdal-trunk.zip -d /usr/local/src && \
    cd /usr/local/src/gdal-trunk/gdal && \
    ./configure \
    --with-python \
    --with-geos \
    --with-spatialite \
    --with-pg \
    --with-freexl \
    --with-curl \
    --with-libkml \
    --with-wfs \
    --with-odbc=/opt/microsoft/msodbcsql/lib64 \
    --with-fgdb=/usr/local/FileGDB_API-64gcc51 \
    --with-static-proj4 && \
    make && make install && ldconfig

WORKDIR /data
VOLUME /data
ENV PATH "$PATH:/opt/mssql-tools/bin"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/FileGDB_API-64gcc51/lib"
CMD ["ogr2ogr", "--formats"]
