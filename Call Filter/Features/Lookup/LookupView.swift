//
//  LookupView.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/29/21.
//

import SwiftUI

// MARK: - Lookup View
struct LookupView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@EnvironmentObject var viewModel: LookupViewModel
	
	@State var searchFieldActive = false
	
	var body: some View {
		VStack {
			HStack {
				HStack {
					Image(systemName: "magnifyingglass")
						.font(.body)
						.foregroundColor(.gray)
						.padding(.trailing, 8)
					
					TextField("Search Phone Number", text: $viewModel.numberQuery, onEditingChanged: {focused in
						if focused {
							withAnimation {
								self.searchFieldActive = true
							}
						}
					})
					.autocapitalization(.none)
					.disableAutocorrection(true)
					.font(.title3)
					.keyboardType(.phonePad)
				}
				.padding([.horizontal, .vertical], 10)
				.background(getBackground())
				.cornerRadius(15)
				
				if searchFieldActive {
					Button(action: {
						withAnimation {
							self.searchFieldActive = false
						}
						
						UIApplication.shared.endEditing() // Call to dismiss keyboard
					}) {
						Text("Cancel")
							.foregroundColor(searchFieldActive ? .primary : .secondary)
							.font(.callout)
							.padding(.leading, 5)
					}
				}
			}
			
			VStack {
				Text(viewModel.showPrompt ? "Number Format: 123-456-5678" : "")
					.font(.caption2)
					.foregroundColor(.secondary)
				Spacer(minLength: 0)
			}
			.padding(.top, 3)
			.frame(height: 40)
			
			if viewModel.spammer.count == 0 && viewModel.numberQuery != "" {
				VStack(alignment: .center) {
					Text("No Result Found")
						.font(.title2)
						.foregroundColor(.secondary)
				}
				.frame(maxHeight: .infinity)
			} else {
				List {
					ForEach(viewModel.spammer, id: \.id) { item in
						//				ForEach(mockDataModel, id: \.id) { item in
						SpammerItem(item: item)
					}
				}
			}
		}
		.padding()
	}
	
	func getBackground() -> Color {
		return colorScheme == .dark
			? Color.white.opacity(0.1)
			: Color.black.opacity(0.1)
	}
}
