//
//  Decrypt.swift
//  pass-menubar
//
//  Created by phil on 18/04/2021.
//

import ObjectivePGP

func decrypt(path: String, key: String, passphrase: String, line: UInt) -> String? {
    // load file from path as NSData
    let data = FileManager.default.contents(atPath: path)
    if data == Optional.none {
        return Optional.none
    }

    do {
        // load key
        let key = try ObjectivePGP.readKeys(fromPath: key)

        // attempt to decrypt data with key and passphrase
        let decrypted_data = try ObjectivePGP.decrypt(data!, andVerifySignature: false, using: key, passphraseForKey: { (key) -> String? in
            return passphrase
        })
        let decrypted_str = String(data: decrypted_data, encoding: .utf8)
        print(decrypted_str)
        return decrypted_str
    } catch { return Optional.none }
}
