//
//  ContentView.swift
//  DVTWeatherApp
//
//  Created by MOHD SALEEM on 12/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var m_viewModel = CCWeatherViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // Background Image
                backgroundView()
                    .ignoresSafeArea()
                
                if m_viewModel.m_isLoading {
                    
                    ProgressView("Fetching weather...")
                        .foregroundColor(.white)
                    
                } else if let error = m_viewModel.m_errorMessage {
                    
                    Text(error)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                } else {
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            
                            // ⭐ HEADER - moved down 60 pts
                            HStack {
                                Text("5-Day Forecast")
                                    .font(.custom("Poppins-Bold", size: 18))   // <-- FONT APPLIED
                                    .lineSpacing(5)                             // <-- LINE HEIGHT
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                // Location with oval background
                                   Text(m_viewModel.m_cityName ?? "Current Location")
                                       .font(.custom("Poppins-Regular", size: 14))
                                       .foregroundColor(.white)
                                       .padding(.horizontal, 12)  // horizontal padding inside oval
                                       .padding(.vertical, 6)     // vertical padding inside oval
                                       .background(
                                           Capsule()
                                               .fill(Color.white.opacity(0.25))  // very light white oval
                                       )
                            }
                            .padding(.horizontal)
                            .padding(.top, 60)
                            
                            
                            // ⭐ FULL-WIDTH WHITE LINE
                            Rectangle()
                                .fill(Color.white.opacity(0.9))
                                .frame(height: 2)
                            
                            
                            // ⭐ WEATHER CARDS — 30pt LEFT & RIGHT
                            ForEach(m_viewModel.m_forecast) { entry in
                                CCWeatherCardView(m_entry: entry)
                                    .padding(.horizontal, 30)  // <-- 30 from left/right
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                m_viewModel.requestLocation()
            }
        }
    }
    
    // MARK: - Background View
    @ViewBuilder
    private func backgroundView() -> some View {
        if let main = m_viewModel.m_forecast.first?.m_weather.first?.m_main.lowercased() {
            switch main {
            case "clear":
                Image("Sunny")
                    .resizable()
                    .scaledToFill()
            case "cloudy":
                Image("Sunny")
                    .resizable()
                    .scaledToFill()
            case "rain":
                Image("Rainy")
                    .resizable()
                    .scaledToFill()
            default:
                Image("Sunny")
                    .resizable()
                    .scaledToFill()
            }
        } else {
            Color.white
        }
    }
}
