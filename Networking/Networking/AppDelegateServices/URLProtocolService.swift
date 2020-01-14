//
//  URLProtocolService.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation
import UIKit

class URLProtocolService: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // usage
        NetworkCapture.setup()

        let apis: [String] = [
            "http://www.example.com/notice",
            "http://www.example.com/maintenance",
            "http://www.example.com/error",
            "http://www.example.com/notfound",
        ]
        apis.forEachAsync { urlString, next in
            HttpClient().get(urlString: urlString, parameters: ["foo": "bar", "baz": "1"]) { json, error in
                if let error = error {
                    print("  * Response Error: \(error)")
                } else if let json = json as? [String: [[String: Any]]] {
                    print("  * Response JSON(notice): \(json)")
                } else if let json = json as? [String: Any] {
                    print("  * Response JSON(maintenance): \(json)")
                } else {
                    print("  * Response Other: \(String(describing: json))")
                }
                next()
            }
        }
        return true
    }
}
