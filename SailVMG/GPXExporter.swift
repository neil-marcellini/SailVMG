//
//  GPXExporter.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/29/21.
//

import Foundation
import CoreGPX

struct GPXExporter {
    
    
    func getGPXFile(trackVM: TrackViewModel)->NSURL? {
        let gpx = getGPXString(trackpoints: trackVM.trackpoints)
        let fileName = getFileName(trackVM: trackVM)
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try gpx.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            let fileURL = NSURL(fileURLWithPath: filePath.path)
            return fileURL
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error writing gpx file.")
            return nil
        }
    }
    
    func getFileName(trackVM: TrackViewModel)->String {
        var trackDate = trackVM.getDate()
        trackDate = trackDate.replacingOccurrences(of: "/", with: "-")
        var trackStartTime = trackVM.startTime()
        trackStartTime = trackStartTime.replacingOccurrences(of: ":", with: ".")
        let file_name = "\(trackDate) \(trackStartTime).gpx"
        return file_name
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
