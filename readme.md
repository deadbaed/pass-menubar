#  pass-menubar

A simple password-store decryptor in macOS menubar.

Search for your password, decrypt it and it gets copied to your clipboard!

No need to open a terminal to get your passwords, always available in your menubar!

This app is target for existing users of `pass`. If you do now know about `pass`, learn more on [passwordstore.org](https://passwordstore.org).

## Features

- Always available in system menubar
- Search to quickly find your password
- Built-in decryption (GPG is not required)
- Automatically copies password in clipboard
- Optional: Use Touch ID to decrypt a password

## Install

I don't know how to package it, so you will need to build it yourself.

If you know how to package an app requiring **Keychain Sharing** capability, let me know!

## Build and runtime requirements

- Xcode version 12.5 or later
- macOS 11.0 (Big Sur) or later
- An Xcode certificate with **Keychain Sharing** capability

## Tests

I have included a test passwordstore alongside a secret key. Find them in [pass-menubarTests/assets/](./pass-menubarTests/assets).

There is also a Dockerfile with a simple linux environement to play around with the real `pass`.

## Screenshots

![Interface of application](./screenshots/interface.png)

![Searching through passwords](./screenshots/search.png)

![Main settings](./screenshots/settings.png)

![Prompt to enter key passphrase](./screenshots/ask-passphrase.png)

![View when a password has been decrypted](./screenshots/decrypted.png)

## Technical details

Interface is written in SwiftUI.

It's my first macOS app, so feel free to contribute (especially in the UI part)!

Libraries used:

- [Files](https://github.com/JohnSundell/Files)
- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
- [ObjectivePGP](https://github.com/krzyzanowskim/ObjectivePGP)
