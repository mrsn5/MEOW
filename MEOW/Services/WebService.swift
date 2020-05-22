//
//  WebService.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation
import os.log

typealias Response = (Data, URLResponse)

class Webservice<V>: LoadService {
    var session: URLSession
    private var cancellableMap = [URL: URLSessionDataTask]()
    private let concurrentCancellationQueue: DispatchQueue
    
    init(session: URLSession = .shared) {
        self.session = session
        self.concurrentCancellationQueue =
            DispatchQueue(
                label: "\(UUID()).\(Self.self).concurrentCancellationQueue",
                attributes: .concurrent)
    }
    
    func load(with url: URL,
              decode: @escaping ((Data?, URLResponse?)) -> V,
              handler: @escaping (Result<V, ServiceError>) -> ())
    {
        cancel(url: url)
        let request = URLRequest(url: url) // MARK:-TODO add api key
        
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            
            defer { self?.cancel(url: url) }
            
            if let error = error {
                handler(.failure(.network(description: error.localizedDescription)))
                OSLog.networkError(request: request, response: response)
                return
            }
            
            let result = decode((data, response))
            handler(.success(result))
            self?.cancel(url: url)
        }
        dataTask.resume()
        
        concurrentCancellationQueue.async(flags: .barrier) { [weak self] in
            self?.cancellableMap[url] = dataTask
        }
    }
    
    func cancel(url: URL) {
        concurrentCancellationQueue.async(flags: .barrier) { [weak self] in
            if let cancellable = self?.cancellableMap[url] {
                cancellable.cancel()
                self?.cancellableMap.removeValue(forKey: url)
            }
        }
    }
}

