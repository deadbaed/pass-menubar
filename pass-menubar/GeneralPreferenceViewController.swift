//
//  GeneralPreferenceViewController.swift
//  pass-menubar
//
//  Created by phil on 21/02/2021.
//

import SwiftUI
import Preferences

let GeneralPreferencesViewController: () -> PreferencePane = {
    let paneView = Preferences.Pane(
            identifier: .general,
            title: "General",
            toolbarIcon: NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")!
    ) {
        GeneralView()
    }

    return Preferences.PaneHostingController(pane: paneView)
}

private class Path {
    private enum Kind {
        case Unknown
        case File
        case Directory
    }

    private var path: String
    private var kind: Kind

    init() {
        path = ""
        kind = Kind.Unknown
    }

    func load(newPath: String) {
        if newPath.isEmpty {
            return
        }
        path = newPath
        // set kind here
        print(path)
    }

    func isDir() -> Bool {
        kind == Kind.Directory ? true : false
    }

    func isFile() -> Bool {
        kind == Kind.File ? true : false
    }
}

struct GeneralView: View {
    @AppStorage("rememberPassphrase") private var rememberPassphrase = false
    @AppStorage("useTouchID") private var useTouchID = false
    @AppStorage("rawPathPass") private var rawPathPass = ""
    @AppStorage("rawPathKey") private var rawPathKey = ""
    private var pass = Path()
    private var key = Path()
    private let contentWidth: Double = 450.0

    var body: some View {
        Preferences.Container(contentWidth: contentWidth) {
            Preferences.Section(title: "Password store location:") {
                HStack {
                    TextField("Enter path of directory", text: $rawPathPass)
                    Button("Validate", action: { pass.load(newPath: rawPathPass) })
                }.onAppear { pass.load(newPath: rawPathPass) }
                Text("Say here if password store has been detected or not")
                        .preferenceDescription()
            }
            Preferences.Section(title: "PGP key location:") {
                HStack {
                    TextField("Enter path of file", text: $rawPathKey)
                    Button("Validate", action: { key.load(newPath: rawPathKey) })
                }.onAppear { key.load(newPath: rawPathKey) }
                Text("Say here if key has been found or not")
                        .preferenceDescription()
            }
            Preferences.Section(title: "Security") {
                Toggle("Remember key passphrase", isOn: $rememberPassphrase)
                Toggle("Use Touch ID", isOn: $useTouchID).disabled(rememberPassphrase == false)
            }
        }
    }
}
