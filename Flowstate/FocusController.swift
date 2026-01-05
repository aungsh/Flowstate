//
//  FocusController.swift
//  Flowstate
//
//  Created by Aung on 5/1/26.
//

import Cocoa
import Combine

class FocusController: ObservableObject {
    private var overlay = OverlayPanel()
    private var workspaceElement: AXUIElement = AXUIElementCreateSystemWide()
    
    func start() {
        overlay.orderFrontRegardless()
        
        // Listen for when the active application changes
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: .main) { _ in
            self.updateWindowLevel()
        }
        
        // High-frequency check only for movement
        Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { _ in
            self.updateWindowLevel()
        }
    }
    
    private func updateWindowLevel() {
        guard let frontApp = NSWorkspace.shared.frontmostApplication,
              frontApp.bundleIdentifier != Bundle.main.bundleIdentifier else {
            overlay.alphaValue = 0
            return
        }

        // Get all windows on screen
        let options: CGWindowListOption = [.optionOnScreenOnly, .excludeDesktopElements]
        guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else { return }

        // Find the first window belonging to the active app that isn't a tiny system element
        let activeWindow = windowList.first { info in
            let pid = info[kCGWindowOwnerPID as String] as? Int
            let bounds = info[kCGWindowBounds as String] as? [String: Any]
            let width = bounds?["Width"] as? CGFloat ?? 0
            let height = bounds?["Height"] as? CGFloat ?? 0
            
            // Filter out tiny windows like tooltips or menu items
            return pid == Int(frontApp.processIdentifier) && width > 100 && height > 100
        }

        if let windowNumber = activeWindow?[kCGWindowNumber as String] as? CGWindowID {
            overlay.alphaValue = 1
            self.overlay.order(.below, relativeTo: Int(windowNumber))
        }
    }
}
