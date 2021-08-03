//
//  AppViews.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//

import SwiftUI


// MARK: - List Item SpammerModel
struct SpammerItem: View {
	let item: SpammerModel
	
	var body: some View {
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


// MARK: - Bottom Bar Button
struct NavButton: View {
	let image: String
	let label: String
	let type: LayoutType
	
	@Binding var layoutType: LayoutType
	
	var body: some View {
		VStack {
			Image(systemName: image)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 30, height: 30)
				.font(.title)
				.foregroundColor((layoutType == type) ? .red : .secondary)
				.onTapGesture {
					generateHepaticFeedback()
					withAnimation(.easeIn(duration: 0.1)) {
						layoutType = type
					}
				}
			Text(label)
				.font(.callout)
		}
	}
}


// MARK: - Bottom Bar
struct BottomBar: View {
	@Binding var layoutType: LayoutType
	
	var body: some View {
		HStack(spacing: 40) {
			
			NavButton(image: "magnifyingglass", label: "Lookup", type: .lookup, layoutType: $layoutType)
			
			NavButton(image: "gauge", label: "Custom", type: .customspammer, layoutType: $layoutType)
			
			NavButton(image: "flame", label: "Filter", type: .filter, layoutType: $layoutType)
			
			NavButton(image: "gear", label: "Settings", type: .settings, layoutType: $layoutType)
			
		}
	}
	
}
