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

func removeAllKeys() throws {
    let keychain = Keychain(service: "pass-menubar")
    let keys = keychain.allKeys()

    do {
        for key in keys {
            try keychain.remove(key)
        }
    } catch {
        print("could not remove all keys from keychain")
        print(error)
    }
}
