//
//  ContentView.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI
import Files

func get_list_passwords(path: String) -> [Password] {
    var array: [Password] = []

    var root_passwordstore: Folder
    do {
        root_passwordstore = try Folder(path: path)
        for file in root_passwordstore.files.recursive {

            // We are interested in files that have file extension ".gpg"
            let file_ext = String(file.path.suffix(4))
            if file_ext != ".gpg" {
                continue
            }

            let password = Password(file: file, rootFolder: root_passwordstore)
            array.append(password)
        }
    } catch {}
    return array
}

struct ContentView: View {
    @State var search = ""
    
    // TODO: replace by path stored (add new variable isValidPath)
    let list_files = get_list_passwords(path: "~/.password-store")

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
