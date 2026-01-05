//
//  OverlayPanel.swift
//  Flowstate
//
//  Created by Aung on 5/1/26.
//

import Cocoa

class OverlayPanel: NSPanel {
    init() {
        let totalRect = NSScreen.screens.reduce(CGRect.zero) { $0.union($1.frame) }
        
        super.init(contentRect: totalRect,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: false)
        
        self.level = .normal
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        self.ignoresMouseEvents = true
        self.isReleasedWhenClosed = false
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .ignoresCycle]
        
        let blur = NSVisualEffectView(frame: self.contentView!.bounds)
        blur.material = .fullScreenUI
        blur.blendingMode = .behindWindow
        blur.state = .active
        blur.autoresizingMask = [.width, .height]
        self.contentView?.addSubview(blur)
    }
}
