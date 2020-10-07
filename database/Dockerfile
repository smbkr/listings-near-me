FROM debian:latest AS debian-with-libspatialite
RUN apt-get update && apt-get install -y \
  wget zip gcc make libz-dev libsqlite3-dev libgeos-dev libproj-dev
RUN wget http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.4.0-RC1.zip \
  -O libspatialite.zip && unzip -q libspatialite.zip
WORKDIR libspatialite-4.4.0-RC1
RUN  ./configure --enable-freexl=no --enable-libxml2=no
RUN make
RUN make install

FROM debian-with-libspatialite
RUN apt-get update && apt-get install -y ruby ruby-dev && gem install bundler
RUN mkdir database
COPY ["Gemfile", "Gemfile.lock", "make-db.rb", "Listed Buildings.zip", "/database/"]
WORKDIR /database
RUN bundle
