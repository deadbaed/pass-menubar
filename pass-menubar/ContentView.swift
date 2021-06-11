//
//  ContentView.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI
import Files

extension String {
    func fuzzyMatch(_ needle: String) -> [String.Index]? {
        var ixs: [Index] = []
        if needle.isEmpty { return [] }
        var remainder = needle[...].utf8
        for idx in utf8.indices {
            let char = utf8[idx]
            if char == remainder[remainder.startIndex] {
                ixs.append(idx)
                remainder.removeFirst()
                if remainder.isEmpty { return ixs }
            }
        }
        return nil
    }
}

struct ContentView: View {
    @State var needle = ""
    let passwordList: [Password]
    @AppStorage("isKeyValid") private var isKeyValid = false

    var filtered: [(password: Password, indices: [String.Index])] {
        return passwordList.compactMap {
            guard let match = $0.display.fuzzyMatch(needle) else { return nil }
            return ($0, match)
        }
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
                List(filtered, id: \.password) { password in
                    highlight(password: password.password, indices: password.indices)
                }
            }
        }
    }
}

func highlight(password: Password, indices: [String.Index]) -> PasswordView {
    var result = Text("")

    for i in password.display.indices {
        let char = Text(String(password.display[i]))
        if (indices.contains(i)) {
            result = result + char.bold()
        } else {
            result = result + char.foregroundColor(.secondary)
        }
    }
    return PasswordView(password: password, display: result)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let list: [Password] = []
        ContentView(passwordList: list)
    }
}
