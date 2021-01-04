//
//  MasterViewController.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation
import UIKit

class MasterViewController: UITableViewController {
    
    var presenter: PostPresenter
    
    required init?(coder: NSCoder) {
        presenter = TopPostPresenter(service: RedditService(urlSession: URLSession.shared))
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getAllPost(
            onSuccess: {[weak self] posts in
                guard let self = self else { return }
                self.tableView.reloadData()
                print("Result: \(posts)")
            }, onFail: { error in
                print("Error")
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        return cell
    }
}
