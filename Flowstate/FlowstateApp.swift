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
        MenuBarExtra {
            Button("Start Flow") {
                controller.start()
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])

            Button("Stop Flow") {
                controller.stop()
            }
            .keyboardShortcut("x", modifiers: [.command, .shift])

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: controller.isActive
                  ? "bolt.circle.fill"
                  : "bolt.circle")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(controller.isActive ? .blue : .primary)
        }
        .menuBarExtraStyle(.menu)
    }
}
