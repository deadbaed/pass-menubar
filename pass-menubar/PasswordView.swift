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
                print(password.file.path)
            }
    }
}

/*
struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let test: Password
        // TODO: provide a password store to test with pgp key
        PasswordView(password: test)
    }
}
*/
