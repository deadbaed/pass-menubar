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
    
    DispatchQueue.global().sync {
        do {
            try keychain.accessibility(.whenUnlocked, authenticationPolicy: .userPresence)
                .set(passphrase, key: keyId)
        } catch let error {
            print(error)
        }
    }
}

func getPassphrase(keyId: String, completion: @escaping ((String) -> Void)) throws {
    let keychain = Keychain(service: "pass-menubar")
    
    DispatchQueue.global().sync {
        do {
            let optionalPassphrase = try keychain.get(keyId)
            
            if let passphrase = optionalPassphrase {
                print("got passphrase: \(passphrase)")
                completion(passphrase)
            }
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
