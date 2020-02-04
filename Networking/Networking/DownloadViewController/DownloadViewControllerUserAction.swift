//
//  DownloadViewControllerAction.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/15/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation

public protocol DownloadViewControllerUserAction {
    func actionStartDownload()
    func actionAgreeResumeUncompletedDownload()
    func actionViewDeinit()
    func actionDidSelectCell()
}
extension DownloadViewController: DownloadViewControllerUserAction {
    @objc public func actionDidSelectCell() {
        coordinator?.notify(event: DownloadNavigationController.Event.downloadToDetail("https://thond.com"))
    }
    public func actionViewDeinit() {
        interator.usecaseShouldCancelUncompleteDownload()
    }
    public func actionAgreeResumeUncompletedDownload() {
        interator.usecaseResumeUncompletedDownload()
    }
    public func actionStartDownload() {
        guard let url = interator.usecaseGetFileURL() else {
            return
        }
        interator.usecaseDownloadFileWithURL(url)
    }
}
