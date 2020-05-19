import Foundation
import CoreData

class RemoveNoteDBOperation: BaseDBOperation {
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
        notebook.remove(with: note.uid)
        //notebook.saveToFile()
        finish()
    }
}
