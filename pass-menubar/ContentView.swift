//
//  ContentView.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI

struct ContentView: View {
    @Binding var text: String
    @AppStorage("rawPathPass") private var rawPathPass = ""
    
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
            }.padding(5)

            TextField("Search password ...", text: $text)
            ScrollView {
                VStack {
                    ForEach(0..<100) {
                        Text("Row \($0)")
                    }
                }.frame(maxWidth: .infinity)
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(text: .constant(""))
    }
}
