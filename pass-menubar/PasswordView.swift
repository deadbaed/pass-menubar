//
//  PasswordView.swift
//  pass-menubar
//
//  Created by phil on 05/04/2021.
//

import SwiftUI
import Files

struct PasswordView: View {
    @State private var isHover = false
    let password: Password
    let display: Text
    @AppStorage("rawPathKey") private var rawPathKey = ""
    @AppStorage("rememberPassphrase") private var rememberPassphrase = false
    @State private var successKeychain = false

    var body: some View {
        display
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                do {
                    // Attempt to get passphrase from macos keychain
                    let keyId = extractPrivateKeyIdFromFile(path: rawPathKey)
                    try getPassphraseKeychain(keyId: keyId) { (passphrase) in
                        // Attempt to decrypt with passphrase from keychain
                        let result = try? decrypt(path: password.path, key: rawPathKey, passphrase: passphrase, remember: rememberPassphrase)
                        if let result = result {
                            // Display success view, and copy to clipboard
                            let decryptSuccessView = DecryptView(password: password, decrypted: result)
                            let controller = ViewWindowController(rootView: decryptSuccessView, title: password.display)
                            controller.openWindow()
                            successKeychain = true
                        }
                    }
                } catch {
                    print("error while decrypting with passphrase from macos keychain: \(error)")
                }
                if successKeychain == false {
                    let decryptView = DecryptView(password: password, decrypted: nil)
                    let controller = ViewWindowController(rootView: decryptView, title: password.display)
                    controller.openWindow()
                }
            }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let password = Password(path: "/Users/phil/.password-store/file.gpg", relativePath: "file")
        PasswordView(password: password, display: Text("file"))
    }
}
