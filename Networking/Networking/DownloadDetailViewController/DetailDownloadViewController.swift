//
//  DetailDownloadViewController.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/16/20.
//  Copyright © 2020 thond. All rights reserved.
//

import UIKit

class DetailDownloadViewController: UIViewController {
    weak var coordinator: DownloadNavigationController?
    var model: String? {
        willSet {
           // self.detailLabel.text = newValue ?? ""
        }
    }
    @IBOutlet weak var detailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
