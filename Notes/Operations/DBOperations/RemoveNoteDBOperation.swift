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
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", note.uid)
        do {
            let fetchedObjects = try backgroundContext.fetch(fetchRequest)
            if fetchedObjects.isEmpty {
            } else {
                backgroundContext.delete(fetchedObjects[0])
                backgroundContext.performAndWait {
                    do {
                        try backgroundContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
        notebook.remove(with: note.uid)
        //notebook.saveToFile()
        finish()
    }
}
