//
//  Decrypt.swift
//  pass-menubar
//
//  Created by phil on 18/04/2021.
//

import ObjectivePGP

enum DecryptError: Error {
    case file
    case key
    case passphrase
    case line
    case decryption
    case stringConversion
}

func decrypt(path: String, key: String, passphrase: String, line: UInt) throws -> String {
    // load file from path as NSData
    guard let encrypted_data = FileManager.default.contents(atPath: path) else {
        throw DecryptError.file
    }

    // open pgp key
    guard let key = try? ObjectivePGP.readKeys(fromPath: key) else {
        throw DecryptError.key
    }

    // decrypt file
    guard let decrypted_data = try? ObjectivePGP.decrypt(encrypted_data, andVerifySignature: false, using: key, passphraseForKey: { (key) -> String? in
        return passphrase
    }) else {
        throw DecryptError.decryption
    }

    // convert raw bytes to a string
    guard let decrypted_str = String(data: decrypted_data, encoding: .utf8) else {
        throw DecryptError.stringConversion
    }

    // TODO: str to word array and get line
    // throw line error if can't find line

    return decrypted_str
}
