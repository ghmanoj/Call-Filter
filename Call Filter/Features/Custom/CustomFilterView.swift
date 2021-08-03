//
//  CustomFilterView.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/29/21.
//

import SwiftUI


// MARK: - Add Custom Filter Sheet
struct AddCustomSpammer: View {
	@ObservedObject var viewModel = ObjectUtils.customSpammerViewModel
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@State var isCallType = false
	@State var isSmsType = false
	
	@State var location = ""
	@State var selectedState = ""
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			Text("Add Custom Filter")
				.font(.title)
				.padding(.bottom, 30)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			Text("Number")
				.font(.title2)
				.frame(width: 120, alignment: .leading)
			TextField("", text: $viewModel.inputNumber)
				.padding([.horizontal, .vertical], 10)
				.background(getBackground())
				.cornerRadius(10)
				.keyboardType(.phonePad)
			
			Text("Location")
				.font(.title2)
				.frame(width: 120, alignment: .leading)
			
			
			Picker("State", selection: $viewModel.selectedState) {
				ForEach(viewModel.usStates, id: \.id) {
					Text($0.abbreviation)
				}
			}
			
			HStack(alignment: .top , spacing: 20) {
				Text("Type")
					.font(.title2)
					.frame(width: 120, alignment: .leading)
				
				VStack(spacing: 10) {
					Toggle("Call", isOn: $viewModel.isCallType)
					Toggle("SMS", isOn: $viewModel.isSmsType)
				}
				.font(.title2)
			}
			
			
			Button(action: {
				print("Saving....")
			}) {
				Text("Save")
					.font(.title)
					.foregroundColor(.white)
					.padding(.vertical, 10)
					.frame(maxWidth: .infinity)
			}
			.background(Color.red)
			.cornerRadius(25)
			.padding(.bottom)
			
			Spacer(minLength: 0)
		}
		.padding([.vertical, .horizontal], 30)
	}
	
	func getBackground() -> Color {
		return colorScheme == .dark
			? Color.white.opacity(0.1)
			: Color.black.opacity(0.1)
	}
}

// MARK: - Custom Spammer View (user input to spammer db)
struct CustomSpammerView: View {
	@ObservedObject var viewModel = CustomSpammerViewModel()
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@State var isFormPresented = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			HStack(alignment: .center) {
				Text("Custom Filters")
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.title)
				
				Button(action: {
					isFormPresented.toggle()
				}) {
					Text("Add")
				}
			}.sheet(isPresented: $isFormPresented) {
				AddCustomSpammer()
			}
			
			List {
				ForEach(viewModel.manualInput, id: \.id) { item in
					SpammerItem(item: item)
				}
			}
			.onAppear {
				viewModel.fetchManualInputData()
			}
			
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
