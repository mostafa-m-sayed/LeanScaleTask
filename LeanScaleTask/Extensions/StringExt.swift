//
//  StringExt.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 27/09/2021.
//

import Foundation
import UIKit
extension String {
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: .utf8)
        else { return nil }
        do {
            let str = try NSAttributedString(data: data,
                                             options: [.documentType: NSAttributedString.DocumentType.html],
                                             documentAttributes: nil)
            return str
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
