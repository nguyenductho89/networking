//
//  NetworkCapture.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation

final class NetworkCapture: URLProtocol {
    private static var entryItems = NetworkCaptureEntry()
    
    class func setup() {
    let isOk = URLProtocol.registerClass(NetworkCapture.self)
    assert(isOk, "NetworkCapture registration failed")
    URLSessionConfiguration.default.protocolClasses?.insert(NetworkCapture.self, at: 0)
    setupHandlers()
    }
    // If you return true here, this class will be instantiated and used
    override class func canInit(with request: URLRequest) -> Bool {
        let method = request.httpMethod ?? ""
        let url = request.url?.absoluteString ?? ""
        print("[\(method)] \(url)")

        return entryItems.isWantHook(request: request)
    }
    
    private static func setupHandlers() {
        // ★★★ Define HERE the stubs to register ★★★
        entryItems
            .add(urlString: {
                $0.contains("/maintenance")
            }, data: { _ in
                StubData.maintenance.asData()
            })
            .add(urlString: {
                $0.contains("/notice")
            }, data: { _ in
                StubData.notice.asData()
            })
            .add(urlString: {
                $0.contains("/error")
            }, data: { _ in
                StubData.empty.asData()
            }, error: { _ in
                NSError(domain: "test.api.error", code: 1, userInfo: nil) as Error
            })
    }

    // Return the processed request if needed, otherwise just return the original request.
     override class func canonicalRequest(for request: URLRequest) -> URLRequest {
         return request
     }

     // Used for cache comparison. If we don't need any caching, just return false.
     override class func requestIsCacheEquivalent(_ lhs: URLRequest, to rhs: URLRequest) -> Bool {
         return false
     }

     // This will be called at the start of the connection.
     override func startLoading() {
         guard let client = client, let url = request.url else {
             return
         }

         let result = type(of: self).entryItems.performHook(request: request)
         print("  * hooked")

         // Error handling
         if let error = result.error {
             client.urlProtocol(self, didFailWithError: error)
             return
         }

         // Success
         let commonHeaders: [String: String] = [
             "Content-Language": "ja",
             "Content-Type": "text/plain; charset=utf-8"
         ]
         if let response = HTTPURLResponse(url: url, statusCode: result.status, httpVersion: "1.0", headerFields: commonHeaders) {
             client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
         }
         if let data = result.data {
             client.urlProtocol(self, didLoad: data)
         }
         client.urlProtocolDidFinishLoading(self)
     }

     // This will be called at the end of the connection.
     override func stopLoading() {
     }
}

