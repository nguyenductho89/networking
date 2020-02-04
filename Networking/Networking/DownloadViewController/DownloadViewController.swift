//
//  ViewController.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {
    weak var coordinator: DownloadNavigationController?
    let interator = DownloadViewControllerInteractor()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        interator.viewController = self
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
       
    }
    
    @IBAction func download(_ sender: UIButton) {
        actionStartDownload()
    }
    
    deinit {
        actionViewDeinit()
    }
}
