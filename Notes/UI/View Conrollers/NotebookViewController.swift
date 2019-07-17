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
        self.title = "Заметки"
        notebookTableView.delegate = self
        notebookTableView.dataSource = self
        notebookTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "note")
    }
}


extension NotebookViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! NoteTableViewCell
        //let cell = NoteTableViewCell()
        cell.colorBox.backgroundColor = notebook.notes[indexPath.row].color
        cell.titleLabel?.text = notebook.notes[indexPath.row].title
        cell.dataLabel?.text = notebook.notes[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNoteEdit", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NoteEditViewController {
            guard let indexPath = notebookTableView.indexPathForSelectedRow else { return }
            controller.note = notebook.notes[indexPath.row]
        }
    }
}
