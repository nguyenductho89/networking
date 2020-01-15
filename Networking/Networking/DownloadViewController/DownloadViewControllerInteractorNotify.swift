//
//  DownloadViewControllerInteractorNotify.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/15/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation

public protocol DownloadViewControllerInteractorNotify: class {
    func updateUIWithSaveFiledURL(_ url: URL)
    func updateUIWhenStartDownload()
    func updateUIWithDownloadingError(_ stringError: String)
    func updateUIWithDownloadProgress(_ percentageString: String)
    func updateUIWithResumableDownload()
}
