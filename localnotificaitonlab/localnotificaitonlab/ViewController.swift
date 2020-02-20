//
//  ViewController.swift
//  localnotificaitonlab
//
//  Created by Ahad Islam on 2/20/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var requests = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationWrapper.helper.checkForNotificationsPermissions()
        configureRefreshControl()
        loadRequests()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController, let createvc = nc.viewControllers[0] as? CreateViewController {
            createvc.delegate = self
        }
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadRequests), for: .valueChanged)
    }
    
    
    @objc private func loadRequests() {
        refreshControl.endRefreshing()
        NotificationWrapper.helper.getPendingNotifications { requests in
            self.requests = requests
            print(requests.count)
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timercell", for: indexPath)
        cell.textLabel?.text = requests[indexPath.row].content.title
        if let trigger = requests[indexPath.row].trigger as? UNTimeIntervalNotificationTrigger {
            cell.detailTextLabel?.text = trigger.nextTriggerDate()?.description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NotificationWrapper.helper.deleteNotification(requests[indexPath.row].identifier)
            requests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension ViewController: CreateViewControllerDelegate {
    func buttonDidPressed() {
        loadRequests()
    }
    
}
