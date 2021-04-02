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
                HStack {
                    Text("Pitch")
                    Spacer()
                    Toggle(isOn: $audioSettings.updatePitch) { EmptyView()}
                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                }
                if audioSettings.updatePitch {
                    VStack(alignment: .leading) {
                        Text("Metric")
                        Picker("", selection: $audioSettings.pitchValue) {
                            ForEach(Measureable.allCases) { value in
                                Text(value.rawValue).tag(value)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    VStack(alignment: .leading){
                        Text("Semitones Per Knot = \(String(format: "%.2f", audioSettings.semitonesPerKnot))")
                        Slider(value: $audioSettings.semitonesPerKnot, in: 0.25...2.0, step: 0.25, minimumValueLabel: Text("0.25"), maximumValueLabel: Text("2"), label: {EmptyView()})
                    }
                }
            }
            Section {
                HStack {
                    Text("Frequency")
                    Spacer()
                    Toggle(isOn: $audioSettings.updateFrequency) { EmptyView()}
                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                }
                if audioSettings.updateFrequency {
                    VStack(alignment: .leading) {
                        Text("Metric")
                        Picker("", selection: $audioSettings.frequencyValue) {
                            ForEach(Measureable.allCases) { value in
                                Text(value.rawValue).tag(value)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    VStack(alignment: .leading){
                        Text("Frequency Per Knot = \(String(format: "%.2f", audioSettings.ratePerKnot))")
                        Slider(value: $audioSettings.ratePerKnot, in: 0.125...1.0, step: 0.125, minimumValueLabel: Text("0.125"), maximumValueLabel: Text("1"), label: {EmptyView()})
                    }
                }
            }
            Button(action: {audioSettings.showResetConfirmation = true}, label: {
                Text("Reset All")
                    .foregroundColor(.red)
            })
            .alert(isPresented: $audioSettings.showResetConfirmation) {
                Alert(title: Text("Reset All Settings"), message: Text("Are you sure you want to reset all settings to the default?"), primaryButton: .default(Text("Yes"), action: audioSettings.resetAllSettings), secondaryButton: .cancel())
            }
        }.navigationBarTitle("Audio Settings")
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
