import Foundation
import CoreLocation
import Combine
import SwiftUI

// MARK: - Location Service
@MainActor
class LocationViewModel: NSObject, ObservableObject, @preconcurrency CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var heading: CLHeading?
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    @Published var prayerTimes: Timings?
    @Published var prayerDate: PrayerDate?
    @Published var isLoading = false
    @Published var qiblaDirection: Double = 0

    private let lm = CLLocationManager()
    private let mecca = CLLocation(latitude: 21.4225, longitude: 39.8262)

    override init() {
        super.init()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestWhenInUseAuthorization()
    }

    func requestPermission() { lm.requestWhenInUseAuthorization() }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            lm.startUpdatingLocation()
            lm.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        location = loc
        calculateQibla(from: loc)
        Task { await fetchPrayerTimes(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude) }
        lm.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading
    }

    func calculateQibla(from loc: CLLocation) {
        let lat1 = loc.coordinate.latitude.radians
        let lon1 = loc.coordinate.longitude.radians
        let lat2 = mecca.coordinate.latitude.radians
        let lon2 = mecca.coordinate.longitude.radians

        let dlon = lon2 - lon1
        let y = sin(dlon)
        let x = cos(lat1) * tan(lat2) - sin(lat1) * cos(dlon)
        var bearing = atan2(y, x).degrees
        bearing = (bearing + 360).truncatingRemainder(dividingBy: 360)
        qiblaDirection = bearing
    }

    func fetchPrayerTimes(lat: Double, lon: Double) async {
        isLoading = true
        let url = "https://api.aladhan.com/v1/timings?latitude=\(lat)&longitude=\(lon)&method=5"
        guard let u = URL(string: url) else { return }
        do {
            let (d, _) = try await URLSession.shared.data(from: u)
            let r = try JSONDecoder().decode(PrayerTimings.self, from: d)
            prayerTimes = r.data.timings
            prayerDate = r.data.date
        } catch { print("Prayer fetch error: \(error)") }
        isLoading = false
    }

    var nextPrayer: (name: String, time: String)? {
        guard let t = prayerTimes else { return nil }
        let formatter = DateFormatter(); formatter.dateFormat = "HH:mm"
        let now = Date()
        let cal = Calendar.current
        let prayers: [(String, String)] = [
            ("الفجر", t.Fajr), ("الشروق", t.Sunrise),
            ("الظهر", t.Dhuhr), ("العصر", t.Asr),
            ("المغرب", t.Maghrib), ("العشاء", t.Isha)
        ]
        for (name, time) in prayers {
            if let d = formatter.date(from: time) {
                let comps = cal.dateComponents([.hour, .minute], from: d)
                if let prayerDate = cal.date(bySettingHour: comps.hour ?? 0, minute: comps.minute ?? 0, second: 0, of: now),
                   prayerDate > now {
                    return (name, time)
                }
            }
        }
        return prayers.first
    }
}


