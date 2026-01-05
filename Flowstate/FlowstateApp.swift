//
//  FlowstateApp.swift
//  Flowstate
//
//  Created by Aung on 5/1/26.
//

import SwiftUI

@main
struct FlowstateApp: App {
    @StateObject private var controller = FocusController.shared
    
    var body: some Scene {
        MenuBarExtra("Flowstate", systemImage: "bolt.circle.fill") {
            if controller.isActive {
                Button("Stop Flow") {
                    controller.stop()
                }
            } else {
                Button("Start Flow") {
                    controller.start()
                }
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
