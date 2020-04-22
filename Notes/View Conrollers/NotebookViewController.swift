//
//  NotebookViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 15/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit


class NotebookViewController: UIViewController, NoteEditViewControllerDelegate {
    
    private var token: String = "" // github OAuth token
    
    private let backendQueue = OperationQueue()
    private let dbQueue = OperationQueue()
    private let commonQueue = OperationQueue()
    
    @IBOutlet weak var notebookTableView: UITableView!
    
    var notebook: FileNotebook = FileNotebook() //= FileNotebook.myNotebook

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadNotesOperation = LoadNotesOperation(notebook: notebook,
                                                    token: token,
                                                    backendQueue: backendQueue,
                                                    dbQueue: dbQueue)
        commonQueue.addOperation(loadNotesOperation)
        
        self.notebookTableView.reloadData()
        
        self.title = "Заметки"
        tabBarController?.tabBar.items![1].title = "Галерея" // update gallery tabbar name
        tabBarController?.tabBar.items![0].image = UIImage(named: "TabNotes")
        tabBarController?.tabBar.items![1].image = UIImage(named: "TabGallery")
        notebookTableView.delegate = self
        notebookTableView.dataSource = self
        notebookTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "note")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote(_:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action:#selector(editNotebook(_:)))
        notebookTableView.tableFooterView = UIView() // not show empty cells
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !token.isEmpty else {
            requestToken()
            return
        }
    }
    
    @objc func addNewNote(_ sender: Any) {
        performSegue(withIdentifier: "showNoteEdit", sender: nil)
    }
    
    @objc func editNotebook(_ sender: Any) {
        if(self.notebookTableView.isEditing == true)
        {
            self.notebookTableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
        else
        {
            self.notebookTableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
    }
    
    private func requestToken() {
        let requestTokenViewController = AuthViewController()
        requestTokenViewController.delegate = self
        present(requestTokenViewController, animated: true, completion: nil)
    }
    
    func reciveNote(note: Note) {
        let saveNoteOperation = SaveNoteOperation(note: note,
                                                  notebook: notebook,
                                                  token: self.token,
                                                  backendQueue: backendQueue,
                                                  dbQueue: dbQueue)
        commonQueue.addOperation(saveNoteOperation)
        saveNoteOperation.completionBlock = {
            OperationQueue.main.addOperation {
                self.notebookTableView.reloadData()
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNoteEdit", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isEditing != true {
            return true
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { //disable delete action on noediting
            if tableView.isEditing {
                return .delete
            }
            return .delete

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, tableView.isEditing == true {
            //notebook.notes.remove(at: indexPath.row)
            let note = notebook.notes[indexPath.row]
            let removeNotesOperation = RemoveNoteOperation(note: note,
                                                           notebook: notebook,
                                                           token: self.token,
                                                           backendQueue: backendQueue,
                                                           dbQueue: dbQueue)
            commonQueue.addOperation(removeNotesOperation)
            removeNotesOperation.completionBlock = {
              DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .automatic)
              }
            }
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

extension NotebookViewController: AuthViewControllerDelegate {
    func tokenChanged(token: String) {
        self.token = token
    }
}
