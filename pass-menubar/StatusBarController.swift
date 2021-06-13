//
//  StatusBarController.swift
//  pass-menubar-new
//
//  Created by phil on 24/03/2021.
//

import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover

    init(_ popover: NSPopover) {
        self.popover = popover

        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)

        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(named: "lock.fill")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true

            statusBarButton.action = #selector(tooglePopover(sender:))
            statusBarButton.target = self
        }
    }

    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
    }

    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }

    @objc func tooglePopover(sender: AnyObject) {
        if popover.isShown {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}
