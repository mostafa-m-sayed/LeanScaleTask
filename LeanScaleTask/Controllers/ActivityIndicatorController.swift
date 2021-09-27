//
//  ActivityIndicatorController.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 27/09/2021.
//

import Foundation
import UIKit
class ActivityIndicatorController {
    static var shared = ActivityIndicatorController()
    var alert: UIAlertController!
    func initializeAlert() {
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        }
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
    }
    
    func startLoading(vc: UIViewController) {
        vc.present(alert, animated: false, completion: nil)
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.alert.dismiss(animated: false, completion: nil)
        }
    }
}
