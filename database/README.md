# Listed Buildings DB

This directory contains the tooling to generate a SQLite + Spatialite database
from Historic England datasets.

## Requirements

You need `Listed Buildings.zip`, downloadable from
https://services.historicengland.org.uk/NMRDataDownload/OpenPages/Download.aspx
as well as Docker to build the DB.

## Getting up and running

- Download the Listed Buildings data file described above and put it in this
  directory as `Listed Buildings.zip`
- Run `make` which will build & run the Docker container. This will create and
  populate "listed_buildings.db"
