//
//  ImageLoader.swift
//  BarcodeReader
//
//  Created by Emma Sinclair on 7/22/23.
//

import Foundation
import AppKit

class ImageLoader: ObservableObject {
	@Published var image: NSImage?

	func load(from url: URL) {
		// implement the image loading from file URL here
	}
}
