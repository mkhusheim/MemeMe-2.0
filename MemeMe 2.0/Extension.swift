//
//  Extension.swift
//  MemeMe 1.0
//
//  Created by Meemi on 24/05/2021.
//

import Foundation
import UIKit

extension UIViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y = 0
    }
}

//extension UIView {
//    func cellDetailsStyle(corners: UIRectCorner, radius: CGFloat) {
//        let rectShape = CAShapeLayer()
//           rectShape.bounds = self.frame
//           rectShape.position = self.center
//        
//            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft ], cornerRadii: CGSize(width: 400, height: 400)).cgPath
//        
//           //Here I'm masking the textView's layer with rectShape layer
//            self.layer.mask = rectShape
//        
//     }
//}
