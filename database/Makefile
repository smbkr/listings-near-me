all: listed_buildings.db

listed_buildings.db: container
	touch listed_buildings.db
	docker run \
	--mount type=bind,source="$(PWD)/listed_buildings.db",target=/database/listed_buildings.db \
	listed-buildings_db ruby make-db.rb

.PHONY: container
container: Listed\ Buildings.zip
	docker build . -t listed-buildings_db

Listed\ Buildings.zip:
	echo "Please download listed buildings dataset from https://services.historicengland.org.uk/NMRDataDownload/OpenPages/Download.aspx"

clean:
	rm database.db
