//
//  ViewWindowController.swift
//  pass-menubar
//
//  Created by phil on 12/04/2021.
//

import Cocoa
import SwiftUI

class ViewWindowController<RootView: View>: NSWindowController {
    convenience init(rootView: RootView, title: String) {
        let width: CGFloat = 400
        let height: CGFloat = 250
        
        let hostingController = NSHostingController(rootView: rootView.frame(width: width, height: height))
        let window = NSWindow(contentViewController: hostingController)
        
        window.setContentSize(NSSize(width: width, height: height))
        self.init(window: window)
        self.window?.title = title
    }
    
    func openWindow() {
        self.showWindow(nil)
    }
}
