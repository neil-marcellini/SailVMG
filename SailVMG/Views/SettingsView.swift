//
//  SettingsView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var audioSettings: AudioSettings
    var body: some View {
        Form {
            Section {
                Toggle("Pitch", isOn: $audioSettings.updatePitch)
                HStack {
                    Picker("Change", selection: $audioSettings.pitchValue) {
                        ForEach(Measureable.allCases) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }.pickerStyle(MenuPickerStyle())
                    Spacer()
                    Text(audioSettings.pitchValue.rawValue)
                }
                VStack(alignment: .leading){
                    Text("Semitones Per Knot = \(audioSettings.semitonesDisplay())")
                    Slider(value: $audioSettings.semitonesPerKnot, in: 0.25...2.0, step: 0.25, minimumValueLabel: Text("0.25"), maximumValueLabel: Text("2"), label: {EmptyView()})
                }
                Toggle("Frequency", isOn: $audioSettings.updateFrequency)
                HStack {
                    Picker("Change", selection: $audioSettings.frequencyValue) {
                        ForEach(Measureable.allCases) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }.pickerStyle(MenuPickerStyle())
                    Spacer()
                    Text(audioSettings.frequencyValue.rawValue)
                }
               
            }
            
        }.navigationBarTitle("Audio Settings")
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
