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
    @Binding var search: String
    @AppStorage("rawPathPass") private var rawPathPass = ""
    
    let list_files = get_list_passwords()

    var body: some View {
        VStack {
            HStack {
                Text(rawPathPass)
                Spacer()
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
            }

           /* HStack {
                Image(systemName: "magnifyingglass")//.padding(.leading, 5)

                TextField("", text: $searchPassword).textFieldStyle(PlainTextFieldStyle())
                    .padding(0).font(.subheadline)

                Button(action: { self.searchPassword = "" }, label: { Image(systemName: "xmark.circle.fill") }).disabled(searchPassword.isEmpty)
                .buttonStyle(BorderlessButtonStyle())
            }.padding(5) */

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0 ..< list_files.count) { value in
                        Text(list_files[value]).padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
                        /* Button(action: { print(list_files[value])}, label: { Text(list_files[value]).padding(1) }) */
                    }
                }.frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }.padding(5)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(search: .constant(""))
    }
}
