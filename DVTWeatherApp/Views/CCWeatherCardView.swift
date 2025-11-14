import SwiftUI

struct CCWeatherCardView: View {
    let m_entry: CCWeatherEntry
    @State private var showDetail = false

    var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 12) {
                
                // DAY NAME on top
                Text(dayName())
                    .font(.custom("Poppins-SemiBold", size: 16))  // Poppins SemiBold, 16px
                    .lineSpacing(24)                              // Line height = 24px
                
                // ICON LEFT + TEMP RIGHT SAME LINE
                HStack {
                    
                    // ICON WITH LIGHT GRAY CIRCLE BACKGROUND
                    if let url = iconURL() {
                        AsyncImage(url: url) { img in
                            img.resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(15) // increased padding for larger circle
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.11)) // very light gray
                                )
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 70, height: 70) // increased frame size
                    }
                    
                    Spacer()
                    
                    // TEMP — Poppins Bold, 36px, LineHeight 44
                    Text("\(kelvinToCelsius(m_entry.m_main.m_temp))°")
                        .font(Font.custom("Poppins-Bold", size: 36))
                        .lineSpacing(44 - 36)   // line height = 44px
                        .padding(.trailing, 4)
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(Color.white.opacity(0.95))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            CCWeatherDetailView(entry: m_entry)
        }
    }
    
    // MARK: - Helpers
    
    private func kelvinToCelsius(_ kelvin: Double) -> Int {
        Int((kelvin - 273.15).rounded())
    }
    
    private func iconURL() -> URL? {
        if let icon = m_entry.m_weather.first?.m_icon {
            return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        }
        return nil
    }
    
    private func dayName() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = df.date(from: m_entry.m_dt_txt) {
            df.dateFormat = "EEEE"
            return df.string(from: date)
        }
        return ""
    }
}
