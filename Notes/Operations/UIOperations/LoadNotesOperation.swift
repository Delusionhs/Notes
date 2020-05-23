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
                
                for note in notebook.notes {
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
                            try backgroundContext.save()
                                     } catch {
                                         print(error)
                                     }
                            }
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
