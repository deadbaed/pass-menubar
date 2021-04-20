//
//  DecryptView.swift
//  pass-menubar
//
//  Created by phil on 12/04/2021.
//

import SwiftUI
import ObjectivePGP

func getUserId(path: String) -> String {
    var user = ""

    do {
        let keys = try ObjectivePGP.readKeys(fromPath: path)
        for key in keys {
            if let priv_key = key.secretKey {
                user = priv_key.primaryUser!.userID
            }
        }
    } catch {}
    return user
}

struct DecryptView: View {
    let password: Password
    @AppStorage("rawPathKey") private var rawPathKey = ""
    @State private var passphrase = ""

    var body: some View {
        VStack() {
            Text("Passphrase").font(.title)
            Text("Enter your passphrase to unlock the secret key.")
            Spacer()
            HStack {
                Text("Key ID: ")
                Text(getUserId(path: rawPathKey))
                Spacer()
            }
            HStack {
                Text("Passphrase: ")
                SecureField("", text: $passphrase)
                Spacer()
            }
        }.padding()
        Spacer()
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button("Cancel", action: {
                    NSApplication.shared.keyWindow?.close()
                }).keyboardShortcut(.cancelAction)
                Button("Decrypt", action: {
                    print($passphrase)
                    decrypt(path: password.path, key: rawPathKey, passphrase: passphrase)
                }).keyboardShortcut(.defaultAction)
            }.padding()
        }
    }
}

struct DecryptView_Previews: PreviewProvider {
    static var previews: some View {
        DecryptView(password: Password(path: "/Users/phil/.password-store/file.gpg", relativePath: "file"))
    }
}
