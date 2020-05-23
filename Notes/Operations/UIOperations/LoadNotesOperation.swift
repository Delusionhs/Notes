import Foundation
import CoreData

class LoadNotesOperation: AsyncOperation {

    private let loadFromDb: LoadNotesDBOperation
    private let dbQueue: OperationQueue

    private(set) var result: Bool? = false

    init(notebook: FileNotebook,
         token: String,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {

        loadFromDb = LoadNotesDBOperation(notesbook: notebook, backgroundContext: backgroundContext)
        self.dbQueue = dbQueue

        super.init()
        loadFromDb.completionBlock = {
            guard NetworkLayer.instance.isConnectedToNetwork() else {
                self.finish()
                return }
            let loadFromBackend = LoadNotesBackendOperation(notebook: notebook, token: token)
            loadFromBackend.completionBlock = {
                
                let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
                do {
                    let fetchedObjects = try backgroundContext.fetch(fetchRequest)
                    for object in fetchedObjects {
                        backgroundContext.delete(object)
                        try backgroundContext.save()
                    }
                } catch {
                    print(error)
                }
                
                let emptyNotebook = FileNotebook()
                
                for note in notebook.notes {
                    backendQueue.addOperation(SaveNoteDBOperation(note: note, notebook: emptyNotebook, backgroundContext: backgroundContext))
                }

                switch loadFromBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
            self.finish()
            }
            backendQueue.addOperation(loadFromBackend)
        }
    }

    override func main() {
        dbQueue.addOperation(loadFromDb)
    }
}
