//
//  FileManager.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/22.
//

import Foundation

class TLFileManager {
    private init() {}
    
    static func write<T: Encodable>(path: String, data: T) throws {
        let mainPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        guard let archivePath = mainPath?.appendingPathComponent(path) else { throw TLFileManagerError.archivePathNotFound }
        let objectData = try PropertyListEncoder().encode(data)
        let archiveData = try NSKeyedArchiver.archivedData(withRootObject: objectData, requiringSecureCoding: true)
        try archiveData.write(to: archivePath)
    }
    
    static func read<T: Decodable>(path: String) throws -> T {
        let mainPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        guard let archivePath = mainPath?.appendingPathComponent(path) else { throw TLFileManagerError.archivePathNotFound }
        let data = try Data(contentsOf: archivePath)
        let archiveData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data
        guard let _archiveData = archiveData else { throw TLFileManagerError.nilData }
        let items = try PropertyListDecoder().decode(T.self, from: _archiveData)
        return items
    }
}

enum TLFileManagerError: Error {
    case archivePathNotFound
    case nilData
}
