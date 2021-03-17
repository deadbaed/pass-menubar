//
//  GeneralPreferenceViewController.swift
//  pass-menubar
//
//  Created by phil on 21/02/2021.
//

import SwiftUI
import Preferences
import Files
import ObjectivePGP

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

private func detectPasswordStore(path: String, text: inout String) {
    var folder: Folder
    do {
        folder = try Folder(path: path)
    } catch {
        text = "⛔️ Invalid path"
        return
    }

    do {
        _ = try folder.file(named: ".gpg-id")
    } catch {
        text = "⛔️ Invalid password store"
        return
    }

    text = "✅ Password store detected"
}

private func loadPrivateKey(path: String, text: inout String) {
    var file: File
    do {
        file = try File(path: path)
    } catch {
        text = "⛔️ Invalid path"
        return
    }

    var keyID = ""
    do {
        let keys = try ObjectivePGP.readKeys(fromPath: file.path)
        for key in keys {
            if let priv_key = key.secretKey {
                keyID = "\(priv_key.keyID)"
                break
            }
        }
    } catch {
        text = "⛔️ Failed to load PGP key"
        return
    }

    text = "✅ Using PGP key 0x\(keyID)"
}

struct GeneralView: View {
    @AppStorage("rememberPassphrase") private var rememberPassphrase = false
    @AppStorage("useTouchID") private var useTouchID = false
    @AppStorage("rawPathPass") private var rawPathPass = ""
    @AppStorage("rawPathKey") private var rawPathKey = ""
    @State private var passStatus = ""
    @State private var keyStatus = ""
    private let contentWidth: Double = 450.0

    var body: some View {
        Preferences.Container(contentWidth: contentWidth) {
            Preferences.Section(title: "Password store location:") {
                HStack {
                    TextField("Enter path of directory", text: $rawPathPass)
                    Button("Validate", action: { detectPasswordStore(path: rawPathPass, text: &passStatus) })
                }.onAppear { detectPasswordStore(path: rawPathPass, text: &passStatus) }
                Text(passStatus).preferenceDescription()
            }
            Preferences.Section(title: "PGP key location:") {
                HStack {
                    TextField("Enter path of file", text: $rawPathKey)
                    Button("Validate", action: { loadPrivateKey(path: rawPathKey, text: &keyStatus) })
                }.onAppear { loadPrivateKey(path: rawPathKey, text: &keyStatus) }
                Text(keyStatus).preferenceDescription()
            }
            Preferences.Section(title: "Security") {
                Toggle("Remember key passphrase", isOn: $rememberPassphrase)
                Toggle("Use Touch ID", isOn: $useTouchID).disabled(rememberPassphrase == false)
            }
        }
    }
}
