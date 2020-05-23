//
//  OSLog.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let network = OSLog(subsystem: subsystem, category: "network")
    static let decoding = OSLog(subsystem: subsystem, category: "decoding")
    static let service = OSLog(subsystem: subsystem, category: "service")
    static let viper = OSLog(subsystem: subsystem, category: "view")
    
    
    static func networkError(request: URLRequest, response: URLResponse?) {
        networkLog(request: request, response: response, type: .error)
    }
    
    static func networkRequst(request: URLRequest, response: URLResponse?) {
        networkLog(request: request, response: response, type: .info)
    }
    
    private static func networkLog(request: URLRequest, response: URLResponse?, type: OSLogType) {
        let httpResponse = response as? HTTPURLResponse
        os_log(type, log: .network,
               "%s %d // %s",
               request.httpMethod ?? "",
               httpResponse?.statusCode ?? 0,
               request.url?.absoluteString ?? ""
        )
    }
    
    static func decodingError(error: ServiceError) {
        os_log(.error, log: .decoding,
               "[Decoding error] %s",
               error.localizedDescription
        )
    }
    
    static func defaultError(error: Error) {
        os_log(.error, log: .decoding,
               "[Default error] %s",
               error.localizedDescription
        )
    }
    
}
