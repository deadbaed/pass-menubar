//
//  Settings.swift
//  newnew-swiftui
//
//  Created by phil on 25/03/2021.
//

import SwiftUI
import Files
import ObjectivePGP

private func detectPasswordStore(path: String, text: inout String, isValid: inout Bool) {
    if path.isEmpty {
        text = ""
        isValid = false
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
        isValid = false
        return
    }

    text = "✅ Password store detected"
    isValid = true
}

private func loadPrivateKey(path: String, text: inout String, isValid: inout Bool) {
    if path.isEmpty {
        text = ""
        isValid = false
        return
    }

    var file: File
    do {
        file = try File(path: path)
    } catch {
        text = "⛔️ Invalid path"
        isValid = false
        return
    }

    var keyID = ""
    do {
        let keys = try ObjectivePGP.readKeys(fromPath: file.path)
        keyID = extractKeyIdFromPrivateKey(keys: keys)
    } catch {
        text = "⛔️ Failed to load PGP key"
        isValid = false
        return
    }

    text = "✅ Using PGP key 0x\(keyID)"
    isValid = true
}

struct GeneralSettingsView: View {
    @AppStorage("rawPathPass") private var rawPathPass = ""
    @AppStorage("rawPathKey") private var rawPathKey = ""
    @AppStorage("isPassValid") private var isPassValid = false
    @AppStorage("isKeyValid") private var isKeyValid = false
    @State private var passStatus = ""
    @State private var keyStatus = ""

    var body: some View {
        VStack(alignment: .leading) {
            // Password store location
            Text("Password store").fontWeight(.bold)
            Text("Please restart the application after changing password store")
            TextField("Enter path of directory", text: $rawPathPass, onCommit: {
                detectPasswordStore(path: rawPathPass, text: &passStatus, isValid: &isPassValid)
            }).onAppear { detectPasswordStore(path: rawPathPass, text: &passStatus, isValid: &isPassValid) }
            Text(passStatus)

            Divider()

            // PGP Key location
            Text("PGP Key").fontWeight(.bold)
            TextField("Enter path of file", text: $rawPathKey, onCommit: {
                loadPrivateKey(path: rawPathKey, text: &keyStatus, isValid: &isKeyValid)
            }).onAppear { loadPrivateKey(path: rawPathKey, text: &keyStatus, isValid: &isKeyValid) }
            Text(keyStatus)
        }
        .padding(5)
        .frame(width: 450, height: 200)
    }
}

struct SecuritySettingsView: View {
    @AppStorage("rememberPassphrase") private var rememberPassphrase = false

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Remember passphrase", isOn: $rememberPassphrase)
        }
        .padding(5)
        .frame(width: 450, height: 200)
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
        .frame(width: 500, height: 250)
    }
}
