//
//  Downloading.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation
/*:
    Downloading Files from Websites
    Download files directly to the filesystem.
 https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_from_websites
*/
extension NSError {
    func localizedStringError() -> String {
        switch self.code {
        case NSURLErrorUnsupportedURL:
            return NSLocalizedString("NSURLErrorUnsupportedURL", comment: "Sai url")
        default:
            return self.localizedDescription
        }
    }
}
final class Downloading {
    
    enum DownloadingError: Error {
        case clientSiteError(_ error: NSError)
        case serverSiteError(_ statusCode: Int)
        case fileError(_ stringError: String)
    }
    
    fileprivate class func downloadCompletionHandler(url: URL?,
                                               response: URLResponse?,
                                               error: Error?,
                                               handler: @escaping (Result<String, DownloadingError>) -> Void) {
        /*:
            Local (Client) problems
        */
        if let error = error as NSError? {
            handler(.failure(.clientSiteError(error)))
            return
        }
        /*:
            Server site problems with status code
        */
        if let response = response as? HTTPURLResponse,
        !(200..<300).contains(response.statusCode) {
            handler(.failure(.serverSiteError(response.statusCode)))
            return
        }
        /*:
            File received error
        */
        guard let fileUrl = url
        else {
            handler(.failure(.fileError("File Error")))
            return
        }
        /*:
            Move temporary file to disk
        */
        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let savedURL = documentsURL.appendingPathComponent(
                fileUrl.lastPathComponent)
            try FileManager.default.moveItem(at: fileUrl, to: savedURL)
            handler(.success(savedURL.absoluteString))
        } catch let error {
            handler(.failure(.fileError(error.localizedDescription)))
            return
        }
    }
    class func downloadFile(_ url: URL, completion: @escaping (Result<String, DownloadingError>) -> Void) {
        URLSession.shared.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in
            downloadCompletionHandler(url: urlOrNil, response: responseOrNil, error: errorOrNil, handler: completion)
        }.resume()
    }
    
    class func downloadFile2(_ url: URL,
                             delegate: URLSessionDelegate?,
                             delegateQuee: OperationQueue? ) {
        URLSession(configuration: .default, delegate: nil, delegateQueue: nil).downloadTask(with: url).resume()
    }
    
}
