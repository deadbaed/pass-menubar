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

    var body: some View {
        Text(password.display)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(isHover ? Color.red : Color.clear)
            .onHover {
                self.isHover = $0
            }
            .onTapGesture {
                let decryptView = DecryptView(password: password)
                let controller = ViewWindowController(rootView: decryptView, title: password.display)
                controller.openWindow()
            }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(password: Password(path: "/Users/phil/.password-store/file.gpg", relativePath: "file"))
    }
}
