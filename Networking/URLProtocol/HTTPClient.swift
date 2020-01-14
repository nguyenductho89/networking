//
//  HTTPClient.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation

final class HttpClient {
    enum Error: Swift.Error {
        case invalidParameter(String)
    }

    /// RFC3986
    ///  https://tools.ietf.org/html/rfc3986#section-2.3
    ///  unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
    ///  ALPHA(%41-%5A and %61-%7A), DIGIT (%30-%39), hyphen (%2D), period (%2E), underscore (%5F), or tilde (%7E)
    ///
    ///  CharacterSet.alphanumerics US-ASCII plus unicode area, but not includes graphs.
    ///  CharacterSet.urlQueryAllowed [A-Za-z_~] are includes, but it is too much like '&', '/'
    static var urlAllowedInRfc3986: CharacterSet = {
        var allows = CharacterSet()
        allows.insert(charactersIn: Unicode.Scalar(0x41)...Unicode.Scalar(0x5a))
        allows.insert(charactersIn: Unicode.Scalar(0x61)...Unicode.Scalar(0x7a))
        allows.insert(charactersIn: Unicode.Scalar(0x30)...Unicode.Scalar(0x39))
        allows.insert(charactersIn: Unicode.Scalar(0x2d)...Unicode.Scalar(0x2d))
        allows.insert(charactersIn: Unicode.Scalar(0x2e)...Unicode.Scalar(0x2e))
        allows.insert(charactersIn: Unicode.Scalar(0x5f)...Unicode.Scalar(0x5f))
        allows.insert(charactersIn: Unicode.Scalar(0x7e)...Unicode.Scalar(0x7e))
        return allows
    }()

    /// GET communication
    func get(urlString: String, parameters: [String: Any] = [:], handler: @escaping (Any?, Swift.Error?) -> Void) {
        guard var url = URL(string: urlString) else {
            handler(nil, HttpClient.Error.invalidParameter(urlString))
            return
        }
        let escape: (String) -> String = { $0.addingPercentEncoding(withAllowedCharacters: HttpClient.urlAllowedInRfc3986) ?? $0 }

        if !parameters.isEmpty, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.percentEncodedQuery = parameters
                .compactMap {
                    (escape($0.key), escape("\($0.value)"))
                }
                .map {
                    "\($0.0)=\($0.1)"
                }
                .joined(separator: "&")
            if let newUrl = urlComponents.url {
                url = newUrl
            }
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                handler(json, nil)
            } else {
                handler(nil, error)
            }
        }
        task.resume()
    }
}
