//
//  AppViews.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//

import SwiftUI


// MARK: - Update Filter Database Card
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
			
			VStack {
				Button(action: {
					viewModel.clearSpamDb()
				}) {
					Text("ClearDB")
						.font(.title2)
				}
				.foregroundColor(.red)
			}
			.padding(.top, 8)
			
		}
		.padding()
		.frame(maxWidth: .infinity)
		.frame(height: UIScreen.screenHeight / 3.8)
		.background(getBackground())
		.cornerRadius(20)
	}
	
	func getBackground() -> Color {
		return colorScheme == .dark
			? Color.white.opacity(0.1)
			: Color.black.opacity(0.1)
	}
}


// MARK: - Actions Statistics View
struct ActionsStatisticsView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@EnvironmentObject var viewModel: StatisticsViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
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
		.frame(height: UIScreen.screenHeight / 3.8)
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


// MARK: - Top Location Statistics View (Card)
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
			
			Spacer(minLength: 0)
		}
		.padding()
		.frame(maxWidth: .infinity)
		.frame(minHeight: UIScreen.screenHeight / 3.8)
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


// MARK: - Filter View
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


// MARK: - Settings View
struct SettingsView: View {
	
	@AppStorage("isDarkMode") var isDarkMode: Bool = true
	
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

// MARK: - Add Custom (user input to spammer db)
struct AddCustomSpammerView: View {
	@EnvironmentObject var viewModel: CustomSpammerViewModel
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	
	@State var number = ""
	@State var isCallType = false
	@State var isSmsType = false

	@State var location = ""
	
	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			Text("Add Custom Filters")
				.frame(maxWidth: .infinity)
				.font(.title)
				.padding(.bottom, 30)
			
			HStack(spacing: 20) {
				Text("Number")
					.font(.title2)
					.frame(width: 120, alignment: .leading)
				TextField("", text: $number)
					.padding([.horizontal, .vertical], 10)
					.background(getBackground())
					.cornerRadius(10)
			}
			
			
			HStack(spacing: 20) {
				Text("Location")
					.font(.title2)
					.frame(width: 120, alignment: .leading)
				
				TextField("", text: $location)
					.padding([.horizontal, .vertical], 10)
					.background(getBackground())
					.cornerRadius(10)
			}
			
			HStack(alignment: .top , spacing: 20) {
				Text("Type")
					.font(.title2)
					.frame(width: 120, alignment: .leading)
				
				VStack(spacing: 10) {
					Toggle("Call", isOn: $isCallType)
					Toggle("SMS", isOn: $isSmsType)
				}
				.frame(maxWidth: 110)
				.font(.title2)
			}
				
			
			Button(action: {}) {
				Text("Save")
					.font(.title)
					.foregroundColor(.white)
					.padding(.vertical, 15)
					.frame(maxWidth: .infinity)
			}
			.background(Color.red)
			.cornerRadius(25)
			
			Spacer(minLength: 0)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	func getBackground() -> Color {
		return colorScheme == .dark
			? Color.white.opacity(0.1)
			: Color.black.opacity(0.1)
	}
}


// MARK: - Bottom Bar
struct BottomBar: View {
	@Binding var layoutType: LayoutType
	
	var body: some View {
		HStack(spacing: 40) {
			VStack {
				Image(systemName: "magnifyingglass")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 30, height: 30)
					.font(.title)
					.foregroundColor((layoutType == .lookup) ? .red : .secondary)
					.onTapGesture {
						generateHepaticFeedback()
						withAnimation(.easeIn(duration: 0.1)) {
							layoutType = .lookup
						}
					}
				Text("Lookup")
					.font(.callout)
			}
			
			
			VStack {
				Image(systemName: "plus")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 30, height: 30)
					.font(.title)
					.foregroundColor((layoutType == .addcustom) ? .red : .secondary)
					.onTapGesture {
						generateHepaticFeedback()
						withAnimation(.easeIn(duration: 0.1)) {
							layoutType = .addcustom
						}
					}
				Text("Add")
					.font(.callout)
			}
			
			VStack {
				Image(systemName: "flame")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 30, height: 30)
					.font(.title)
					.foregroundColor((layoutType == .filter) ? .red : .secondary)
					.onTapGesture {
						generateHepaticFeedback()
						withAnimation(.easeIn(duration: 0.1)) {
							layoutType = .filter
						}
					}
				
				Text("Filter")
					.font(.callout)
			}
			
			
			VStack {
				Image(systemName: "gear")
					.resizable()
					.frame(width: 30, height: 30)
					.font(.title)
					.foregroundColor((layoutType == .settings) ? .red : .secondary)
					.onTapGesture {
						generateHepaticFeedback()
						withAnimation(.easeIn(duration: 0.1)) {
							layoutType = .settings
						}
					}
				Text("Settings")
					.font(.callout)
			}
		}
	}
	
	// for light hepatic feedback when bottom bar buttons are tapped
	private func generateHepaticFeedback() {
		let generator = UIImpactFeedbackGenerator(style: .light)
		generator.impactOccurred()
	}
}


struct AddCustomSpammerView_Previews: PreviewProvider {
	@StateObject static var customSpammerViewModel = CustomSpammerViewModel()
	
	static var previews: some View {
		AddCustomSpammerView()
			.environmentObject(customSpammerViewModel)
	}
}


//struct LookupView_Previews: PreviewProvider {
//
//	@StateObject static var lookupViewModel = LookupViewModel()
//
//	static var previews: some View {
//		LookupView()
//			.environmentObject(lookupViewModel)
//	}
//}

//
//
//struct FilterView_Previews: PreviewProvider {
//	@StateObject static var dbUpdateViewModel = DbUpdateViewModel()
//	@StateObject static var statisticsViewModel = StatisticsViewModel()
//	@StateObject static var lookupViewModel = LookupViewModel()
//
//	static var previews: some View {
//		FilterView()
//			.environmentObject(dbUpdateViewModel)
//			.environmentObject(statisticsViewModel)
//			.environmentObject(lookupViewModel)
//	}
//}
