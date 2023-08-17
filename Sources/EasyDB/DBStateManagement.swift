//
//  StateManagement.swift
//  
//
//  Created by Merli Mejia on 17/8/23.
//

import Foundation
import PostgresClientKit

public enum DBDialect{
    case mysql
    case postgresql
}

public struct DBConfig {
    public var host: String
    public var dbName: String
    public var user: String
    public var password: String
    public var ssl: Bool

    public init(host: String, dbName: String, user: String, password: String, ssl: Bool) {
        self.host = host
        self.dbName = dbName
        self.user = user
        self.password = password
        self.ssl = ssl
    }
}


public class DBStateManagement{
    
    static let data = DBStateManagement()
    
    var connection: Connection? = nil
    var dialect: DBDialect = .postgresql
    
    fileprivate func connectPostgreSQL(config:DBConfig)->Bool{
        var didConnected = true
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = config.host
            configuration.database = config.dbName
            configuration.user = config.user
            configuration.credential = .scramSHA256(password: config.password)
            configuration.ssl = config.ssl;

            DBStateManagement.data.connection = try PostgresClientKit.Connection(configuration: configuration)
        } catch {
            didConnected = false
            print(error) // better error handling goes here
        }
        return didConnected
    }
    
    func connect(config:DBConfig)-> Bool{
        if dialect == .postgresql{
            return connectPostgreSQL(config: config)
        }
        
        return false
    }
    
    private init(){
        
    }
}
