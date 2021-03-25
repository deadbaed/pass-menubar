//
//  pass_menubarApp.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI

class pass_menubarAppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var application: NSApplication = NSApplication.shared
    
    var statusBar: StatusBarController?
    var popover = NSPopover.init()
    
    override init() {
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // create swiftui view
        let contentView = ContentView(text: .constant(""))
        
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // close popover when focus is lost
        popover.behavior = NSPopover.Behavior.transient
        
        // init status bar
        statusBar = StatusBarController.init(popover)
    }
}

@main
struct pass_menubarApp: App {
    
    @NSApplicationDelegateAdaptor(pass_menubarAppDelegate.self) var appDelegate
    
    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        Settings {
            SettingsView()
        }
    }
}
