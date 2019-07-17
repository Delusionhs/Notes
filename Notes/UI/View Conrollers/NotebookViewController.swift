//
//  NotebookViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 15/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit


class NotebookViewController: UIViewController, NoteEditViewControllerDelegate {
    
    @IBOutlet weak var notebookTableView: UITableView!
    var notebook = FileNotebook.myNotebook

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Заметки"
        notebookTableView.delegate = self
        notebookTableView.dataSource = self
        notebookTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "note")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote(_:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action:#selector(editNotebook(_:)))
        notebookTableView.tableFooterView = UIView() // not show empty cells

    }
    
    @objc func addNewNote(_ sender: Any) {
        performSegue(withIdentifier: "showNoteEdit", sender: nil)
    }
    
    @objc func editNotebook(_ sender: Any) {
        self.notebookTableView.isEditing = true
    }
    
    func reviceNote(note: Note) {
        self.notebook.add(note)
        self.notebookTableView.reloadData()
    }
    
}


extension NotebookViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! NoteTableViewCell
        cell.colorBox.backgroundColor = notebook.notes[indexPath.row].color
        cell.titleLabel?.text = notebook.notes[indexPath.row].title
        cell.dataLabel?.text = notebook.notes[indexPath.row].content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("test")
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNoteEdit", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //notebook.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NoteEditViewController {
            controller.delegate = self
            guard let indexPath = notebookTableView.indexPathForSelectedRow else { return }
            controller.note = notebook.notes[indexPath.row]
        }
    }
}
