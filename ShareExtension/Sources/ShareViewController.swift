//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Seshadri Mahalingam on 2024-03-29.
//

import UIKit
import Social
import UniformTypeIdentifiers
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    getURL()
  }

  private func showAlert(baseUri: String?) {
    // create the alert
    let alert = UIAlertController(title: "Sharing URL", message: "Here's the base URI: \(baseUri ?? "NO URI FOUND")", preferredStyle: UIAlertController.Style.alert)

    // add an action (button)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    // show the alert
    self.present(alert, animated: true, completion: nil)
  }

  private func getURL() {
    let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
    let itemProvider: NSItemProvider = (extensionItem.attachments?.first!)!
    let propertyList = String(kUTTypePropertyList)
    if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
      itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
        guard let dictionary = item as? NSDictionary else { return }
        OperationQueue.main.addOperation {
          let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary
          let urlString = results?["baseURI"] as! String?
          self.showAlert(baseUri: urlString)
        }
      })
    } else {
      print("error")
    }
  }

  func close() {
    // Inform the host that we're done, so it un-blocks its UI.
    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
  }

  override func didSelectPost() {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    close()
  }

  override func configurationItems() -> [Any]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return []
  }

}
