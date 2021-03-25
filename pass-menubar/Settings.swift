//
//  Settings.swift
//  newnew-swiftui
//
//  Created by phil on 25/03/2021.
//

import SwiftUI
import Files
import ObjectivePGP

private func detectPasswordStore(path: String, text: inout String) {
    if path.isEmpty {
        text = ""
        return
    }

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
    if path.isEmpty {
        text = ""
        return
    }

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

struct GeneralSettingsView: View {
    @AppStorage("rawPathPass") private var rawPathPass = ""
    @AppStorage("rawPathKey") private var rawPathKey = ""
    @State private var passStatus = ""
    @State private var keyStatus = ""

    var body: some View {
        VStack(alignment: .leading) {
            // Password store location
            Text("Password store").fontWeight(.bold)
            TextField("Enter path of directory", text: $rawPathPass, onCommit: {
                detectPasswordStore(path: rawPathPass, text: &passStatus)
            }).onAppear { detectPasswordStore(path: rawPathPass, text: &passStatus) }
            Text(passStatus)

            Divider()

            // PGP Key location
            Text("PGP Key").fontWeight(.bold)
            TextField("Enter path of file", text: $rawPathKey, onCommit: {
                loadPrivateKey(path: rawPathKey, text: &keyStatus)
            }).onAppear { loadPrivateKey(path: rawPathKey, text: &keyStatus) }
            Text(keyStatus)
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct SecuritySettingsView: View {
    @AppStorage("rememberPassphrase") private var rememberPassphrase = false

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Remember passphrase", isOn: $rememberPassphrase)
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, security
    }
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            SecuritySettingsView()
                .tabItem {
                    Label("Security", systemImage: "lock")
                }
                .tag(Tabs.security)
        }
        .padding(20)
        .frame(width: 375, height: 250)
    }
}
