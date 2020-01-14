//
//  ViewController.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {
    
    let viewModel = ViewControllerBussinessService()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.uiUpdate = self
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }

    @IBAction func download(_ sender: UIButton) {
        actionStartDownload()
    }
}

extension ViewController: ViewControllerUserAction {
    
    public func actionStartDownload() {
        guard let url = viewModel.getFileURL() else {
            return
        }
        viewModel.downloadFileWithURL(url)
    }
}


public protocol ViewControllerUserAction {
    func actionStartDownload()
}


extension ViewController: ViewControllerBusinessLogicNotify {
    
    public func updateUIWithDownloadProgress(_ percentageString: String) {
        self.label.text = percentageString
    }
    
    
    public func updateUIWithDownloadingError(_ stringError: String) {
        activityIndicator.stopAnimating()
        downloadBtn.isUserInteractionEnabled = true
        let alert = UIAlertController(title: "Thông báo", message: stringError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
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

public protocol ViewControllerBusinessLogicNotify: class {
    
    func updateUIWithSaveFiledURL(_ url: URL)
    func updateUIWhenStartDownload()
    func updateUIWithDownloadingError(_ stringError: String)
    func updateUIWithDownloadProgress(_ percentageString: String)
    
}

protocol ViewControllerBussinessLogic {
    
    func getFileURL() -> URL?

    /**
        Download file from a webserivce url adn return saved file url in local disk.
     
        - Parameter url: file url in webservice.
        - Returns: url of saved file in local disk.
    */
    func downloadFileWithURL(_ url: URL)
    
}

class ViewControllerBussinessService: NSObject, ViewControllerBussinessLogic {
    
    weak var uiUpdate: ViewControllerBusinessLogicNotify?
    
    func getFileURL() -> URL? {
        return URL(string:
        "http://ftp.jaist.ac.jp/pub/eclipse/oomph/epp/2019-12/R/eclipse-inst-mac64.dmg")
                //"https://image.shutterstock.com/image-photo/colorful-flower-on-dark-tropical-260nw-721703848.jpg")
    }
    
    func downloadFileWithURL(_ url: URL) {
        self.uiUpdate?.updateUIWhenStartDownload()
         URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main).downloadTask(with: url).resume()
    }
    
}

extension ViewControllerBussinessService: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.uiUpdate?.updateUIWithSaveFiledURL(location)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else { return }
        self.uiUpdate?.updateUIWithDownloadingError(error.localizedDescription)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let calculatedProgress = Int(100*(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)))
            DispatchQueue.main.async {[weak self] in
                
                self?.uiUpdate?.updateUIWithDownloadProgress("\(calculatedProgress)%")
        }
    }
}

