//
//  UITextField+extension.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/08.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
