//
//  ContentView.swift
//  BarcodeReader
//
//  Created by Emma Sinclair on 7/22/23.
//

import AppKit
import SwiftUI

struct ContentView: View {
	@StateObject var imageLoader = ImageLoader()
	let barcodeReader = BarcodeReader()
	@State private var barcodeContent: [String] = []

	var body: some View {
		GeometryReader { geometry in
			VStack {
				VStack {
					if let image = imageLoader.image {
						Image(nsImage: image)
							.resizable()
							.aspectRatio(contentMode: .fit)
						if barcodeContent.isEmpty {
							Text("No results")
								.foregroundColor(.red)
						} else {
							ForEach(barcodeContent, id: \.self) { content in
								HStack {
									if
										let url = URL(string: content),
										let scheme = url.scheme,
										!scheme.isEmpty
									{
										Link(content, destination: url)
											.foregroundColor(.blue)
											.underline()
									} else {
										Text(content)
									}
									Button(action: {
										let pasteboard = NSPasteboard.general
										pasteboard.declareTypes([.string], owner: nil)
										pasteboard.setString(content, forType: .string)
									}) {
										Text("Copy")
									}
								}
							}
						}
					} else {
						Text("No image selected.")
					}
				}
				.onChange(of: imageLoader.image) { newValue in
					if let newImage = newValue {
						barcodeReader.readBarcode(from: newImage) { result in
							switch result {
							case .failure(let error):
								print(error)
							case .success(let result):
								self.barcodeContent = result
							}
						}
					}
				}
				.padding([.top, .horizontal])
				
				Spacer()

				Button(action: {
					let panel = NSOpenPanel()
					panel.canChooseFiles = true
					panel.canChooseDirectories = false
					panel.allowsMultipleSelection = false
					panel.allowedContentTypes = [.png, .jpeg, .tiff]
					panel.begin { response in
						if response == .OK, let url = panel.url {
							self.imageLoader.load(from: url)
						}
					}
				}) {
					Text("Load Image")
						.padding()
						.frame(minWidth: 0, maxWidth: .infinity)
						.cornerRadius(10)
				}
				.padding()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
