//
//  ViewController+Extension.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/6/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    //This method should take more parameters to customize text buttons and actions
    //It's simplified to gain time.
    func showAlert(_ title: String, message: String? = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
