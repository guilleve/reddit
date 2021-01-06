//
//  MasterViewController.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation
import UIKit

class MasterViewController: UITableViewController {
    
    @IBOutlet var postListFooter: PostListFooter!
    var presenter: TopPostPresenter
    
    required init?(coder: NSCoder) {
        let repository = PostRepository(service: RedditService(urlSession: URLSession.shared),
                                        storage: UserDefaultsStorage())
        presenter = TopPostPresenter(repository: repository)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        refreshData()
        postListFooter.setState(.loading)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    }
    
    private func configureTableView() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .white
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        postListFooter.setSelector(target: self, selector: #selector(dismissAllPosts))
    }
    
    @objc private func refreshData() {
        postListFooter.setState(.hidden)
        presenter.getAllPost(
            onSuccess: {[weak self] in
                self?.tableView.reloadData()
                self?.endLoadingIndicator()
            }, onFail: {[weak self] error in
                self?.endLoadingIndicator()
                self?.showError(error: error)
            })
        tableView.reloadData()
    }
    
    private func endLoadingIndicator() {
        self.refreshControl?.endRefreshing()
        self.postListFooter.setState(presenter.postCount == 0 ? .hidden : .showButton)
    }
    
    private func dismiss(post: PostState) {
        if let index = self.presenter.dismiss(post: post) {
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    @objc private func dismissAllPosts() {
        presenter.dimissAllPost()
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        postListFooter.setState(.hidden)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow,
               let controller = (segue.destination as! UINavigationController).topViewController as? DetailViewController {
                let post = presenter.postAtIndex(indexPath.row)
                controller.post = post
                presenter.markAsRead(post: post)
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
        return presenter.postCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configfPostCell(presenter.postAtIndex(indexPath.row)) {[weak self] post in
            self?.dismiss(post: post)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter.postCount && !presenter.isLoading {
            postListFooter.setState(.loading)
            presenter.loadMore(
                onSuccess: { [weak self] newDataCount in
                    guard let self = self else { return }
                    self.postListFooter.setState(.showButton)
                    let startIndex = self.presenter.postCount - newDataCount
                    let endIndex = startIndex + newDataCount
                    let indexesToAdd = Array(startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                    self.tableView.performBatchUpdates({
                        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
                        self.tableView.insertRows(at:indexesToAdd, with: .fade)
                    }, completion: nil)
                },
                onFail: { [weak self] (error) in
                    self?.postListFooter.setState(.showButton)
                    self?.showError(error: error)
                })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = presenter.postAtIndex(indexPath.row)
        presenter.markAsRead(post: post)
        let cell = tableView.cellForRow(at: indexPath) as! PostCell
        cell.markPostCellAsRead()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = presenter.postAtIndex(indexPath.row)
            self.dismiss(post: post)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return postListFooter
    }

}
