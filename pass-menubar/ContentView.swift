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

    var folder: Folder
    do {
        folder = try Folder(path: path)
        folder.files.recursive.forEach { file in
            // TODO: check if ends with .gpg and remove from path

            // FIXME: remove !
            let x = file.parent!.name + "/" + file.name
            print(file)
            array.append(x)
        }
    } catch {
        array = ["phil", "papie", "laurene", "dim", "taz", "ana", "theo", "pierre", "wag",
               "aurelien", "garance", "quentin", "mottin", "vico", "peter", "kylian", "nathan",
               "ghassane", "charles", "pauline", "julia", "stephane", "laurence", "bruno"]
    }
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
