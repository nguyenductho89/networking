//
//  IntroDownloadViewController.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/16/20.
//  Copyright © 2020 thond. All rights reserved.
//

import UIKit

class IntroDownloadViewController: UIViewController {
    weak var coordinator: DownloadNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func rightBarButtonItemAction() {
        coordinator?.notify(event: DownloadNavigationController.Event.introlToDownload)
    }
}
