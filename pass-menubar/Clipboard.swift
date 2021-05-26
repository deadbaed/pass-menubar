//
//  Clipboard.swift
//  pass-menubar
//
//  Created by phil on 26/05/2021.
//

import Cocoa

func copyClipboard(str: String) -> Bool {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([.string], owner: nil)
    return pasteboard.setString(str, forType: .string)
}

func clearClipboard() -> Bool {
    return copyClipboard(str: "")
}
