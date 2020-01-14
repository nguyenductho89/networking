//
//  NetworkCapture+Extensions.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation

extension NetworkCapture {
    /// Hook definition container
    final class NetworkCaptureEntry {
        private var stringItems: [StringItem] = []

        /// Add a hook definition
        ///
        /// - Parameter urlString: true if it should hook.
        /// - Parameter data: Called when hooked. return the response data.
        /// - Parameter error: Called when hooked. Use it if you want to return an error.
        /// - Returns: Self (Usable for method chaining).
        @discardableResult
        func add(urlString: @escaping (String) -> Bool, data: @escaping (String) -> Data?, error: @escaping (String) -> Error? = { _ in nil }) -> NetworkCaptureEntry {
            stringItems.append(StringItem(urlString: urlString, data: data, error: error, status: { 200 }))
            return self
        }

        /// Judgment for the hook
        ///
        /// - Returns: true if should hook.
        func isWantHook(request: URLRequest) -> Bool {
            if let urlString = request.url?.absoluteString {
                return stringItems.contains(where: { $0.urlString(urlString) })
            }
            return false
        }

        /// Perform the hook operation
        ///
        /// - Parameter request: a request
        /// - Returns: response data, http status, error for response.
        func performHook(request: URLRequest) -> (data: Data?, status: Int, error: Error?) {
            var data: Data?
            var status = 404
            var error: Error?

            if let urlString = request.url?.absoluteString,
                let item = stringItems.first(where: { $0.urlString(urlString) }) {
                data = item.data(urlString)
                error = item.error(urlString)
                status = item.status()
            }

            return (data: data, status: status, error: error)
        }

        /// Hook definition
        private struct StringItem {
            var urlString: (String) -> Bool
            var data: (String) -> Data?
            var error: (String) -> Error?
            var status: () -> Int
        }
    }
}
