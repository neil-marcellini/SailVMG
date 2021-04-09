//
//  MapPreviewViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/9/21.
//

import Foundation
import MapKit
import UIKit
import FirebaseStorage
import Combine

class MapViewModel: ObservableObject {
    @Published var route: MKPolyline? = nil
    @Published var preview: UIImage? = nil
    @Published var previewURL: URL? = nil
    var coordinates: [CLLocationCoordinate2D]? = nil
    @Published var loading = true
    let storage = Storage.storage()
    let storageRef: StorageReference
    
    var urlUpdates: AnyCancellable? = nil
    var previewUpdates: AnyCancellable? = nil
    
    init() {
        self.storageRef = storage.reference()
    }
    
    func getPreview(trackpoints: [Trackpoint], afterURL: @escaping ((URL)->Void), afterImage: @escaping ((UIImage)->Void)) {
        addTrack(trackpoints: trackpoints)
        makePreview()
        previewUpdates = self.$preview.sink { newImage in
            guard let image = newImage else {return}
            afterImage(image)
            self.previewUpdates?.cancel()
        }
        urlUpdates = self.$previewURL.sink { newURL in
            guard let url = newURL else {return}
            afterURL(url)
            self.urlUpdates?.cancel()
        }
    }
    
    func uploadImage() {
        guard let preview = self.preview else {return}
        guard let data = preview.pngData() else {return}
        let previewId = UUID()
        let previewRef = storageRef.child("images/previews/\(previewId.uuidString)")
        let uploadTask = previewRef.putData(data, metadata: nil) { (metadata, error) in
            if metadata == nil {
                // Uh-oh, an error occurred!
                print("Error, uploadImage")
                    return
            }
            // You can also access to download URL after upload.
            previewRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                self.previewURL = downloadURL
                
            }
        }
    }
    
    func getCoordinates(trackpoints: [Trackpoint]) {
        self.coordinates = trackpoints.compactMap { trackpoint in
            return CLLocationCoordinate2D(latitude: Double(trackpoint.latitude), longitude: Double(trackpoint.longitude))
        }
    }
    
    func addTrack(trackpoints: [Trackpoint]) {
        getCoordinates(trackpoints: trackpoints)
        guard let route_cords = coordinates else {
            print("Error, no coordinates addTrack")
            return
        }
        let track_line = MKPolyline(coordinates: route_cords, count: route_cords.count)
        self.route = track_line
        self.loading = false
    }
    
    func makePreview() {
        let view = MKMapView()
        addRoute(to: view)
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        let mapRect = self.route!.boundingMapRect
        let padding = 100.0
        let newSize = MKMapSize(width: mapRect.size.width + padding, height: mapRect.size.height + padding)
        var paddedRect = MKMapRect(origin: mapRect.origin, size: newSize)
        paddedRect = paddedRect.offsetBy(dx: padding / 2, dy: padding / 2)
        mapSnapshotOptions.mapRect = paddedRect
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot: MKMapSnapshotter.Snapshot?, error: Error?) in
            self.drawImageRoute(snapshot: snapshot)
        }
        
    }
    
    func addRoute(to view: MKMapView) {
        if !view.overlays.isEmpty {
            view.removeOverlays(view.overlays)
        }
        
        guard let route = route else { return }
        let mapRect = route.boundingMapRect
        view.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: false)
        view.addOverlay(route)
    }
    
    func drawImageRoute(snapshot: MKMapSnapshotter.Snapshot?) {
        guard let snapshot = snapshot else { return }
        let image = snapshot.image
        UIGraphicsBeginImageContextWithOptions((image.size), true, (image.scale))
        image.draw(at: CGPoint(x: 0, y: 0))
        
        let context = UIGraphicsGetCurrentContext()
        context!.setStrokeColor(UIColor.blue.cgColor)
        context!.setLineWidth(3.0)
        context!.beginPath()
        guard let coordinates = self.coordinates else {return}
        
        for (index, coordinate) in coordinates.enumerated() {
            let point = snapshot.point(for: coordinate)
            if index == 0 {
                context?.move(to: point)
            } else {
                context?.addLine(to:point)
            }
        }
        context?.strokePath()
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.preview = finalImage
        uploadImage()
    }
    
}
