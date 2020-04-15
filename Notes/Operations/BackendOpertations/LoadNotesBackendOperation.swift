import Foundation

class LoadNotesBackendOperation: BaseBackendOperation {
  var result: BackendResult?
  
  
  override func main() {
    result = .failure(.unreachable)
    finish()
  }
  
}
