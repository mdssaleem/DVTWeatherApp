import SwiftUI

struct CCWeatherDetailView: View {
    let entry: CCWeatherEntry
    
    var body: some View {
        ZStack {
            
            // Full Screen Background
            backgroundImage()
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // 🔥 Day Name (moved down 50)
                Text(dayName())
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // Weather Icon
                if let url = iconURL() {
                    AsyncImage(url: url) { img in
                        img.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 120, height: 120)
                }
                
                // Temperature
                Text("\(kelvinToCelsius(entry.m_main.m_temp))°C")
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(.white)
                
                // Details
                VStack(alignment: .leading, spacing: 10) {
                    Text("Humidity: \(entry.m_main.m_humidity)%")
                    Text("Pressure: \(entry.m_main.m_pressure) hPa")
                    Text("Min Temp: \(kelvinToCelsius(entry.m_main.m_temp_min))°C")
                    Text("Max Temp: \(kelvinToCelsius(entry.m_main.m_temp_max))°C")
                    if let desc = entry.m_weather.first?.m_description {
                        Text("Condition: \(desc.capitalized)")
                    }
                }
                .font(.title3)
                .foregroundColor(.white)
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: Helpers
    
    private func kelvinToCelsius(_ kelvin: Double) -> Int {
        Int((kelvin - 273.15).rounded())
    }
    
    private func iconURL() -> URL? {
        if let icon = entry.m_weather.first?.m_icon {
            return URL(string: "https://openweathermap.org/img/wn/\(icon)@4x.png")
        }
        return nil
    }
    
    private func backgroundImage() -> Image {
        let condition = entry.m_weather.first?.m_main.lowercased() ?? ""
        
        switch condition {
        case "clear":
            return Image("Sunny")
        case "clouds":
            return Image("Cloudy")
        case "rain":
            return Image("Rainy")
        default:
            return Image("Sunny")
        }
    }
    
    private func dayName() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = df.date(from: entry.m_dt_txt) {
            df.dateFormat = "EEEE, MMM d"
            return df.string(from: date)
        }
        return ""
    }
}
