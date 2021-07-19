//
//  ViewExt.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/15/21.
//

import SwiftUI


extension UIScreen {
	static let screenWidth = UIScreen.main.bounds.size.width
	static let screenHeight = UIScreen.main.bounds.size.height
}


// https://www.hackingwithswift.com/forums/swiftui/textfield-dismiss-keyboard-clear-button/240
// extension for keyboard to dismiss
extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
