//
//  FocusController.swift
//  Flowstate
//
//  Created by Aung on 5/1/26.
//

import Cocoa
import Combine

class FocusController: ObservableObject {
    static let shared = FocusController()
    
    @Published var isActive = false
    
    private var overlay = OverlayPanel()
    private var lastWindowID: CGWindowID?
    private var timer: Timer?

    private init() {}

    func start() {
        guard timer == nil else { return }
        
        isActive = true
        overlay.orderFrontRegardless()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateWindowLevel()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isActive = false
        lastWindowID = nil
        
        overlay.orderOut(nil)
        overlay.alphaValue = 0
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
                overlay.alphaValue = 1
                self.overlay.order(.below, relativeTo: Int(windowNumber))
                lastWindowID = windowNumber
            }
        }
    }
}
