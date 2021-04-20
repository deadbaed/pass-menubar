//
//  Decrypt.swift
//  pass-menubar
//
//  Created by phil on 18/04/2021.
//

import ObjectivePGP

func decrypt(path: String, key: String, passphrase: String) {
    // load file from path as NSData
    let data = FileManager.default.contents(atPath: path)

    // load key inside keychain?s
    do {
        let key = try ObjectivePGP.readKeys(fromPath: key)
        let decrypted_data = try ObjectivePGP.decrypt(data!, andVerifySignature: false, using: key, passphraseForKey: { (key) -> String? in
            return passphrase
        })
        let decrypted_str = String(data: decrypted_data, encoding: .utf8)
        print(decrypted_str)
    } catch {}
}
