//
//  DecryptView.swift
//  pass-menubar
//
//  Created by phil on 12/04/2021.
//

import SwiftUI
import ObjectivePGP

func copyClipboard(str: String) -> Bool {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([.string], owner: nil)
    return pasteboard.setString(str, forType: .string)
}

func clearClipboard() -> Bool {
    return copyClipboard(str: "")
}

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
    @State private var askPassphrase = true
    @State private var timeLeft = 45
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        if (askPassphrase) {
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
                        do {
                            let result = try decrypt(path: password.path, key: rawPathKey, passphrase: passphrase, line: 0)
                            print("decrypted passpword: \(result)")
                            invalidPassphrase = false
                            if copyClipboard(str: result) == true {
                                print("copied to clipboard")
                                askPassphrase = false
                            } else {
                                print("failed to copy to clipboard")
                            }
                            // TODO: handle error cases and update message
                        } catch {
                            invalidPassphrase = true
                        }
                    }).keyboardShortcut(.defaultAction)
                }.padding()
            }
        } else {
            Text("Password has been copied to clipboard.")
            Text("Will clear in \(timeLeft) seconds.")
                .onReceive(timer) { _ in
                    if timeLeft > 0 {
                        timeLeft -= 1
                    } else {
                        // Clear clipboard and close window when timer is over
                        clearClipboard()
                        NSApplication.shared.keyWindow?.close()
                    }
                }
        }
    }
}

struct DecryptView_Previews: PreviewProvider {
    static var previews: some View {
        DecryptView(password: Password(path: "/Users/phil/.password-store/file.gpg", relativePath: "file"))
    }
}
