import Foundation

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: BackendResult?
    
    init(notes: [Note]) {
        super.init()
    }
    
    override func main() {
        result = .failure(.unreachable)
        finish()
    }
}
