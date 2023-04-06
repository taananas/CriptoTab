//
//  CriptoTabApp.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import SwiftUI

@main
struct CriptoTabApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .frame(width: 0, height: 0)
        }
    }
}
