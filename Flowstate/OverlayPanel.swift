//
//  OverlayPanel.swift
//  Flowstate
//
//  Created by Aung on 5/1/26.
//

import Cocoa

final class OverlayPanel: NSPanel {
    private let blurView = NSVisualEffectView()

    init(initialBlur: Double, initialDarkness: Double) {
        let screenFrame = NSScreen.main?.frame ?? .zero

        super.init(
            contentRect: screenFrame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        self.level = .normal
        self.backgroundColor = .clear
        self.ignoresMouseEvents = true
        self.isOpaque = false
        self.hasShadow = false
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        // Setup the "Liquid Glass" View
        blurView.frame = contentView!.bounds
        blurView.autoresizingMask = [.width, .height]
        
        // This is the modern 'Liquid' material used in Control Center and Notification Center
        blurView.material = .fullScreenUI
        
        // Blending within the window makes it react to the transparency of the panel
        blurView.blendingMode = .withinWindow
        blurView.state = .active
        
        contentView?.addSubview(blurView)
        
        // Boost vibrancy to remove that "gray" feel
        applyLiquidVibrancy()
    }

    private func applyLiquidVibrancy() {
        // We use a content filter to 'lift' the colors so they aren't muted by the glass
        let exposure = CIFilter(name: "CIExposureAdjust")
        exposure?.setValue(0.2, forKey: kCIInputEVKey)

        let saturation = CIFilter(name: "CIColorControls")
        saturation?.setValue(1.3, forKey: kCIInputSaturationKey)

        blurView.contentFilters = [exposure, saturation].compactMap { $0 }
    }

    func updateVisuals(blur: Double, darkness: Double) {
        // System materials handle their own radius, but we can
        // adjust the 'clarity' by changing the alpha slightly
        blurView.alphaValue = 1.0
    }
}
