import Foundation

enum BackendResult {
    case success
    case failure(NetworkError)
}

enum NetworkError {
    case unreachable
}

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
}
