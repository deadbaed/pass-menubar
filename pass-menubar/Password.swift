//
//  Password.swift
//  pass-menubar
//
//  Created by phil on 05/04/2021.
//

import Foundation
import Files

struct Password: Identifiable {
    let id = UUID()
    var file: File
    var display: String

    init(file: File, rootFolder: Folder) {
        self.file = file

        // Construct display name
        self.display = self.file.path(relativeTo: rootFolder)
        self.display.removeLast(4) // Don't display ".gpg"
    }
}
