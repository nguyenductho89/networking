//
//  DownloadingService.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation
import UIKit

class DownloadingService: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //"https://image.shutterstock.com/image-photo/colorful-flower-on-dark-tropical-260nw-721703848.jpg"
        Downloading.downloadFile(URL(string: "https://image.shutterstock.com/image-photo/colorful-flower-on-dark-tropical-260nw-721703848.jpg")!) { (result) in
            switch result {
            case .success(let saveURLString):
                print(saveURLString)
            case .failure(let error):
                switch error {
                case .clientSiteError(let domainError):
                    print("❌" + "\(domainError.localizedStringError())")
                case .serverSiteError(let statusCode):
                    print("❌" + "\(statusCode)")
                case .fileError(let errorString):
                    print("❌" + errorString)
                }
            }
        }
        return true
    }
}
