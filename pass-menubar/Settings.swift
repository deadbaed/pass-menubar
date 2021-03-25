//
//  Settings.swift
//  newnew-swiftui
//
//  Created by phil on 25/03/2021.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0

    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            Slider(value: $fontSize, in: 9...96) {
                Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct SecuritySettingsView: View {
    @AppStorage("rememberPassphrase") private var rememberPassphrase = true

    var body: some View {
        Form {
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
        .frame(width: 375, height: 150)
    }
}
