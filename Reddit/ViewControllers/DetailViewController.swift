//
//  DetailViewController.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation
import UIKit
import SafariServices
import AssetsLibrary
import Photos

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
    
    @IBAction private func imageTapped(_ sender: Any) {
        if let fullImageUrl = post?.imageUrl, let imageURL = URL(string : fullImageUrl) {
            let safariVC = SFSafariViewController(url: imageURL)
            self.navigationController?.present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction private func imageLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state != .began {
            guard let thumbnailImage = imageView.image else { return }
            let errorMsg = "You need to authorize media gallery access to the app from settings"
            PHPhotoLibrary.requestAuthorization({(status) in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges({
                        _ = PHAssetChangeRequest.creationRequestForAsset(from: thumbnailImage)
                    }, completionHandler: { (success, error) in
                        if success {
                            self.showAlert("Success!", message: "The image was successfully saved!")
                        }
                        else {
                            self.showAlert("Error!", message: errorMsg)
                        }
                    })
                } else {
                    self.showAlert("Error!", message: errorMsg)
                }
            })
        }
    }
}
