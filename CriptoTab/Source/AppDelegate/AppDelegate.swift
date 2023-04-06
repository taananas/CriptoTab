//
//  AppDelegate.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate{
    
    

    let popover = NSPopover()
    let wsCoinService = CoinWebSocketService()
    var menuBarViewModel: MenuBarCoinViewModel!
    var popoverViewModel: PopoverViewModel!
    var statusItem: NSStatusItem!
    
    private lazy var contentView: NSView? = {
        (statusItem.value(forKey: "window") as? NSWindow)?.contentView
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        setupPopover()
        setupCoinSevice()
    }
    
    func setupCoinSevice(){
        wsCoinService.connect(with: menuBarViewModel.selectedCoinId)
        wsCoinService.startNetworkMonitor()
    }
}


extension AppDelegate{
    
    func setupMenuBar(){
        menuBarViewModel = MenuBarCoinViewModel(service: wsCoinService)
        statusItem = NSStatusBar.system.statusItem(withLength: 64)
        guard let contentView, let menuButton = statusItem.button else {return}
        
        let hostingView = NSHostingView(rootView: MenuBarView(viewModel: menuBarViewModel))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostingView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
        
        menuButton.action = #selector(menuButtonClicked)
    }
    
   @objc func menuButtonClicked(){
       if popover.isShown{
           popover.performClose(nil)
           return
       }
       guard let menuButton = statusItem.button else {return}
       
       let positioningView = NSView(frame: menuButton.frame)
       positioningView.identifier = NSUserInterfaceItemIdentifier("positioningView")
       menuButton.addSubview(positioningView)
       
       popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .maxY)
       //menuButton.bounds = menuButton.bounds.offsetBy(dx: 0, dy: menuButton.bounds.height)
       popover.contentViewController?.view.window?.makeKey()
    }
}



