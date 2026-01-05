//
//  FlowstateApp.swift
//  Flowstate
//
//  Created by Aung on 5/1/26.
//

import SwiftUI

@main
struct FlowstateApp: App {
    // Keep your controller as a StateObject to manage the overlay lifecycle
    @StateObject private var controller = FocusController()
    
    var body: some Scene {
        // MenuBarExtra creates the icon in the top right of the macOS menu bar
        MenuBarExtra("Flowstate", systemImage: "bolt.circle.fill") {
            Button("Start Flow") {
                controller.start()
            }
            
            Divider()
            
            Button("Quit Flowstate") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}
