//
//  UIImageView+Extension.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/5/21.
//

import Foundation
import UIKit

extension UIImageView {
    
    private func loadImageFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        self.image = UIImage(systemName: "photo")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func setImage(fromURL urlStr : String?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let urlStr = urlStr, let url = URL(string: urlStr) else { return }
        loadImageFromServer(url: url, contentMode: mode)
    }
}
