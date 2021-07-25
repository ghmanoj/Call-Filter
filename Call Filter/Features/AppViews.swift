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
			
			VStack(alignment: .center, spacing: 5) {
				
				Text("Spammer Database")
					.font(.system(size: 25))
					.fontWeight(.medium)

				
				HStack {
					Text("Call Spammers")
						.font(.callout)
					Text("\(viewModel.spamDbInfo?.callSpam ?? 0)")
				}
				
				HStack {
					Text("Sms Spammers")
						.font(.callout)
					Text("\(viewModel.spamDbInfo?.smsSpam ?? 0)")
				}
			}
			.padding(.bottom, 20)

			
			
			HStack(spacing: 20) {
				
				Button(action: {
					viewModel.updateSpamDb()
				}) {
					Text("Update")
						.font(.title)
				}
				
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
			
			List {
				ForEach(viewModel.spammer, id: \.id) { item in
//				ForEach(mockDataModel, id: \.id) { item in
					HStack {
						VStack(alignment: .leading) {
							Text("Number: \(item.number)")
								.font(.headline)
							Text("Location: \(item.state)")
								.font(.subheadline)
						}
						Spacer(minLength: 0)
						VStack {
							Image(systemName: item.type == .call ?  "phone" : "message")
								.foregroundColor(.red.opacity(0.9))
						}
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


// Settings View
struct SettingsView: View {
	@EnvironmentObject var viewModel: SettingsViewModel
	
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
				
				Toggle("Message Filter", isOn: $viewModel.settings.isMessage)
					.onChange(of: viewModel.settings.isMessage) {_ in
						self.viewModel.updateFilterSettings()
					}
					.font(.title2)
			}
			.padding()
			
			Spacer(minLength: 0)
		}
		.padding()
		.frame(maxHeight: .infinity)
	}
}

// Bottom Bar
struct BottomBar: View {
	@Binding var layoutType: LayoutType
	
	var body: some View {
		HStack(spacing: 40) {
			VStack {
				Image(systemName: "magnifyingglass")
					.font(.title)
					.foregroundColor((layoutType == .lookup) ? .red : .secondary)
					.onTapGesture {
						withAnimation(.easeIn(duration: 0.1)) {
							layoutType = .lookup
						}
					}
				
				Text("Lookup")
					.font(.callout)
			}
			
			VStack {
				Image(systemName: "flame")
					.font(.title)
					.foregroundColor((layoutType == .filter) ? .red : .secondary)
					.onTapGesture {
						withAnimation(.easeIn(duration: 0.1)) {
							layoutType = .filter
						}
					}
				
				Text("Filter")
					.font(.callout)
			}
			
			VStack {
				Image(systemName: "gear")
					.font(.title)
					.foregroundColor((layoutType == .settings) ? .red : .secondary)
					.onTapGesture {
						withAnimation(.easeIn(duration: 0.1)) {
							layoutType = .settings
						}
					}
				
				Text("Settings")
					.font(.callout)
			}
		}
	}
}



struct LookupView_Previews: PreviewProvider {

	@StateObject static var lookupViewModel = LookupViewModel()

	static var previews: some View {
		LookupView()
			.environmentObject(lookupViewModel)
	}
}



struct FilterView_Previews: PreviewProvider {
	@StateObject static var dbUpdateViewModel = DbUpdateViewModel()
	@StateObject static var statisticsViewModel = StatisticsViewModel()
	@StateObject static var lookupViewModel = LookupViewModel()

	static var previews: some View {
		FilterView()
			.environmentObject(dbUpdateViewModel)
			.environmentObject(statisticsViewModel)
			.environmentObject(lookupViewModel)
	}

}


let mockDataModel: [SpammerModel] = [
	.init(id: 0, number: "123-456-5678", state: "Ohio", type: .call),
	.init(id: 1, number: "123-456-5678", state: "Alaska", type: .sms)

]
