//
//  pass_menubarTests.swift
//  pass-menubarTests
//
//  Created by phil on 07/04/2021.
//

import XCTest
import Files
@testable import pass_menubar

class PassMenubarTests: XCTestCase {

    func testPasswordList() throws {
        // Get test password store
        let testBundle = Bundle(for: type(of: self))
        let passwordStore = testBundle.resourcePath! + "/assets/password-store"

        let passwords = passwordList(path: passwordStore)
        XCTAssertEqual(passwords[0].display, "secret")
        XCTAssertEqual(passwords[1].display, "sub/folder/password")
    }

}
