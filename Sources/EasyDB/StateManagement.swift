//
//  StateManagement.swift
//  
//
//  Created by Merli Mejia on 17/8/23.
//

import Foundation
import PostgresClientKit

public class DBStateManagement{
    
    static let data = DBStateManagement()
    
    var connection: Connection? = nil
    
    private init(){
        
    }
}
