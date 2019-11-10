//
//  View+PartialSheetModifier.swift
//  PartialModal
//
//  Created by Miotto Andrea on 10/11/2019.
//  Copyright © 2019 Miotto Andrea. All rights reserved.
//

import SwiftUI

extension View {

	/**
	Presents a **Partial Sheet**  with a dynamic height based on his content.
	- parameter presented: This should be set to true when the Partial Sheet has to be displayed.
	- parameter backgroundColor: The background color for the Sheet. Default is *Color.white*.
	- parameter handlerBarColor:The  color for the Handler Bar. Default is *Color.gray*.
	- parameter enableCover: Enable a cover view under the Sheet. Touching it makes the Sheet disappears.
	Default is *true*.
	- parameter coverColor: The background color for the Cover View. Default is *Color.black.opacity(0.2)*.
	- parameter view: The content to place inside of the Partial Sheet.
	*/
	public func partialSheet<SheetContent: View>(
		presented: Binding<Bool>,
		backgroundColor: Color = Color.white,
		handlerBarColor: Color = Color.gray,
		enableCover: Bool = true,
		coverColor: Color = Color.black.opacity(0.4),
		view: @escaping () -> SheetContent ) -> some View {
		self.modifier(
			PartialSheet(
				presented: presented,
				backgroundColor: backgroundColor,
				handlerBarColor: handlerBarColor,
				enableCover: enableCover,
				coverColor: coverColor,
				view: view
			)
		)
	}
}
