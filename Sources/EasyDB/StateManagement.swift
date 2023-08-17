//
//  StateManagement.swift
//  
//
//  Created by Merli Mejia on 17/8/23.
//

import Foundation
import PostgresClientKit

class StateManagement{
    
    static let data = StateManagement()
    
    var connection: Connection? = nil
    
    private init(){
        
    }
}
