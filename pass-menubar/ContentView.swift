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
    
    // TODO: replace by path stored (add new variable isValidPath)
    let list_files = passwordList(path: "~/.password-store")

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

            List(list_files) { password in
                PasswordView(password: password)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
