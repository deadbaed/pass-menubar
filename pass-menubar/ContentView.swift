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

                    Button(action: {
                        self.needle = ""
                    }, label: {
                        Image(systemName: "delete.left")
                    })
                        .disabled(needle.isEmpty)
                        .buttonStyle(BorderlessButtonStyle())
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

    for index in password.display.indices {
        let char = Text(String(password.display[index]))
        if indices.contains(index) {
            // swiftlint:disable shorthand_operator
            result = result + char.bold()
        } else {
            // swiftlint:disable shorthand_operator
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
