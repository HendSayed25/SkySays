//
//  SplashScreen.swift
//  SkySays
//
//  Created by Hend Sayed on 11/06/2026.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0
    private var isMorning: Bool { TimeUtility.isMorning }

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                WeatherBackground(isMorning: isMorning)
            
                VStack(spacing: 16) {

                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 80))
                        .foregroundColor(isMorning ? .black : .white)
                        .scaleEffect(scale)
                        .opacity(opacity)

                    Text("SkySays")
                        .font(.largeTitle.bold())
                        .foregroundColor(isMorning ? .black : .white)
                        .opacity(opacity)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    scale = 1.0
                    opacity = 1.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isActive = true
                }
            }
        }
    }
}
