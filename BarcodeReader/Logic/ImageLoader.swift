//
//  ImageLoader.swift
//  BarcodeReader
//
//  Created by Emma Sinclair on 7/22/23.
//

import Foundation
import SwiftUI
import AppKit

class ImageLoader: ObservableObject {
	@Published var image: NSImage?

	@MainActor
	func load(from url: URL) {
		guard let image = NSImage(contentsOf: url) else {
			print("Unable to load image from URL: \(url)")
			return
		}

		self.image = image
	}
}

