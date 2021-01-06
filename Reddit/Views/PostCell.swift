//
//  PostCell.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/5/21.
//

import Foundation
import UIKit


class PostCell: UITableViewCell {
    
    typealias DismissBlock = ((PostState) -> Void)
    
    @IBOutlet weak var readStatusIndicator: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var numOfCommentsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    
    private var onDismissPost: DismissBlock?
    private var post: PostState?
    
    func configfPostCell(_ post: PostState, onDismiss: @escaping DismissBlock) {
        self.post = post
        self.onDismissPost = onDismiss
        usernameLabel.text = post.userName
        titleLabel.text = post.title
        numOfCommentsLabel.text = post.numberOfComments
        readStatusIndicator.isHidden = post.read
        postedTimeLabel.text = post.postedTime
        if let thumbnailUrl = post.thumbnailUrl {
            thumbnailImageView.setImage(fromURL: thumbnailUrl)
        }
    }
    
    func markPostCellAsRead() {
        UIView.animate(withDuration: 0.5, animations: {
            self.readStatusIndicator.alpha = 0.0
        }, completion: { _ in
            self.readStatusIndicator.isHidden = true
        })
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        if let post = post {
            onDismissPost?(post)
        }
    }
}
