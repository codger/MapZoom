//
//  ContentView.swift
//  MapZoom
//
//  Created by John James Retina on 5/29/20.
//  Copyright © 2020 John James. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationItem {
  var title: String
  var coordinate: CLLocationCoordinate2D
  
  init(title : String, lat : Double, lon : Double) {
    self.title = title
    self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }
}

struct ContentView: View {
  @State private var selectedSegment = 0
  @State private var zoomLevel = 1.0
  @State private var spanLevel = 1.0
  @State private var locations = [
    LocationItem(title: "Pyramid", lat: 37.795042, lon: -122.402873),
    LocationItem(title: "Panera", lat: 33.6379, lon: -117.85982),
    LocationItem(title: "Paris", lat: 48.8584, lon: 2.2945),
    LocationItem(title: "Wembly", lat: 51.556, lon: -0.2795)
  ]
  
  var body: some View {
    VStack (alignment: .center, spacing: 0){
      MapView(coordinate: self.locations[selectedSegment].coordinate, span: spanLevel)
        .scaleEffect(CGFloat(zoomLevel), anchor: UnitPoint(x: 0.5, y: 0.5))
        .blendMode(.sourceAtop)
      Group{
        HStack{
          Text("Span")
          Slider(value: $spanLevel, in: 0.001...0.01, step: 0.001)
        }
        .foregroundColor(.white)
        HStack{
          Text("Zoom")
          Slider(value: $zoomLevel, in: 1.0...10, step: 0.5)
        }
        .foregroundColor(.white)
        Picker(selection: $selectedSegment, label: Text("Locations")) {
          ForEach(0 ..< locations.count) {
            Text(self.locations[$0].title)
          }
        }.pickerStyle(SegmentedPickerStyle())
      }.background(Color.gray)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct MapView: UIViewRepresentable {
  
  var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.795042, longitude: -122.402873)
  var span : Double = 0.01
  
  func makeUIView(context: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }
  
  func updateUIView(_ view: MKMapView, context: Context) {
    let span = MKCoordinateSpan(latitudeDelta: self.span, longitudeDelta: self.span)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    view.setRegion(region, animated: true)
    view.mapType = .satellite
  }
}
