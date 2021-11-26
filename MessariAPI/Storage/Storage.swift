//
//  Storage.swift
//  MessariAPI
//
//  Created by Lorenzo Limoli on 26/11/21.
//

import Foundation

public typealias Handler<T> = (Result<T, Error>) -> Void

public protocol ReadableStorage {
    func fetchValue(for key: String) throws -> Data
    func fetchValue(for key: String, handler: @escaping Handler<Data>)
}

public protocol WritableStorage {
    func save(value: Data, for key: String) throws
    func save(value: Data, for key: String, handler: @escaping Handler<Data>)
}

public typealias Storage = ReadableStorage & WritableStorage


public enum StorageError: Error{
    case notFound
    case cantWrite(Error)
}

public class DiskStorage {
    private let queue: DispatchQueue
    private let fileManager: FileManager
    private let folder: String

    init(
        folder: String,
        queue: DispatchQueue = .init(label: "DiskCache.Queue"),
        fileManager: FileManager = FileManager.default
    ) {
        self.folder = folder
        self.queue = queue
        self.fileManager = fileManager
    }
}


extension DiskStorage: WritableStorage {
    public func save(value: Data, for key: String) throws {
        do{
            let dir: URL = try fileManager.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                )
                .appendingPathComponent(folder)
                .appendingPathComponent(key)
            
            try createFolders(in: dir)
            try value.write(to: dir, options: .atomic)
        }catch{
            throw StorageError.cantWrite(error)
        }
    }

    public func save(value: Data, for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            do {
                try self.save(value: value, for: key)
                handler(.success(value))
            } catch {
                handler(.failure(error))
            }
        }
    }
}

extension DiskStorage: ReadableStorage {
    public func fetchValue(for key: String) throws -> Data {
        let dir: URL = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            .appendingPathComponent(folder)
            .appendingPathComponent(key)
        
        guard let data = try? Data(contentsOf: dir) else {
            throw StorageError.notFound
        }
        return data
    }

    public func fetchValue(for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            handler(Result { try self.fetchValue(for: key) })
        }
    }
}

extension DiskStorage {
    private func createFolders(in url: URL) throws {
        let folderUrl = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folderUrl.path) {
            try fileManager.createDirectory(
                at: folderUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
}
