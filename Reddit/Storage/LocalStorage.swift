//
//  LocalStorage.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/6/21.
//

import Foundation

protocol LocalStorage {
    func save(readPostIds: [String])
    func getReadPostIds() -> [String]
    func save(dismissedPostIds: [String])
    func getDismissedPostIds() -> [String]
    func clear()
}
