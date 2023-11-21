//
//  InfoView.swift
//  MapKitDemo
//
//  Created by Sharvari on 2023-11-20.
//

import SwiftUI
import MapKit

struct InfoView: View {
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var route: MKRoute?
    @Binding var selectedResult: MKMapItem?
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing){
                HStack {
//                    Text ("\(search.name ?? "")")
//                    if let travelTime {
//                        Text(travelTime)
//                    }
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding (10)
            }
            .onAppear{ getLookAroundScene() }
            .onChange(of: selectedResult){ getDirections() }
    }

    private func getLookAroundScene(){
        lookAroundScene = nil
        Task {
            if let selectedResult {
                let request = MKLookAroundSceneRequest(mapItem: selectedResult)
                lookAroundScene = try? await request.scene
            }
        }
    }

    private var travelTime: String? {
        guard let route else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: route.expectedTravelTime)
    }

    func getDirections() {
        route = nil
        guard let selectedResult else { return }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .markLocation))
        request.destination = selectedResult

        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}

#Preview {
    InfoView(route: .constant(MKRoute()), selectedResult: .constant(MKMapItem(placemark: .init(coordinate: .markLocation))))
}
