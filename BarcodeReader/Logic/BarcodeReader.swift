//
//  BarcodeReader.swift
//  BarcodeReader
//
//  Created by Emma Sinclair on 7/22/23.
//

import Foundation
import AppKit
import Vision

class BarcodeReader {
	func readBarcode(from image: NSImage, completion: @escaping (Result<[String], Error>) -> Void) {
		guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
			completion(.failure(NSError(domain: "ImageProcessing", code: 100, userInfo: [NSLocalizedDescriptionKey: "Unable to create CGImage from input image."])))
			return
		}

		let request = VNDetectBarcodesRequest { [weak self] (request, error) in
			if let error = error {
				completion(.failure(error))
			} else {
				completion(.success(self?.processClassification(request: request) ?? []))
			}
		}

		let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

		do {
			try handler.perform([request])
		} catch {
			completion(.failure(error))
		}
	}

	func processClassification(request: VNRequest) -> [String] {
		guard
			let results = request.results,
			let classifications = results as? [VNBarcodeObservation]
		else {
			return []
		}

		if classifications.isEmpty {
			return []
		} else {
			return classifications.compactMap {
				$0.payloadStringValue
			}
		}
	}
}
