//
//  DetailViewController.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var post: PostState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            titleLabel.text = post.title
            usernameLabel.text = post.userName
            imageView.setImage(fromURL: post.thumbnailUrl)
        }
    }
}
