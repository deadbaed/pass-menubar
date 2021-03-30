//
//  ContentView.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI

func get_list_passwords() -> [String] {
    ["phil", "papie", "laurene", "dim", "taz", "ana", "theo", "pierre", "wag",
    "aurelien", "garance", "quentin", "mottin", "vico", "peter", "kylian", "nathan",
    "ghassane", "charles", "pauline", "julia", "stephane", "laurence", "bruno"]
}

struct ContentView: View {
    @State var search = ""
    
    let list_files = get_list_passwords()

    var body: some View {
        VStack {
            HStack {
                // search
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $search)
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
