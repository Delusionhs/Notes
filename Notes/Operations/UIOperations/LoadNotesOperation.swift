//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Igor Podolskiy on 30/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import Foundation

class LoadNoteOperation: AsyncOperation {
    private let notebook: FileNotebook
    private let loadToDb: LoadNotesDBOperation
    private var loadToBackend: LoadNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.notebook = notebook
        
        loadToDb = LoadNotesDBOperation(notebook: notebook)
        
        super.init()
        
        loadToDb.completionBlock = {
            let loadToBackend = LoadNotesBackendOperation(notes: notebook.notes)
            self.loadToBackend = loadToBackend
            self.addDependency(loadToBackend)
            backendQueue.addOperation(loadToBackend)
        }
        
        addDependency(loadToDb)
        dbQueue.addOperation(loadToDb)
    }
    
    override func main() {
        switch loadToBackend!.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}

