//
//  FlowstateApp.swift
//  Flowstate
//
//  Created by Aung on 5/1/26.
//

import SwiftUI

@main
struct FlowstateApp: App {
    @StateObject var controller = FocusController()
    
    var body: some Scene {
        WindowGroup {
            Text("Focus App Running...")
                .padding()
                .onAppear {
                    controller.start()
                }
        }
    }
}
