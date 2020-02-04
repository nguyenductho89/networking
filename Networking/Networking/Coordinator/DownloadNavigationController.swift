//
//  DownloadNavigationController.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/16/20.
//  Copyright © 2020 thond. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    associatedtype Event
    func notify(event: Event)
}

extension DownloadNavigationController: Coordinator {
    
    func notify(event: DownloadNavigationController.Event) {
        switch event {
        case .introlToDownload:
            nextViewController()
            break
        case .downloadToDetail(let url):
            detailVC.model = url
            nextViewController()
            break
        }
    }
    enum Event {
        case downloadToDetail(String)
        case introlToDownload
    }
}

class DownloadNavigationController: UINavigationController {
    
    lazy var introVC: IntroDownloadViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "IntroDownloadViewController") as! IntroDownloadViewController
        vc.coordinator = self
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: vc, action: #selector(vc.rightBarButtonItemAction))
        self.title = "Intro"
        return vc
    }()
    
    lazy var downloadVC: DownloadViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DownloadViewController") as! DownloadViewController
        vc.coordinator = self
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: vc, action: #selector(vc.actionDidSelectCell))
               self.title = "Download"
        return vc
    }()
    
    lazy var detailVC: DetailDownloadViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailDownloadViewController") as! DetailDownloadViewController
        vc.title = "Detail"
        vc.coordinator = self
        return vc
    }()
    
    @objc func nextViewController() {
        guard let topViewController = self.topViewController else {
            return
        }
        if topViewController.isKind(of: IntroDownloadViewController.self) {
            self.pushViewController(downloadVC, animated: true)
        }
        if topViewController.isKind(of: DownloadViewController.self) {
            self.pushViewController(detailVC, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [introVC]
    }
}
