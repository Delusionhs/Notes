import Foundation
import CoreData

class SaveNoteOperation: AsyncOperation {

  private let saveToDb: SaveNoteDBOperation
  private let dbQueue: OperationQueue

  private(set) var result: Bool? = false

  init(note: Note,
       notebook: FileNotebook,
       token: String,
       backendQueue: OperationQueue,
       dbQueue: OperationQueue,
       backgroundContext: NSManagedObjectContext) {

    saveToDb = SaveNoteDBOperation(note: note, notebook: notebook, backgroundContext: backgroundContext)
    self.dbQueue = dbQueue

    super.init()

    saveToDb.completionBlock = {
        let saveToBackend = SaveNotesBackendOperation(notebook: notebook, token: token)
      saveToBackend.completionBlock = {
        switch saveToBackend.result! {
        case .success:
          self.result = true
        case .failure:
          self.result = false
        }
        self.finish()
      }
      backendQueue.addOperation(saveToBackend)
    }
  }

  override func main() {
    dbQueue.addOperation(saveToDb)
  }
}
