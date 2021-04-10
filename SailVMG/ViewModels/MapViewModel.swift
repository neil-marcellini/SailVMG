//
//  MapPreviewViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/9/21.
//

import Foundation
import MapKit
import UIKit
import SwiftUI
import FirebaseStorage
import Combine

class MapViewModel: ObservableObject {
    @Published var route: MKPolyline? = nil
    @Published var previews: [String: UIImage] = [:]
    @Published var previewURLs: [String:URL] = [:]
    var coordinates: [CLLocationCoordinate2D]? = nil
    let storage = Storage.storage()
    let storageRef: StorageReference
    
    var urlUpdates: AnyCancellable? = nil
    var previewUpdates: AnyCancellable? = nil
    
    init() {
        self.storageRef = storage.reference()
    }
    
    func getPreview(trackpoints: [Trackpoint], trackVM: TrackViewModel, afterPreviews: @escaping ((TrackViewModel)->Void)) {
        print("Making track previews")
        previews = [:]
        previewURLs = [:]
        addTrack(trackpoints: trackpoints)
        makePreviews()
        previewUpdates = self.$previews.sink { previewDict in
            if previewDict.count == ColorScheme.allCases.count {
                let newTrackVM = self.afterPreviewImages(previews: previewDict, trackVM: trackVM)
                afterPreviews(newTrackVM)
                self.previewUpdates?.cancel()
            }
        }
        urlUpdates = self.$previewURLs.sink { urlsDict in
            if urlsDict.count == ColorScheme.allCases.count {
                let newTrackVM = self.afterPreviewURLs(previewURLs: urlsDict, trackVM: trackVM)
                afterPreviews(newTrackVM)
                self.urlUpdates?.cancel()
            }
        }
    }
    
    func afterPreviewImages(previews: [String:UIImage], trackVM: TrackViewModel) -> TrackViewModel {
        let newTrackVM = trackVM
        for (mode, preview) in previews {
            if mode == "light" {
                newTrackVM.light_preview = preview
            } else if mode == "dark" {
                newTrackVM.dark_preview = preview
            }
        }
        return newTrackVM
    }
    
    func afterPreviewURLs(previewURLs: [String:URL], trackVM: TrackViewModel) -> TrackViewModel {
        let newTrackVM = trackVM
        for (mode, url) in previewURLs {
            if mode == "light" {
                newTrackVM.track.light_preview_url = url
            } else if mode == "dark" {
                newTrackVM.track.dark_preview_url = url
            }
        }
        return newTrackVM
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
    }
    
    func makePreviews() {
        let view = MKMapView()
        addRoute(to: view)
        
        let mapRect = self.route!.boundingMapRect
        let padding = 100.0
        let newSize = MKMapSize(width: mapRect.size.width + padding, height: mapRect.size.height + padding)
        var paddedRect = MKMapRect(origin: mapRect.origin, size: newSize)
        paddedRect = paddedRect.offsetBy(dx: padding / 2, dy: padding / 2)
       
        // make a light and dark snapshot
        for mode in ColorScheme.allCases {
            let mapSnapshotOptions = MKMapSnapshotter.Options()
            mapSnapshotOptions.mapRect = paddedRect
            if mode == .dark {
                let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
                let traits = UITraitCollection(traitsFrom: [mapSnapshotOptions.traitCollection, darkTrait])
                mapSnapshotOptions.traitCollection = traits
            }
            let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
            snapShotter.start { (snapshot: MKMapSnapshotter.Snapshot?, error: Error?) in
                if error != nil {
                    print("Error, snapshot: \(String(describing: error))")
                }
                self.drawImageRoute(snapshot: snapshot, mode: mode)
            }
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
    
    func drawImageRoute(snapshot: MKMapSnapshotter.Snapshot?, mode: ColorScheme) {
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
        guard let finalImage = UIGraphicsGetImageFromCurrentImageContext() else {return}
        UIGraphicsEndImageContext()
        if mode == .dark {
            previews["dark"] = finalImage
        } else if (mode == .light) {
            previews["light"] = finalImage
        }
        uploadImage(preview: finalImage, mode: mode)
    }
    
    func uploadImage(preview: UIImage, mode: ColorScheme) {
        guard let data = preview.pngData() else {return}
        var modeString = "light"
        if mode == .dark {
            modeString = "dark"
        }
        let previewId = UUID()
        let previewRef = storageRef.child("images/previews/\(modeString).\(previewId.uuidString)")
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
                self.previewURLs[modeString] = downloadURL
                
            }
        }
    }
    
}
