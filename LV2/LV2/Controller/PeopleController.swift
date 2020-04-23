//
//  ViewController.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 22/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import UIKit

class PeopleController: UIViewController,AddEditDelegate,PersonCellDelegate{
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "peopleCell"
    let addEditIdentifier = "addEdit"
    lazy var viewModel: PeopleViewModel = PeopleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.target = self
        addButton.action = #selector(addClicked(sender:))
    }
    
    
    @objc func addClicked(sender: UIBarButtonItem){
        let vc = storyboard?.instantiateViewController(withIdentifier: addEditIdentifier) as! AddEditController
        vc.title = "Add new person"
        vc.edit = false
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func imageClicked(quote: String) {
        showToast(message: quote, font: UIFont.systemFont(ofSize: 10))
    }
    
    
}


extension PeopleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PersonCell
        cell.person = viewModel.getPerson(at: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: self.addEditIdentifier) as! AddEditController
            let person = self.viewModel.getPerson(at: indexPath.row)
            vc.title = person.name
            vc.viewModel.person = person
            vc.delegate = self
            vc.edit = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") {  (contextualAction, view, boolValue) in
            self.viewModel.removePerson(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        editAction.backgroundColor = .blue
        deleteAction.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [editAction,deleteAction])
        return swipeActions
    }
}


