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

struct GeneralView: View {
    @AppStorage("rememberPassphrase") private var rememberPassphrase = false
    @AppStorage("useTouchID") private var useTouchID = false
    private let contentWidth: Double = 450.0

    func test() {}

    var body: some View {
        Preferences.Container(contentWidth: contentWidth) {
            Preferences.Section(title: "Password store location:") {
                Button("Choose directory...", action: test)
                Text("Location of password store to use.")
                        .preferenceDescription()
            }
            Preferences.Section(title: "PGP key location:") {
                Button("Choose file...", action: test)
                Text("Location of key to use when decrypting passwords.")
                        .preferenceDescription()
            }
            Preferences.Section(title: "Security") {
                Toggle("Remember key passphrase", isOn: $rememberPassphrase)
                Toggle("Use Touch ID", isOn: $useTouchID).disabled(rememberPassphrase == false)
            }
        }
    }
}
