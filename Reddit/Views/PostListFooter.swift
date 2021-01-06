//
//  PostListFooter.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/6/21.
//

import Foundation
import UIKit

enum PostListFooterState {
    case loading
    case showButton
    case hidden
}

class PostListFooter: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var dismissAllButton: UIButton?
    
    func setSelector(target: Any, selector: Selector) {
        dismissAllButton?.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    func setState(_ state: PostListFooterState) {
        switch state {
        case .loading:
            activityIndicator?.isHidden = false
            dismissAllButton?.isHidden = true
        case .showButton:
            activityIndicator?.isHidden = true
            dismissAllButton?.isHidden = false
        case .hidden:
            activityIndicator?.isHidden = true
            dismissAllButton?.isHidden = true
        }
    }
}
