//
//  AppDelegate.swift
//  pass-menubar
//
//  Created by phil on 14/02/2021.
//

import Cocoa
import Preferences

extension Preferences.PaneIdentifier {
    static let general = Self("general")
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuITem: NSMenuItem?
    
    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: [
            GeneralPreferencesViewController()
        ],
        style: .toolbarItems
    )
    
    @IBAction func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        preferencesWindowController.show()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        let itemImage = NSImage(named: "lock.fill")
        itemImage?.isTemplate = true
        statusItem?.button?.image = itemImage
        
        if let menu = menu {
            statusItem?.menu = menu
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

