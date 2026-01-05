//
//  FocusController.swift
//  Flowstate
//
//  Created by Aung on 5/1/26.
//

import Cocoa
import Combine
import SwiftUI

final class FocusController: ObservableObject {
    static let shared = FocusController()

    @Published var isActive = false
    
    // Kept to prevent errors in your App UI, but they won't affect the overlay anymore
    @Published var blurRadius: Double = 10.0
    @Published var darknessOpacity: Double = 0.0

    private var overlay: OverlayPanel
    private var lastWindowID: CGWindowID?
    private var timer: Timer?

    private init() {
        self.overlay = OverlayPanel(initialBlur: 10.0, initialDarkness: 0.0)
    }

    func updateStyles() {
        // This now updates the 'pure' blur radius dynamically
        overlay.updateVisuals(blur: blurRadius, darkness: 0)
    }

    func start() {
        guard timer == nil else { return }
        isActive = true
        overlay.alphaValue = 0
        overlay.orderFrontRegardless()

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.5
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            overlay.animator().alphaValue = 1
        }

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateWindowLevel()
        }
    }

    func stop() {
        isActive = false
        timer?.invalidate()
        timer = nil

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            self.overlay.animator().alphaValue = 0
        }, completionHandler: {
            self.overlay.orderOut(nil)
            self.lastWindowID = nil
        })
    }

    private func updateWindowLevel() {
        guard let frontApp = NSWorkspace.shared.frontmostApplication,
              frontApp.bundleIdentifier != Bundle.main.bundleIdentifier else {
            if overlay.alphaValue != 0 { overlay.alphaValue = 0 }
            return
        }

        let options: CGWindowListOption = [.optionOnScreenOnly, .excludeDesktopElements]
        guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else { return }

        let activeWindow = windowList.first { info in
            let pid = info[kCGWindowOwnerPID as String] as? Int
            let bounds = info[kCGWindowBounds as String] as? [String: Any]
            let width = bounds?["Width"] as? CGFloat ?? 0
            let height = bounds?["Height"] as? CGFloat ?? 0
            return pid == Int(frontApp.processIdentifier) && width > 100 && height > 100
        }

        if let windowNumber = activeWindow?[kCGWindowNumber as String] as? CGWindowID {
            if lastWindowID != windowNumber || overlay.alphaValue == 0 {
                if !overlay.isVisible { overlay.alphaValue = 1 }
                overlay.order(.below, relativeTo: Int(windowNumber))
                lastWindowID = windowNumber
            }
        }
    }
}
