//
//  ViewController.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import UIKit

public class DownloadViewController: UIViewController {
    
    let interator = DownloadViewControllerInteractor()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        interator.uiUpdate = self
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    override public func viewWillDisappear(_ animated: Bool) {
        actionViewWillDisappear()
    }
    @IBAction func download(_ sender: UIButton) {
        actionStartDownload()
    }
}

extension DownloadViewController: DownloadViewControllerUserAction {
    
    public func actionViewWillDisappear() {
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
