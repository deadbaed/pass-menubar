//
//  Password.swift
//  pass-menubar
//
//  Created by phil on 05/04/2021.
//

import Foundation
import Files

func passwordList(path: String) -> [Password] {
    var array: [Password] = []

    if path.isEmpty {
        return array
    }

    do {
        let root_passwordstore = try Folder(path: path)
        for file in root_passwordstore.files.recursive {

            // We are interested in files that have file extension ".gpg"
            if file.path.suffix(4) != ".gpg" {
                continue
            }

            let path = file.path
            let relativePath = file.path(relativeTo: root_passwordstore)
            let password = Password(path: path, relativePath: relativePath)
            array.append(password)
        }
    } catch {}
    return array
}

struct Password: Identifiable, Hashable {
    let id = UUID()
    var path: String
    var display: String

    init(path: String, relativePath: String) {
        self.path = path

        // Construct display name
        self.display = relativePath
        self.display.removeLast(4) // Don't display ".gpg"
    }
}
