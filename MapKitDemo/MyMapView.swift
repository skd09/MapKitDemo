//
//  MyMapView.swift
//  MapKitDemo
//
//  Created by Sharvari on 2023-11-20.
//

import SwiftUI
import MapKit

struct MyMapView: View {
    @State private var position: MapCameraPosition = .automatic
    @ObservedObject private var manager = LocationManager()
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var search: [MKMapItem] = Array()
    @State private var bounds = MapCameraBounds(minimumDistance: 0.5, maximumDistance: 0.5)
    @State private var tfAddress = ""
    @Namespace var mapScope

    @State private var selectedResult: MKMapItem?
    @State var route: MKRoute?

    private let strokeStyle = StrokeStyle(
        lineWidth: 5,
        lineCap: .round,
        lineJoin: .round,
        dash: [10, 10]
    )

    private let strokeGradient = LinearGradient(
        colors: [.red, .green, .blue],
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        ZStack{
            Map(position: $position) {
                /// UserAnnotation is for the blue circle which shows users location
                UserAnnotation()
                Annotation("Location 1", coordinate: .markLocation){
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 2)
                        Image(systemName: "figure.walk")
                            .padding(5)
                    }
                }
                .annotationTitles(.hidden)

                ForEach(search, id: \.self){ item in
                    Marker(item: item)
                }
                .annotationTitles(.hidden)

                if let location = manager.currentLocation{
                    Marker(coordinate: location) {
                        Text("Your Location")
                    }
                    .tint(.blue)

                    Marker(coordinate: .mark1Location) {
                        Text("Location 2")
                    }

                    MapPolyline(coordinates: [location, .mark1Location])
                        .stroke(strokeGradient, style: strokeStyle)
                }
            }
//            .mapStyle(.imagery(elevation: .realistic))
            .mapStyle(.standard(
                elevation: .realistic,
                pointsOfInterest: .including([.beach, .hotel, .hospital, .park]),
                showsTraffic: true
            ))
            .mapScope(mapScope)
            .mapControls {
                MapPitchToggle()
                MapUserLocationButton()
                MapCompass(scope: mapScope).mapControlVisibility(.visible)
                MapScaleView()
            }
            .onMapCameraChange { value in
                visibleRegion = value.region
            }
            .onChange(of: search) {
                position = .automatic
            }
        }
        .safeAreaInset(edge: .top){
            HStack{
                TextField(text: $tfAddress) {
                    Text("Search address....")
                }
                .padding()
                .onSubmit {
                    searchAddress()
                }
                Spacer()
                Button(action: {
                    searchAddress()
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .tint(.black.opacity(0.5))
                })
                .padding()
            }
            .background(.ultraThinMaterial)
        }
        .safeAreaInset(edge: .bottom) {
            HStack{
                Spacer()
                VStack(spacing: 0){
                    if selectedResult != nil {
                        InfoView(route: $route, selectedResult: $selectedResult)
                           .frame(height: 128)
                           .clipShape(RoundedRectangle (cornerRadius: 10))
                           .padding([.top, .horizontal])
                    }
                    SearchButtonsView(
                        search: $search,
                        position: $position,
                        visibleRegion: $visibleRegion
                    )
                    .padding(.top)
                }
                Spacer()
            }
            .background(.ultraThinMaterial)
        }
    }

    private func searchAddress(){
        Task{
            if let visibleRegion{
                search = await search(for: tfAddress, type: .address, region: visibleRegion)
            }
        }
    }
}


#Preview {
    MyMapView()
}
