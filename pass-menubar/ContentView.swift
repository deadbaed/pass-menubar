//
//  ContentView.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI
import Files

func get_list_passwords(path: String) -> [String] {
    var array: [String] = []

    var root_passwordstore: Folder
    do {
        root_passwordstore = try Folder(path: path)
        for file in root_passwordstore.files.recursive {

            // We are interested in files that have file extension ".gpg"
            let file_ext = String(file.path.suffix(4))
            if file_ext != ".gpg" {
                continue
            }

            var displayName = file.name
            displayName.removeLast(4) // Don't display ".gpg"

            // Display subfolder names inside password store
            // FIXME: works only for one parent folder
            if file.parent != root_passwordstore {
                displayName = file.parent!.name + "/" + displayName
            }

            // TODO: store everything inside struct
            print(file.path)
            print(displayName)

            array.append(displayName)
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
            }.padding(5)

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0 ..< list_files.count) { value in
                        Text(list_files[value]).padding(.leading, 5)
                        Divider()
                    }
                }.frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }.padding(5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
