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
    
    private func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw DatabaseError.Prepare(message: self.errorMessage)
        }
        return statement
    }
    
}
 
extension ListingsDatabase {
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
        
        var listings = [Listing]()
        while sqlite3_step(stmnt) == SQLITE_ROW {
            guard let nameColumn = sqlite3_column_text(stmnt, 0),
                  let gradeColumn = sqlite3_column_text(stmnt, 1),
                  let listedDateColumn = sqlite3_column_text(stmnt, 2)
            else {
                throw DatabaseError.Step(message: errorMessage)
            }
            let lat = sqlite3_column_double(stmnt, 3)
            let long = sqlite3_column_double(stmnt, 4)
            
            let name = String(cString: nameColumn)
            let gradeString = String(cString: gradeColumn)
            let grade = Grade.init(rawValue: gradeString)
            
            let dateFormatter = ISO8601DateFormatter()
            let listedDate = dateFormatter.date(from: String(cString: listedDateColumn))
            
            let location = Location(long: long, lat: lat)
            let listing = Listing(
                name: name,
                grade: grade,
                location: location,
                listedDate: listedDate
            )
            
            listings.append(listing)
        }
        
        return listings
    }
}
