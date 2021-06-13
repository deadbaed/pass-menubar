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
    case line
    case decryption
    case stringConversion
}

func extractKeyIdFromFile(path: String) -> String {
    guard let keys = try? ObjectivePGP.readKeys(fromPath: path) else {
        return ""
    }
    return extractKeyIdFromPrivateKey(keys: keys)
}

func extractKeyIdFromPrivateKey(keys: [Key]) -> String {
    for key in keys {
        if let priv_key = key.secretKey {
            return "\(priv_key.keyID)"
        }
    }
    return ""
}

func decrypt(path: String, key: String, passphrase: String, line: Int, remember: Bool) throws -> String {
    // load file from path as NSData
    guard let encrypted_data = FileManager.default.contents(atPath: path) else {
        throw DecryptError.file
    }

    // open pgp key
    guard let keys = try? ObjectivePGP.readKeys(fromPath: key) else {
        throw DecryptError.key
    }

    // decrypt file
    guard let decrypted_data = try? ObjectivePGP.decrypt(encrypted_data, andVerifySignature: false, using: keys, passphraseForKey: { (_) -> String? in
        return passphrase
    }) else {
        throw DecryptError.decryption
    }

    if remember == true {
        let keyID = extractKeyIdFromPrivateKey(keys: keys)
        try savePassphrase(keyId: keyID, passphrase: passphrase)
    }

    // convert raw bytes to a string
    guard let decrypted_str = String(data: decrypted_data, encoding: .utf8) else {
        throw DecryptError.stringConversion
    }

    // get specific line of multi line password
    let password = decrypted_str.components(separatedBy: "\n")
    if password.indices.contains(line) == false {
        throw DecryptError.line
    }
    return password[line]
}
