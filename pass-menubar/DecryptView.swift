//
//  DecryptView.swift
//  pass-menubar
//
//  Created by phil on 01/06/2021.
//

import SwiftUI

struct DecryptView: View {
    let password: Password
    @State var decrypted: String?

    var body: some View {
        if let decrypted = decrypted {
            DecryptSuccessView(password: password, decryptedPassword: decrypted)
        } else {
            DecryptPassphraseView(password: password, decryptedPassword: $decrypted)
        }
    }
}

struct DecryptView_Previews: PreviewProvider {
    static var previews: some View {
        let password = Password(path: "/Users/phil/.password-store/file.gpg", relativePath: "file")
        DecryptView(password: password, decrypted: nil)
    }
}
