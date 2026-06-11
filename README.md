# SkySays 🌤️
A weather app built with SwiftUI, MVVM architecture, SwiftData persistence, and WeatherAPI.

---

## Screens

### 1. Today Screen
- Dynamic background based on time of day
  - **Morning** (5AM – 6PM): sky blue → golden gradient + **black** font
  - **Evening** (6PM – 5AM): deep navy → dusk purple + **white** font
- Current location name, temperature, condition, H/L temps
- Real weather icon from WeatherAPI
- 3-Day Forecast list → tap any day to see hourly breakdown
- Stats grid: Visibility, Humidity, Feels Like, Pressure

### 2. Hourly Screen
- Opens when tapping a forecast day
- **Today** → starts from current hour with "Now" label
- **Tomorrow / Day after** → shows all 24 hours from midnight

### 3. Locations Screen
- Search any city globally with live suggestions
- Save cities to a persistent list via SwiftData
- Each saved card shows live weather (temp + icon + condition)
- Long press → Delete with confirmation alert
- Tap any city → opens full weather detail

---

## App Flow

1. App launches → Splash screen (LaunchScreen + SwiftUI SplashView)
2. Requests location permission automatically
3. If approved → fetch real GPS coordinates
4. Fetch weather data from WeatherAPI using coordinates
5. Display Today Screen with current weather details
6. User can:
   - Search any city globally
   - Save locations using SwiftData
   - View hourly forecast for selected days
   - Delete saved locations
  
---

##  API Key Setup (Secure)

### Step 1: Create Secrets.xcconfig
```
File → New → File → Configuration Settings File → Secrets.xcconfig
```

### Step 2: Add your key
```
WEATHER_API_KEY = your_actual_api_key_here
```

### Step 3: Add to Info.plist
```
Key:   WEATHER_API_KEY
Value: $(WEATHER_API_KEY)
```

### Step 4: Read in WeatherService.swift
```swift
private let apiKey: String = {
    Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String ?? ""
}()
```

### Step 5: Add to .gitignore
```
Secrets.xcconfig
```

> Get your free API key at [weatherapi.com](https://www.weatherapi.com)

---

## 🗄️ SwiftData

One persistent model:

```swift
@Model
final class SavedLocation {
    var id: UUID
    var name: String
    var country: String
    var lat: Double
    var lon: Double
    var addedAt: Date
}
```

- Stored locally on device
- Sorted by `addedAt` descending (newest first)
- Duplicate prevention using coordinate comparison (±0.001°)
- Delete via long press → context menu → confirmation alert

---

## 📍 Location

- Requests `WhenInUse` permission on launch
- Shows permission dialog automatically
- **Approved** → uses real GPS coordinates
- **Denied** → shows permission denied screen with Open Settings button
- **GPS error** → shows error state 

Add to `Info.plist`:
```
Key:   Privacy - Location When In Use Usage Description
Value: SkySays needs your location to show local weather
```

---

## 🔧 Requirements

- Xcode 15+
- iOS 17+
- Swift 5.9+
- WeatherAPI free account

---

## 🚀 Setup Steps

1. Clone / open project in Xcode
2. Create `Secrets.xcconfig` with your API key (see above)
3. Add Location permission to `Info.plist`
4. Run on Simulator or real device (iOS 17+)
