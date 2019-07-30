//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Igor Podolskiy on 30/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: note.uid)
        finish()
    }
}
