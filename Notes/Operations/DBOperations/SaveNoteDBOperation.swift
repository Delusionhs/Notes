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
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", note.uid)
        do {
            let fetchedObjects = try backgroundContext.fetch(fetchRequest)
            if fetchedObjects.isEmpty {
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
                
                backgroundContext.performAndWait {
                    do {
                        try self.backgroundContext.save()
                    } catch {
                        print(error)
                    }
                }
            } else {
                fetchedObjects[0].title = note.title
                fetchedObjects[0].content = note.content
                fetchedObjects[0].importance = note.importance.rawValue
                fetchedObjects[0].destructionDate = note.selfDestructionDate
                fetchedObjects[0].colorRed = Float(Color(uiColor: note.color).red)
                fetchedObjects[0].colorGreen = Float(Color(uiColor: note.color).green)
                fetchedObjects[0].colorBlue = Float(Color(uiColor: note.color).blue)
                fetchedObjects[0].colorAlpha = Float(Color(uiColor: note.color).alpha)
                
                backgroundContext.performAndWait {
                    do {
                        try self.backgroundContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
            
        } catch {
            print("Error")
        }
        
        notebook.add(self.note)
        
        
    
        finish()
    }
}
