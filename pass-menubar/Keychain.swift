//
//  Keychain.swift
//  pass-menubar
//
//  Created by phil on 05/05/2021.
//

import Foundation
import KeychainAccess


enum KeychainAddError: Error {
    case noAppID
    case Keychain
    case other
}


func addPassphraseForKeyTouchID(keyId: String, passphrase: String) throws {
    guard let appId = Bundle.main.bundleIdentifier else {
        throw KeychainAddError.noAppID
    }
    let keychain = Keychain(service: appId)

    DispatchQueue.global().async {
        do {
            try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                .set(passphrase, key: keyId)
        } catch let error {
            print(error)
            // throw error
        }
    }
}
