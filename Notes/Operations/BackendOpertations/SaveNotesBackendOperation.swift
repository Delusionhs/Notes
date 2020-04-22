import Foundation

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: BackendResult?
    var token: String = ""
    
    init(notes: [Note], token: String) {
        self.token = token
        super.init()
    }
    
    override func main() {
        result = .failure(.unreachable)
        finish()
    }
}
