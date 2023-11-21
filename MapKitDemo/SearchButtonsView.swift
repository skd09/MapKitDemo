//
//  SearchButtonsView.swift
//  MapKitDemo
//
//  Created by Sharvari on 2023-11-20.
//

import SwiftUI
import MapKit

struct SearchButtonsView: View {
    @Binding var search: [MKMapItem]
    @Binding var position: MapCameraPosition
    @Binding var visibleRegion: MKCoordinateRegion?

    var body: some View{
        VStack{
            Text("Search options")
                .bold()
            HStack{
                Button(action: {
                    searchPointOfInterest(for: "beach")
                }, label: {
                    Label("Beach", systemImage: "beach.umbrella.fill")
                        .padding(5)
                })
                .buttonStyle(.borderedProminent)

                Button(action: {
                    searchPointOfInterest(for: "hospital")
                }, label: {
                    Label("Hospitals", systemImage: "cross.case.fill")
                        .padding(5)
                })
                .buttonStyle(.borderedProminent)

                Button(action: {
                    searchPointOfInterest(for: "hotel")
                }, label: {
                    Label("Hotel", systemImage: "building.columns.fill")
                        .padding(5)
                })
                .buttonStyle(.bordered)

                Button(action: {
                    searchPointOfInterest(for: "park")
                }, label: {
                    Label("Park", systemImage: "tree.fill")
                        .padding(5)
                })
                .buttonStyle(.bordered)
            }
            .labelStyle(.iconOnly)
        }
    }

    private func searchPointOfInterest(for query: String){
        Task{
            search = await search(for: query, type: .pointOfInterest, region: visibleRegion ?? .centerLocation)
        }
    }
}
