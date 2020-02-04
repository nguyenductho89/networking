//
//  DownloadViewControllerInteractor.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/15/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation
import Network

protocol DownloadViewControllerUsecase {
    func usecaseGetFileURL() -> URL?
    /**
        Download file from a webserivce url adn return saved file url in local disk.
     
        - Parameter url: file url in webservice.
        - Returns: url of saved file in local disk.
    */
    func usecaseDownloadFileWithURL(_ url: URL)
    func usecaseResumeUncompletedDownload()
    func usecaseShouldCancelUncompleteDownload()
}

class DownloadViewControllerInteractor: NSObject {
    weak var viewController: DownloadViewControllerInteractorNotify?
    lazy private var _urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
    private var _downloadTask: URLSessionDownloadTask?
    private var _resumeData: Data?
    private let _monitor = NWPathMonitor()
    override init() {
        super.init()
        _monitor.pathUpdateHandler =
            {[weak self] path in
                if path.status == .satisfied && self?.isUncompledDownload() ?? false {
                    OperationQueue.main.addOperation {
                        self?.viewController?.updateUIWithResumableDownload()
                    }
                }
        }
        let queue = DispatchQueue(label: "thond.Networking.Monitor")
        _monitor.start(queue: queue)
    }
    private func handlerNetworkConnectivityStatus(_ path: NWPath) -> Void {
        weak var weakSelf = self
        if path.status == .satisfied && weakSelf?.isUncompledDownload() ?? false {
            OperationQueue.main.addOperation {
                weakSelf?.viewController?.updateUIWithResumableDownload()
            }
        } else {
            
        }
    }
    func isUncompledDownload() -> Bool {
        return (_resumeData != nil) ? true : false
    }
}
extension DownloadViewControllerInteractor: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.viewController?.updateUIWithSaveFiledURL(location)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else { return }
        let userInfo = (error as NSError).userInfo
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            _resumeData = resumeData
        }
        self.viewController?.updateUIWithDownloadingError(error.localizedDescription)
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let calculatedProgress = Int(100*(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)))
            DispatchQueue.main.async {[weak self] in
                self?.viewController?.updateUIWithDownloadProgress("\(calculatedProgress)%")
        }
    }
}
extension DownloadViewControllerInteractor: DownloadViewControllerUsecase {
    
    func usecaseShouldCancelUncompleteDownload() {
         _urlSession.invalidateAndCancel()
         _monitor.cancel()
    }
    
    func usecaseGetFileURL() -> URL? {
        return URL(string:
        "http://ftp.jaist.ac.jp/pub/eclipse/oomph/epp/2019-12/R/eclipse-inst-mac64.dmg")
                //"https://image.shutterstock.com/image-photo/colorful-flower-on-dark-tropical-260nw-721703848.jpg")
    }
    func usecaseDownloadFileWithURL(_ url: URL) {
        self.viewController?.updateUIWhenStartDownload()
        _downloadTask = _urlSession.downloadTask(with: url)
        _downloadTask?.resume()
    }
    func usecaseResumeUncompletedDownload() {
        guard let resumeData = _resumeData else {
            return
        }
        _downloadTask = _urlSession.downloadTask(withResumeData: resumeData)
        _downloadTask?.resume()
    }
}
