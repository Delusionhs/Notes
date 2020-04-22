import Foundation

class RemoveNoteOperation: AsyncOperation {
    
  private let removeFromDb: RemoveNoteDBOperation
  private let dbQueue: OperationQueue
  
  private(set) var result: Bool? = false
  
  init(note: Note,
       notebook: FileNotebook,
       token: String,
       backendQueue: OperationQueue,
       dbQueue: OperationQueue) {
    
    removeFromDb = RemoveNoteDBOperation(note: note, notebook: notebook)
    self.dbQueue = dbQueue
    
    super.init()
    
    removeFromDb.completionBlock = {
      let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes, token: token)
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
    dbQueue.addOperation(removeFromDb)
  }
}
