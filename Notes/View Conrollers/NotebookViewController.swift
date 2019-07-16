//
//  NotebookViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 15/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

class NotebookViewController: UIViewController {
    
    @IBOutlet weak var notebookTableView: UITableView!
    var notebook = FileNotebook.myNotebook

    override func viewDidLoad() {
        super.viewDidLoad()
        notebookTableView.delegate = self
        notebookTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

}

extension NotebookViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = notebook.notes[indexPath.row].title
        cell.detailTextLabel?.text = notebook.notes[indexPath.row].content
        return cell
    }
    
}
