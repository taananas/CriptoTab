//
//  AppDelegate+NSPopoverDelegate.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import Cocoa
import SwiftUI


extension AppDelegate: NSPopoverDelegate{
    
    func setupPopover(){
        popoverViewModel = .init(wsService: wsCoinService)
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = .init(width: 320, height: 400)
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: PopoverView(viewModel:popoverViewModel))
    }
    
    
    func popoverDidClose(_ notification: Notification) {
        let positioningView = statusItem.button?.subviews.first{
            $0.identifier == NSUserInterfaceItemIdentifier("positioningView")
        }
        positioningView?.removeFromSuperview()
    }
}
