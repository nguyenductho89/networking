//
//  DownloadViewControllerUsecase.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/15/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation

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
