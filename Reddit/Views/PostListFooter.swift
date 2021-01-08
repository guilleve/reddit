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
    case showDismissButton
    case hidden
    case showResetButton
}

class PostListFooter: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dismissAllButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    func setSelectors(target: Any, dismissSelector: Selector, resetSelector: Selector) {
        dismissAllButton.addTarget(target, action: dismissSelector, for: .touchUpInside)
        resetButton.addTarget(target, action: resetSelector, for: .touchUpInside)
    }
    
    func setState(_ state: PostListFooterState) {
        switch state {
        case .loading:
            activityIndicator?.isHidden = false
            dismissAllButton?.isHidden = true
            resetButton?.isHidden = true
        case .showDismissButton:
            activityIndicator?.isHidden = true
            dismissAllButton?.isHidden = false
            resetButton?.isHidden = true
        case .hidden:
            activityIndicator?.isHidden = true
            dismissAllButton?.isHidden = true
            resetButton?.isHidden = true
        case .showResetButton:
            activityIndicator?.isHidden = true
            dismissAllButton?.isHidden = true
            resetButton?.isHidden = false
            
        }
    }
}
