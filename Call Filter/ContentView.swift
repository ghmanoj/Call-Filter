//
//  ContentView.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/14/21.
//

import SwiftUI

struct ContentView: View {
	@State var isLookup = false
	
	var body: some View {
		VStack {
			if isLookup {
				LookupView()
			} else {
				FilterView()
			}
			BottomBar(isLookup: $isLookup)
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


struct UpdateFilterDbCard: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@State var rotationAngle: Double = 0
	@State var updatingImage = "sun.min"
	
	var body: some View {
		VStack {
			HStack {
				Text("Spammer")
					.font(.system(size: 25))
					.fontWeight(.medium)
				
				Image(systemName: updatingImage)
					.foregroundColor(.red)
					.rotationEffect(.degrees(rotationAngle))
					.font(.title)
					.padding(.horizontal, 1)
				
				Text("Database")
					.font(.system(size: 25))
					.fontWeight(.medium)
			}
			.padding(.vertical)
			
			Button(action: {
				withAnimation {
					for i in 0..<10 {
						rotationAngle += Double(i)*5.0
					}
				}
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

struct ActionsStatistics: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme

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
				Text("12345")
			}
			.font(.title2)
			
			HStack {
				Text("SMS Identified")
				Spacer(minLength: 0)
				Text("3224")
			}
			.font(.title2)

			HStack {
				Text("Blocked")
				Spacer(minLength: 0)
				Text("90%")
			}
			.font(.title2)
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

struct TopLocationStatistics: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	
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
			
			ForEach(topSpammers.sorted{$0.count > $1.count}, id: \.id) { spammer in
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
	@StateObject var viewModel = LookupViewModel()
	
	var body: some View {
		VStack {
			
			VStack {
				HStack {
					Image(systemName: "magnifyingglass")
						.font(.title2)
						.foregroundColor(.gray)
						.padding(.trailing, 8)
					
					TextField("Search Phone Number", text: $viewModel.numberQuery)
						.autocapitalization(.none)
						.disableAutocorrection(true)
						.font(.title)
				}
				.padding()
				.background(getBackground())
				.cornerRadius(25)
				
				
				Text(viewModel.showPrompt ? "Number format 123-456-7890" : "")
					.font(.callout)
					.foregroundColor(.secondary)
					.padding(.top, 5)
				
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
				ActionsStatistics()
			}
			.padding()

			HStack {
				TopLocationStatistics()
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


class LookupViewModel: ObservableObject {
	@Published var numberQuery = ""
	@Published var showPrompt = true
}



struct SpammerLocation: Identifiable {
	var id = UUID()
	let state: String
	let count: Int
}


let topSpammers: [SpammerLocation] = [
	.init(state: "Arizona", count: 100),
	.init(state: "California", count: 50),
	.init(state: "New York", count: 3290),
	.init(state: "Ohio", count: 321)
]

