//
//  FilterView.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/29/21.
//

import SwiftUI


// MARK: - Update Filter Database Card
struct UpdateFilterDbCard: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@ObservedObject var viewModel = ObjectUtils.dbUpdateViewModel
	
	@State var viewShowing = false
	
	var foreverAnimation: Animation {
		Animation.linear(duration: 0.5)
			.repeatForever(autoreverses: false)
	}
	
	@State var updatingImage = "arrow.triangle.2.circlepath"
	
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
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 20, height: 20)
					.foregroundColor(viewModel.isUpdating ? .primary : .secondary)
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
	@ObservedObject var viewModel = ObjectUtils.statisticsViewModel
	
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
	@ObservedObject var viewModel = ObjectUtils.statisticsViewModel
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
