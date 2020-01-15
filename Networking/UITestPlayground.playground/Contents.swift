import UIKit
import PlaygroundFramework
import PlaygroundSupport

//let bundle = Bundle(for: ViewController.self)
//let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//let controller = storyboard.instantiateInitialViewController() as! ViewController
//let frame = controller.view.frame
//
//PlaygroundPage.current.needsIndefiniteExecution = true
//PlaygroundPage.current.liveView = controller
//
//controller.actionStartDownload()
////controller.updateUIWithSaveFiledURL(URL(string:"myurl.com")!)


let bundle = Bundle(for: ViewController.self)
let storyboard = UIStoryboard(name: "Main", bundle: bundle)
let child = storyboard.instantiateInitialViewController() as! ViewController


let (parent, _) = playgroundControllers(device: .phone4_7inch, orientation: .portrait, child: child)
let frame = parent.view.frame
PlaygroundPage.current.liveView = parent
parent.view.frame = frame

//child.actionStartDownload()
child.updateUIWithDownloadProgress("30%")

