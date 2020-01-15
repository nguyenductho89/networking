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
    func actionViewWillDisappear()
}
