//
//  UserDefaults+Extension.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/7/21.
//

import Foundation

extension UserDefaults {
    
    func getArray<T>(key: String, defaultValue: Array<T>) -> Array<T> {
        return self.object(forKey: key) as? Array<T> ?? defaultValue
    }

    func setArray<T>(_ newValue: Array<T>?, key: String) {
        self.set(newValue, forKey: key)
    }
    
}
