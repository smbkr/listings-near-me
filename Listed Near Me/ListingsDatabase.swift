//
//  API.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import MapKit

enum DatabaseError: Error {
    case Open(message: String?)
    case Prepare(message: String?)
    case Bind(message: String)
    case Step(message: String)
}

fileprivate let dbPath = Bundle.main.path(forResource: "listed_buildings", ofType: "db")

class ListingsDatabase {
    
    private var dbPointer: OpaquePointer?
    
    private var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            return String(cString: errorPointer)
        } else {
            return "Unknown error"
        }
    }
    
    private init(db: OpaquePointer?) {
        self.dbPointer = db
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open() throws -> ListingsDatabase {
        var dbPointer: OpaquePointer?
        
        guard let dbPath = dbPath else {
            throw DatabaseError.Open(message: "Invalid DB path")
        }
        
        if sqlite3_open_v2(dbPath, &dbPointer, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
            let cache = spatialite_alloc_connection()
            spatialite_init_ex(dbPointer, cache, 0)
            return ListingsDatabase(db: dbPointer)
        } else {
            defer {
                if dbPointer != nil {
                    sqlite3_close(dbPointer)
                }
            }
        
            if let errorPointer = sqlite3_errmsg(dbPointer) {
                let message = String(cString: errorPointer)
                throw DatabaseError.Open(message: message)
            } else {
                throw DatabaseError.Open(message: "Unknown error opening DB")
            }
        }
    }
    
    private func prepareStatement(sql: String) throws -> OpaquePointer {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw DatabaseError.Prepare(message: self.errorMessage)
        }
        return statement!
    }
    
}
 
extension ListingsDatabase {
    private func loadListings(with statement: OpaquePointer) throws -> [Listing] {
        var listings = [Listing]()
        
        var result = sqlite3_step(statement)
        while result == SQLITE_ROW {
            guard let nameColumn = sqlite3_column_text(statement, 0),
                  let gradeColumn = sqlite3_column_text(statement, 1),
                  let listedDateColumn = sqlite3_column_text(statement, 2)
            else {
                throw DatabaseError.Step(message: errorMessage)
            }
            let lat = sqlite3_column_double(statement, 3)
            let long = sqlite3_column_double(statement, 4)
            
            let title = String(cString: nameColumn)
            let grade = Grade.init(rawValue: String(cString: gradeColumn))
            let listedDate = String(cString: listedDateColumn)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let listing = Listing(
                title: title,
                grade: grade,
                coordinate: coordinate,
                listedDate: listedDate
            )
            
            listings.append(listing)
            result = sqlite3_step(statement)
        }
        guard result == SQLITE_DONE else {
            throw DatabaseError.Step(message: errorMessage)
        }
        
        return listings
    }
    
    func getNear(_ location: CLLocation) throws -> [Listing] {
        let query = """
        SELECT
            lb.name,
            lb.grade,
            lb.list_date,
            Y(Transform(lb.geom, 4326)) "y",
            X(Transform(lb.geom, 4326)) "x",
            Distance(
                Transform(
                    MakePoint(?, ?, 4326),
                    27700
                ),
                lb.geom
            ) "distance"
        FROM listed_buildings lb
        ORDER BY distance
        LIMIT 25 OFFSET 0;
        """
        let stmnt = try prepareStatement(sql: query)
        defer {
            sqlite3_finalize(stmnt)
        }

        guard
            sqlite3_bind_double(stmnt, 1, Double(location.coordinate.longitude)) == SQLITE_OK,
            sqlite3_bind_double(stmnt, 2, Double(location.coordinate.latitude)) == SQLITE_OK
        else {
            throw DatabaseError.Bind(message: errorMessage)
        }
        
        return try loadListings(with: stmnt)
    }
    
    func withinBounds(_ rectangle: MKMapRect) throws -> [Listing] {
        let query = """
        SELECT
            lb.name,
            lb.grade,
            lb.list_date,
            Y(Transform(lb.geom, 4326)) "y",
            X(Transform(lb.geom, 4326)) "x"
        FROM listed_buildings lb
        WHERE Within(lb.geom, Transform(PolygonFromText(?, 4326), 27700)) > 0
        AND _ROWID_ >= (abs(random()) % (SELECT max(_ROWID_) FROM listed_buildings))
        LIMIT 1000;
        """
        let stmnt = try prepareStatement(sql: query)
        defer {
            sqlite3_finalize(stmnt)
        }

        let rectangleWKT = """
        POLYGON((
            \(rectangle.corners.nw.longitude) \(rectangle.corners.nw.latitude),
            \(rectangle.corners.ne.longitude) \(rectangle.corners.ne.latitude),
            \(rectangle.corners.se.longitude) \(rectangle.corners.se.latitude),
            \(rectangle.corners.sw.longitude) \(rectangle.corners.sw.latitude),
            \(rectangle.corners.nw.longitude) \(rectangle.corners.nw.latitude)
        ))
        """
        guard
            sqlite3_bind_text(stmnt, 1, rectangleWKT, -1, SQLITE_TRANSIENT) == SQLITE_OK
        else {
            throw DatabaseError.Bind(message: errorMessage)
        }
        
        print(String(cString: sqlite3_expanded_sql(stmnt)))
        
        return try loadListings(with: stmnt)
    }
}
