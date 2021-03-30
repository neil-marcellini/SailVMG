//
//  GPXExporter.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/29/21.
//

import Foundation
import CoreGPX

struct GPXExporter {
    
    
    func getGPXFile(trackpoints: [Trackpoint])->NSURL? {
        let gpx_data = getGPXString(trackpoints: trackpoints)
        let filename = getDocumentsDirectory().appendingPathComponent("track.gpx")

        do {
            try gpx_data.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            let fileURL = NSURL(fileURLWithPath: filename.path)
            return fileURL
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error writing gpx file.")
            return nil
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getGPXString(trackpoints: [Trackpoint])->String {
        let root = GPXRoot(creator: "SailVMG")
        var gpx_trackpoints = [GPXTrackPoint]()

        
        for trackpoint in trackpoints {
            let gpx_trackpoint = GPXTrackPoint(latitude: trackpoint.latitude, longitude: trackpoint.longitude)
            gpx_trackpoint.time = trackpoint.time
            gpx_trackpoints.append(gpx_trackpoint)
        }
        
        let track = GPXTrack()                          // inits a track
        let tracksegment = GPXTrackSegment()            // inits a tracksegment
        tracksegment.add(trackpoints: gpx_trackpoints)      // adds an array of trackpoints to a track segment
        track.add(trackSegment: tracksegment)           // adds a track segment to a track
        root.add(track: track)                          // adds a track
        print("gpx file string")
        print(root.gpx())                // prints the GPX formatted string
        return root.gpx()
    }
}
