//
//  DBModel.swift
//  PostgressTestStoryboard
//
//  Created by Merli Mejia on 17/8/23.
//

import Foundation
import PostgresClientKit

public protocol DBModel{
    associatedtype ModelType
    func print()
    func getColumnNames()->[String]
    func getConnection() -> Connection?
    var tableName:String { get set }
    static func fromJson(json: [String: String]) ->ModelType
}

public extension DBModel where ModelType: CustomStringConvertible{
    func getConnection() -> Connection?{
        return DBStateManagement.data.connection
    }
    func getColumnNames()->[String]{
        var arr: [String] = []
        let mirror = Mirror(reflecting: self)
        for case let (label?, _) in mirror.children {
            arr.append(label)
        }
        return arr
    }
    func print(){
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            Swift.print("\(label): \(value)")
        }
    }
    func selectAll()-> [ModelType]{
        var arr:[ModelType] = []
        guard let connection = getConnection() else{
            Swift.print("No connection yet")
            return []
        }
        
        do{
            let sql = "SELECT * from \(tableName);"
            let statement = try connection.prepareStatement(text: sql)
            
            let cursor = try statement.execute()
            
            let modelColumnNames = getColumnNames()
            for row in cursor {
                let colums = try row.get().columns
                var columnData: Dictionary<String, String> = [:]
                for (index, column) in colums.enumerated(){
                    if index == modelColumnNames.count{
                        break
                    }
                    if modelColumnNames[index] == "description"{
                        continue
                    }
                    let columnName = modelColumnNames[index]
                    columnData[columnName] = try column.string()
                }
                arr.append(Self.fromJson(json: columnData))
            }
            do {statement.close()}
            do { cursor.close() }
        }catch{
            Swift.print(error)
        }
        
        return arr
    }
    
    func selectFirst() ->ModelType?{
        return selectAll().first
    }
}
