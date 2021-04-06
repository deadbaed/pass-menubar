//
//  Password.swift
//  pass-menubar
//
//  Created by phil on 05/04/2021.
//

import Foundation
import Files

/// Get parent folders of file
private func get_parent_folders(root_folder: Folder, file: File) -> String {
    var folder : Folder = file.parent!
    var string = ""

    // While we don't reach root folder, add each parent folder to array
    while folder != root_folder {
        string = folder.name + "/" + string
        folder = folder.parent!
    }

    return string
}

struct Password: Identifiable {
    let id = UUID()
    var file: File
    var display: String

    init(file: File, rootFolder: Folder) {
        self.file = file

        // Construct display name
        self.display = self.file.name
        self.display.removeLast(4) // Don't display ".gpg"

        // Display subfolder names inside password store
        let displayFolders = get_parent_folders(root_folder: rootFolder, file: self.file)

        self.display = displayFolders + self.display
    }
}
