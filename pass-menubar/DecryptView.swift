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
    @State private var invalidPassphrase = false

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
            if invalidPassphrase {
                Text("You entered an invalid passphrase. Please try again.").fontWeight(.bold)
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
                    do {
                        let decrypted_str = try decrypt(path: password.path, key: rawPathKey, passphrase: passphrase, line: 0)
                        print("decrypted passpword: \(decrypted_str)")
                        invalidPassphrase = false
                    } catch {
                        invalidPassphrase = true
                    }
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
