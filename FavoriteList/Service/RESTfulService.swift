//  RESTfulService.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

enum RESTfulError: Error, LocalizedError {
    case invalidCode(_: Int)
    case nilData
}

enum HTTPStatusCode: Int {
    case unKnownCode = -1
    case noStatusCode = 0
    case ok = 200
    case notModified = 304
    case badRequest = 400
    case notFound = 404
    case methodNotAllowed = 405
    case tooManyRequests = 429
    case internalServerError = 500
    case serviceUnavailable = 503
    
    var success: Bool {
        switch self {
        case .ok:
            return true
        case .unKnownCode, .noStatusCode, .notModified, .badRequest, .notFound, .methodNotAllowed, .tooManyRequests, .internalServerError, .serviceUnavailable:
            return false
        }
    }
}

enum RESTfulType {
    case get
    case post
    case put
    case delete
}

typealias ResfulHandler<T> = (Result<T, Error>) -> Void
typealias DownLoadHandler = (Data?, URLResponse?, Error?) -> Void

extension Result where Success == Void {
    static var success: Result {
        return Result.success(())
    }
}

class RESTfulService {
    private init() {}
    
    static func asyncRESTfulService<T: Decodable>(_ restfulType: RESTfulType, targetType: T.Type, url: URL, body: Data?, header: [String: String]?, completion: @escaping ResfulHandler<T>) {
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let timeoutInterval: TimeInterval = 10
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let param = header {
            for (key, value) in param {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _error = error {
                completion(.failure(_error))
                return
            }
            
            let code = HTTPStatusCode(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0)
            guard code?.success == true else {
                completion(.failure(RESTfulError.invalidCode(code?.rawValue ?? -1)))
                return
            }
            
            guard let _data = data else {
                completion(.failure(RESTfulError.nilData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: _data)
                completion(.success(result))
                return
            } catch(let error) {
                completion(.failure(error))
                print(error)
                return
            }
        }
        task.resume()
    }
    
    static func download(from url: URL, completion: @escaping DownLoadHandler) {
        URLSession.shared.dataTask(with: url) { data, resp, error in
            DispatchQueue.main.async {
                completion(data, resp, error)
            }
        }.resume()
    }
}
