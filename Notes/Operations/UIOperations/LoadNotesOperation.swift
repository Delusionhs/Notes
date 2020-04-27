import Foundation

class LoadNotesOperation: AsyncOperation {

    private let loadFromDb: LoadNotesDBOperation
    private let dbQueue: OperationQueue

    private(set) var result: Bool? = false

    init(notebook: FileNotebook,
         token: String,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {

        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        self.dbQueue = dbQueue

        super.init()
        loadFromDb.completionBlock = {
            let loadFromBackend = LoadNotesBackendOperation(notebook: notebook, token: token)
            loadFromBackend.completionBlock = {
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
