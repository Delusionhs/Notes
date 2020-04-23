//
//  Gist.swift
//  Notes
//
//  Created by Igor Podolskiy on 23.04.2020.
//  Copyright © 2020 Igor Podolskiy. All rights reserved.
//

import Foundation

struct Gist: Codable {
    let url: String?
    let files: [String: GistFile]
}

struct GistFile: Codable {
    let filename: String?
    let content: String

}
