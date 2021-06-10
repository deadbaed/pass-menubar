//
//  ContentView.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI
import Files

extension String {
    func fuzzyMatch(_ needle: String) -> Bool {
        if needle.isEmpty { return true }
        var remainder = needle[...]
        for char in self {
            if char == remainder[remainder.startIndex] {
                remainder.removeFirst()
                if remainder.isEmpty { return true }
            }
        }
        return false
    }
}

struct ContentView: View {
    @State var needle = ""
    let passwordList: [Password]
    @AppStorage("isKeyValid") private var isKeyValid = false

    var filtered: [Password] {
        passwordList.filter { $0.display.fuzzyMatch(needle) }
    }

    var body: some View {
        VStack {
            HStack {
                // search
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $needle)

                    if !needle.isEmpty {
                        Button(action: {
                            self.needle = ""
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
