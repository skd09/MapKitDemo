//
//  Utils.swift
//  MapKitDemo
//
//  Created by Sharvari on 2023-11-20.
//

import Foundation
import SwiftUI
import MapKit

extension MKCoordinateRegion{
    static let centerLocation = MKCoordinateRegion(
        center: .markLocation,
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
}

extension CLLocationCoordinate2D {
    static let markLocation = CLLocationCoordinate2D(latitude: 49.286561, longitude: -123.107262)
    static let mark1Location = CLLocationCoordinate2D(latitude: 49.290303, longitude: -123.129053)

    static let plotLocations: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 49.289299, longitude: -123.144781),
        CLLocationCoordinate2D(latitude: 49.295727, longitude: -123.152892),
        CLLocationCoordinate2D(latitude: 49.308514, longitude: -123.156126),
        CLLocationCoordinate2D(latitude: 49.314069, longitude: -123.141547),
        CLLocationCoordinate2D(latitude: 49.300598, longitude: -123.116752),
        CLLocationCoordinate2D(latitude: 49.294220, longitude: -123.137209)
    ]
}

extension View{
    internal func search(
        for query: String,
        type: MKLocalSearch.ResultType = .pointOfInterest,
        region: MKCoordinateRegion = .centerLocation
    ) async -> [MKMapItem]{
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = type
        request.region = region
        let _search = MKLocalSearch(request: request)
        let response = try? await _search.start()
        return response?.mapItems ?? []
    }
}
