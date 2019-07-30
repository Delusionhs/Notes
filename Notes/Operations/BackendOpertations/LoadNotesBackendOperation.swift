//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Igor Podolskiy on 30/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?
    
    init(notes: [Note]) {
        super.init()
    }
    
    override func main() {
        result = .failure(.unreachable)
        finish()
    }
}

