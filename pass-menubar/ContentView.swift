//
//  ContentView.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI
import Files

struct ContentView: View {
    @State var search = ""
    let passwordList: [Password]
    @AppStorage("isKeyValid") private var isKeyValid = false

    var filtered: [Password] {
        passwordList.filter { $0.display.contains(search) }
    }

    var body: some View {
        VStack {
            HStack {
                // search
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $search)

                    if !search.isEmpty {
                        Button(action: {
                            self.search = ""
                        }) {
                            Image(systemName: "delete.left")
                        }
                    } else {
                        EmptyView()
                    }
                }

                // settings
                Button(action: { NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil) },
                       label: {
                        Image(systemName: "gearshape.fill")
                       })

                // quit
                Button(action: {
                    NSApp.terminate(self)
                }, label: {
                    Image(systemName: "power")
                })
            }.padding(10)

            if passwordList.isEmpty {
                Text("No passwords to display").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if !isKeyValid {
                Text("No pgp key present").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List(filtered) { password in
                    PasswordView(password: password)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let list: [Password] = []
        ContentView(passwordList: list)
    }
}
