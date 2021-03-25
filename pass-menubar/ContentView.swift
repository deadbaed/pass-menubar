//
//  ContentView.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI

struct ContentView: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Hello, World!")
            TextField("Search password ...", text: $text)
            Button("open preferences") {
                NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
            }
            Button("quit app") {
                NSApp.terminate(self)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(text: .constant(""))
    }
}
