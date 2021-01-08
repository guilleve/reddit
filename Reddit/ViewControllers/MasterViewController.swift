//
//  MasterViewController.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation
import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var postListFooter: PostListFooter!
    var presenter: TopPostPresenter
    
    required init?(coder: NSCoder) {
        let repository = PostRepository(service: RedditService(urlSession: URLSession.shared),
                                        storage: PostStateStorage(storage: UserDefaultsStorage()))
        presenter = TopPostPresenter(repository: repository)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reddit Top Posts"
        configureTableView()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        postListFooter.setSelectors(target: self,
                                    dismissSelector: #selector(dismissAllPosts),
                                    resetSelector: #selector(resetPosts))
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl? = nil) {
        postListFooter.setState(sender != nil ? .hidden : .loading)
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
        tableView.refreshControl?.endRefreshing()
        postListFooter.setState(presenter.postCount == 0 ? .showResetButton : .showDismissButton)
    }
    
    private func dismiss(post: PostState) {
        if let index = presenter.dismiss(post: post) {
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    @objc private func dismissAllPosts() {
        presenter.dimissAllPost()
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        postListFooter.setState(.showResetButton)
    }
    
    @objc private func resetPosts() {
        presenter.resetPosts()
        refreshData()
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
        showAlert("Error!", message: "There has been an error when retrieving new data. Description: \(error.localizedDescription)")
    }
}

extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.postCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configfPostCell(presenter.postAtIndex(indexPath.row)) {[weak self] post in
            self?.dismiss(post: post)
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter.postCount && !presenter.isLoading {
            postListFooter.setState(.loading)
            presenter.loadMore(
                onSuccess: { [weak self] newDataCount in
                    guard let self = self else { return }
                    self.postListFooter.setState(.showDismissButton)
                    let startIndex = self.presenter.postCount - newDataCount
                    let endIndex = startIndex + newDataCount
                    let indexesToAdd = Array(startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                    self.tableView.performBatchUpdates({
                        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
                        self.tableView.insertRows(at:indexesToAdd, with: .fade)
                    }, completion: nil)
                },
                onFail: { [weak self] (error) in
                    self?.postListFooter.setState(.showDismissButton)
                    self?.showError(error: error)
                })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = presenter.postAtIndex(indexPath.row)
        presenter.markAsRead(post: post)        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = presenter.postAtIndex(indexPath.row)
            dismiss(post: post)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return postListFooter
    }

}
