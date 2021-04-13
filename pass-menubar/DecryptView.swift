//
//  DecryptView.swift
//  pass-menubar
//
//  Created by phil on 12/04/2021.
//

import SwiftUI

struct DecryptView: View {
    let password: Password
    @AppStorage("rawPathKey") private var rawPathKey = ""

    var body: some View {
        Text("Hello, World! \(password.path) \(rawPathKey)")
    }
}

struct DecryptView_Previews: PreviewProvider {
    static var previews: some View {
        DecryptView(password: Password(path: "/Users/phil/.password-store/file.gpg", relativePath: "file"))
    }
}
