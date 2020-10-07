require "bundler/setup"
require "sqlite3"
require "dbf"
require "zip"
require "tempfile"
require "lucky_case"
require "ruby-progressbar"

dbf_temp = Tempfile.new("listed_buildings.dbf")
begin
    Zip::File.open("Listed Buildings.zip") do |zip_file|
        zip_file.entries.find { |e| e.name.end_with? ".dbf" }.extract(dbf_temp) { true }
    end

    table = DBF::Table.new(dbf_temp)
    db = SQLite3::Database.new("listed_buildings.db")

    puts "Creating table"
    create_table = <<-SQL
        DROP TABLE IF EXISTS "listed_buildings";
        CREATE TABLE "listed_buildings" (
            list_entry INTEGER,
            name TEXT,
            grade TEXT,
            list_date TEXT,
            amend_date TEXT,
            legacy_uid TEXT,
            ngr TEXT,
            capture_sca TEXT,
            easting REAL,
            northing REAL,
            hyperlink TEXT
        );
    SQL
    db.execute_batch(create_table)

    puts "Adding Spatialite extension"
    db.enable_load_extension(1)
    lib_spatialite_path = "/usr/local/lib/mod_spatialite"
    db.load_extension(File.expand_path(lib_spatialite_path))
    db.enable_load_extension(0)
    db.execute("SELECT InitSpatialMetaData()")
    db.execute("SELECT AddGeometryColumn('listed_buildings', 'geom', 27700, 'point', 'xy')")

    progressbar = ProgressBar.create(:title => "Inserting records (#{table.count})", :total => table.count)
    batch_size = 100
    table.each_slice(batch_size) do |batch|
        values = []
        batch.each do |row|
            values.push <<-SQL
            (
                #{row.list_entry},
                "#{row.name}",
                "#{row.grade}",
                "#{row.list_date}",
                "#{row.amend_date}",
                "#{row.legacy_uid}",
                "#{row.ngr}",
                "#{row.capture_sca}",
                #{row.easting},
                #{row.northing},
                "#{row.hyperlink}"
            )
            SQL
        end
        insert = <<-SQL
            INSERT INTO "listed_buildings" (
                list_entry,
                name,
                grade,
                list_date,
                amend_date,
                legacy_uid,
                ngr,
                capture_sca,
                easting,
                northing,
                hyperlink
            ) VALUES #{values.join(", ")}
        SQL
        begin
            db.execute(insert)
        rescue SQLite3::SQLException => err
            puts insert
            puts err
            exit 1
        end
        progressbar.progress += batch.length
    end

    puts "Adding geometries"
    add_geom = <<-SQL
        UPDATE listed_buildings
        SET geom = MakePoint(easting, northing, 27700);
    SQL
    db.execute(add_geom)
ensure
    [dbf_temp].each do |file|
        file.close
        file.unlink
    end
end
