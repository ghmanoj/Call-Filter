//
//  SettingsView.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/29/21.
//

import SwiftUI



// MARK: - Settings View
struct SettingsView: View {
	
	@AppStorage("isDarkMode") var isDarkMode: Bool = true
	
	@ObservedObject var viewModel = ObjectUtils.settingsViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			
			Text("Filter Settings")
				.font(.title)
				.padding(.bottom)
			
			VStack(spacing: 20) {
				Toggle("Call Filter", isOn: $viewModel.settings.isCall)
					.onChange(of: viewModel.settings.isCall) {_ in
						self.viewModel.updateFilterSettings()
					}
					.font(.title2)
				
				Toggle("SMS Filter", isOn: $viewModel.settings.isMessage)
					.onChange(of: viewModel.settings.isMessage) {_ in
						self.viewModel.updateFilterSettings()
					}
					.font(.title2)
				
				
				Toggle("Dark Mode", isOn: $isDarkMode)
					.font(.title2)
			}
			.padding()
			
			Spacer(minLength: 0)
		}
		.padding()
		.frame(maxHeight: .infinity)
	}
}
