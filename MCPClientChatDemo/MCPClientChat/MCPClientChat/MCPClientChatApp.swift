//
//  MCPClientChatApp.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import SwiftUI
import SwiftAnthropic

@main
struct MCPClientChatApp: App {
   
   @State private var chatManager: ChatManager
   private let githubClient = GIthubMCPClient()
   
   init() {
      let service = AnthropicServiceFactory.service(apiKey: "", betaHeaders: nil)
      
      let initialManager = AnthropicNonStreamManager(service: service)
      
      _chatManager = State(initialValue: initialManager)
   }
   
   var body: some Scene {
      WindowGroup {
         ChatView(chatManager: chatManager)
            .toolbar(removing: .title)
            .containerBackground(
               .thinMaterial, for: .window
            )
            .toolbarBackgroundVisibility(
               .hidden, for: .windowToolbar
            )
            .task {
               if let client = try? await githubClient.getClientAsync() {
                  chatManager.updateClient(client)
               }
            }
      }
      .windowStyle(.hiddenTitleBar)
   }
}
