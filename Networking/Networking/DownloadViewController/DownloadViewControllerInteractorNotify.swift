//
//  DownloadViewControllerInteractorNotify.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/15/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation
import UIKit

public protocol DownloadViewControllerInteractorNotify: class {
    func updateUIWithSaveFiledURL(_ url: URL)
    func updateUIWhenStartDownload()
    func updateUIWithDownloadingError(_ stringError: String)
    func updateUIWithDownloadProgress(_ percentageString: String)
    func updateUIWithResumableDownload()
}

extension DownloadViewController: DownloadViewControllerInteractorNotify {
    
    public func updateUIWithResumableDownload() {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn tiếp tục download dữ liệu", preferredStyle: .alert)
        let handler: ((UIAlertAction) -> Void) = {[weak self] action in
            self?.actionAgreeResumeUncompletedDownload()
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        self.present(alert, animated: true)
    }
    
    public func updateUIWithDownloadProgress(_ percentageString: String) {
        self.label.text = percentageString
    }
    
    public func updateUIWithDownloadingError(_ stringError: String) {
        activityIndicator.stopAnimating()
        downloadBtn.isUserInteractionEnabled = true
        let alert = UIAlertController(title: "Thông báo", message: stringError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.view.window?.rootViewController?.present(alert, animated: true)
    }
    
    public func updateUIWhenStartDownload() {
        activityIndicator.startAnimating()
        downloadBtn.isUserInteractionEnabled = false
    }
    
    public func updateUIWithSaveFiledURL(_ url: URL) {
        activityIndicator.stopAnimating()
        downloadBtn.isUserInteractionEnabled = true
        self.label.text = url.absoluteString
    }
}
