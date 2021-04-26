//
//  pass_menubarApp.swift
//  pass-menubar
//
//  Created by phil on 25/03/2021.
//

import SwiftUI
import UserNotifications

class pass_menubarAppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var application: NSApplication = NSApplication.shared
    
    var statusBar: StatusBarController?
    var popover = NSPopover.init()
    
    @AppStorage("rawPathPass") private var passwordStorePath = ""
    @AppStorage("isPassValid") private var isPassValid = false

    override init() {
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // create swiftui view
        let passwords = isPassValid ? passwordList(path: passwordStorePath) : []
        let contentView = ContentView(passwordList: passwords)
        
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // close popover when focus is lost
        popover.behavior = NSPopover.Behavior.transient
        
        // init status bar
        statusBar = StatusBarController.init(popover)

        // ask to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, error in
            if let error = error {
                print("no notifications: \(error)")
            }
        }
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
