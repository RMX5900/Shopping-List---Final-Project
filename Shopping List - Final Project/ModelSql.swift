//
//  ModelSql.swift
//  Shopping List - Final Project
//
//  Created by Mac on 11/02/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import Foundation

extension String {
    public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
        if let (result, _) = String.decodeCString(cString, as: UTF8.self,
                                                  repairingInvalidCodeUnits: false) {
            self = result
        }
        else {
            return nil
        }
    }
}


class ModelSql{
    /*
    var database: OpaquePointer? = nil
    if sqlite3_open(path.absoluteString, &database) != 1 {
    print("Failed to open db file: \(path.absoluteString)")
    return nil
    }*/
    /*
    init?(){
        let dbFileName = "database9.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != 1 {
                print("Failed to open db file: \(path.absoluteString)")
                return nil
            }
        }
        /*
        if Student.createTable(database: database) == false{
            return nil
        }
        if LastUpdateTable.createTable(database: database) == false{
            return nil
        }
 */
    }*/
}
