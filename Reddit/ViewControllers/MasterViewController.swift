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
        configureTableView()
        refreshData()
    }
    
    private func configureTableView() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .white
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        presenter.getAllPost(
            onSuccess: {[weak self] posts in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }, onFail: {[weak self] error in
                self?.refreshControl?.endRefreshing()
                self?.showError(error: error)
            })
        tableView.refreshControl?.beginRefreshing()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    }
    
    private func dismissPost(_ post: PostState) {
        if let index = self.presenter.dismissPost(post) {
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow,
               let controller = (segue.destination as! UINavigationController).topViewController as? DetailViewController {
                let post = presenter.posts[indexPath.row]
                controller.post = post
                presenter.markPostAsRead(post)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    private func showError(error: Error) {
        print("error \(error.localizedDescription)")
    }
}

extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.posts.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == presenter.posts.count {
            return tableView.dequeueReusableCell(withIdentifier: "LoadingMoreCell", for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configfPostCell(presenter.posts[indexPath.row]) {[weak self] post in
            self?.dismissPost(post)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= presenter.posts.count && !presenter.isLoading {
            presenter.loadMore(
                onSuccess: { [weak self] newData in
                    guard let self = self else { return }
                    let startIndex = self.presenter.posts.count - newData.count
                    let endIndex = startIndex + newData.count
                    let indexesToAdd = Array(startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                    self.tableView.performBatchUpdates({
                        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
                        self.tableView.insertRows(at:indexesToAdd, with: .fade)
                    }, completion: nil)
                },
                onFail: { [unowned self] (error) in
                    self.showError(error: error)
                })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = presenter.posts[indexPath.row]
        presenter.markPostAsRead(post)
        let cell = tableView.cellForRow(at: indexPath) as! PostCell
        cell.markPostCellAsRead()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = presenter.posts[indexPath.row]
            self.dismissPost(post)
        }
    }

}
