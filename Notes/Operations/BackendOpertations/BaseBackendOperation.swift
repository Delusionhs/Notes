import Foundation

enum BackendResult {
    case success
    case failure(Error)
}

enum Error {
    case dataFailure
    case unreachable
}

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
}
