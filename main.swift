

import Foundation

let inputFilePath = "/Users/gokul/Documents/study_projects/Huffman Encoding/input.txt"
let compressedFilePath = "/Users/gokul/Documents/study_projects/Huffman Encoding/output_encoded.gokul"
let decodedOutputPath = "/Users/gokul/Documents/study_projects/Huffman Encoding/output_decoded.txt"

do {

    try HuffmanCompressor.compress(inputFilePath: inputFilePath, outputCompressedPath: compressedFilePath)
    try HuffmanCompressor.decompress(compressedFilePath: compressedFilePath, outputFilePath: decodedOutputPath)
    print("Success")
} catch {
    print(" Error during compression: \(error.localizedDescription)")
}

