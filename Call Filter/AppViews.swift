//
//  AppViews.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//

import SwiftUI


struct UpdateFilterDbCard: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@EnvironmentObject var viewModel: DbUpdateViewModel
	
	@State var viewShowing = false
	
	var foreverAnimation: Animation {
		Animation.linear(duration: 0.5)
			.repeatForever(autoreverses: false)
	}
	
	@State var updatingImage = "sun.min"
	
	var body: some View {
		VStack {
			HStack {
				Text("Spammer")
					.font(.system(size: 25))
					.fontWeight(.medium)
				
				Image(systemName: updatingImage)
					.foregroundColor(.red)
					.rotationEffect(.degrees( (viewModel.isUpdating && viewShowing) ? 360 : 0 ))
					.animation((viewModel.isUpdating && viewShowing) ? foreverAnimation : .default)
					.font(.title)
					.padding(.horizontal, 1)
					.onAppear {
						self.viewShowing = true
					}
					.onDisappear {
						self.viewShowing = false
					}
				
				Text("Database")
					.font(.system(size: 25))
					.fontWeight(.medium)
			}
			.padding(.vertical)
			
			Button(action: {
				viewModel.updateDb()
			}) {
				Text("Update")
					.font(.title2)
			}
		}
		.padding()
		.frame(maxWidth: .infinity)
		.frame(height: UIScreen.screenHeight / 4.2)
		.background(getBackground())
		.cornerRadius(20)
	}
	
	func getBackground() -> Color {
		return colorScheme == .dark
			? Color.white.opacity(0.1)
			: Color.black.opacity(0.1)
	}
}


struct ActionsStatisticsView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@EnvironmentObject var viewModel: StatisticsViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .center) {
				Text("Spammer Statistics")
					.font(.system(size: 25))
					.fontWeight(.medium)
					.padding(.bottom)
			}
			.frame(maxWidth: .infinity)
			
			HStack {
				Text("Calls Identified")
				Spacer(minLength: 0)
				Text("\(String(viewModel.actionStatistics.calls))")
			}
			.font(.title2)
			
			HStack {
				Text("SMS Identified")
				Spacer(minLength: 0)
				Text("\(String(viewModel.actionStatistics.sms))")
			}
			.font(.title2)
			
			HStack {
				Text("Blocked")
				Spacer(minLength: 0)
				Text("\(String(viewModel.actionStatistics.blockedPercent*100))%")
			}
			.font(.title2)
		}
		.padding()
		.frame(maxWidth: .infinity)
		.frame(height: UIScreen.screenHeight / 4.2)
		.background(getBackground())
		.cornerRadius(20)
		.onAppear {
			viewModel.fetchActionStatistics()
		}
	}
	
	func getBackground() -> Color {
		return colorScheme == .dark
			? Color.white.opacity(0.1)
			: Color.black.opacity(0.1)
	}
}


struct TopLocationStatisticsView: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@EnvironmentObject var viewModel: StatisticsViewModel
	
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .center) {
				Text("Top Locations")
					.font(.system(size: 25))
					.fontWeight(.medium)
					.padding(.bottom)
			}
			.frame(maxWidth: .infinity)
			
			HStack {
				Text("Location")
				Spacer(minLength: 0)
				Text("Count")
			}
			.font(.title3)
			
			Divider()
				.padding(.top, 1)
				.padding(.bottom, 2)
			
			ForEach(viewModel.topLocationStatistics.sorted{$0.count > $1.count}, id: \.id) { spammer in
				HStack {
					Text("\(spammer.state)")
					Spacer(minLength: 0)
					Text("\(String(spammer.count))")
				}
				.font(.title3)
			}
		}
		.padding()
		.frame(maxWidth: .infinity)
		.background(getBackground())
		.cornerRadius(20)
		.onAppear {
			viewModel.fetchTopLocationStatistics()
		}
	}
	
	func getBackground() -> Color {
		return colorScheme == .dark
			? Color.white.opacity(0.1)
			: Color.black.opacity(0.1)
	}
}


// Lookup View
struct LookupView: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@EnvironmentObject var viewModel: LookupViewModel
	
	@State var searchFieldActive = false
	
	var body: some View {
		VStack {
			
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
					Text(viewModel.showPrompt ? "Formats: (123) 456-5678, 123-456 5678, 123 456 5678, 1234565678" : "")
						.font(.caption2)
						.foregroundColor(.secondary)
					Spacer(minLength: 0)
				}
				.padding(.top, 3)
				.frame(height: 100)
				
			}
			.padding()
			
			Spacer(minLength: 20)
		}
	}
	
	func getBackground() -> Color {
		return colorScheme == .dark
			? Color.white.opacity(0.1)
			: Color.black.opacity(0.1)
	}
}


// Filter View
struct FilterView: View {
	var body: some View {
		ScrollView {
			HStack {
				UpdateFilterDbCard()
			}
			.padding()
			
			HStack {
				ActionsStatisticsView()
			}
			.padding()
			
			HStack {
				TopLocationStatisticsView()
			}
			.padding()
			
		}
	}
}


// Bottom Bar
struct BottomBar: View {
	@Binding var isLookup: Bool
	
	var body: some View {
		HStack(spacing: 50) {
			VStack {
				Image(systemName: "magnifyingglass")
					.font(.title)
					.foregroundColor(isLookup ? .blue : .gray)
					.onTapGesture {
						withAnimation(.easeIn(duration: 0.1)) {
							isLookup = true
						}
					}
				
				Text("Lookup")
					.font(.callout)
					.foregroundColor(isLookup ? .blue : .gray)
			}
			
			VStack {
				Image(systemName: "flame")
					.font(.title)
					.foregroundColor(isLookup ? .gray : .red)
					.onTapGesture {
						withAnimation(.easeIn(duration: 0.1)) {
							isLookup = false
						}
					}
				
				Text("Filter")
					.font(.callout)
					.foregroundColor(isLookup ? .gray : .red)
			}
		}
	}
}



// https://www.hackingwithswift.com/forums/swiftui/textfield-dismiss-keyboard-clear-button/240
// extension for keyboard to dismiss
extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
