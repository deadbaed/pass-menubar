//
//  Keychain.swift
//  pass-menubar
//
//  Created by phil on 23/05/2021.
//

import Foundation
import KeychainAccess

func savePassphrase(keyId: String, passphrase: String) throws {
    let keychain = Keychain(service: "pass-menubar")
    
    DispatchQueue.global().async {
        do {
            try keychain.accessibility(.whenUnlocked, authenticationPolicy: .userPresence)
                .set(passphrase, key: keyId)
        } catch let error {
            print(error)
        }
    }
}

func getPassphrase(keyId: String) throws {
    let keychain = Keychain(service: "pass-menubar")
    
    DispatchQueue.global().async {
        do {
            let password = try keychain.get(keyId)
            
            print("got passphrase: \(password)")
        } catch let error {
            print(error)
        }
    }
}

func getAllKeys() {
    let keychain = Keychain(service: "pass-menubar")

    let keys = keychain.allKeys()
    for key in keys {
      print("key: \(key)")
    }
}
