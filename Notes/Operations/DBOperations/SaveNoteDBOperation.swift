import Foundation
import CoreData

class SaveNoteDBOperation: BaseDBOperation {
    private let note: Note
    var backgroundContext: NSManagedObjectContext

    init(note: Note,
         notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        self.note = note
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }

    override func main() {
        
        let noteEntity = NoteEntity(context: backgroundContext)
        noteEntity.uid = note.uid
        noteEntity.title = note.title
        noteEntity.content = note.content
        noteEntity.importance = note.importance.rawValue
        noteEntity.destructionDate = note.selfDestructionDate
        noteEntity.colorRed = Float(Color(uiColor: note.color).red)
        noteEntity.colorGreen = Float(Color(uiColor: note.color).green)
        noteEntity.colorBlue = Float(Color(uiColor: note.color).blue)
        noteEntity.colorAlpha = Float(Color(uiColor: note.color).alpha)
        
        notebook.add(self.note)
        
        
    
        finish()
    }
}
