
import Foundation

struct HuffmanCompressor {
    
    static func compress(inputFilePath: String, outputCompressedPath: String) throws {
        let inputData = try Data(contentsOf: URL(fileURLWithPath: inputFilePath))
        print("Input file size: (\(inputData.count) bytes)")
        
        let huffman = HuffmanCode()
        let (encodedBits, codes) = huffman.encodeBytes(inputData)
        
        guard let compressedData = huffman.compressToFile(encodedBits: encodedBits, codes: codes) else {
            throw NSError(domain: "CompressionFailed", code: 1, userInfo: [NSLocalizedDescriptionKey: "Compression failed."])
        }
        do{
            try compressedData.write(to: URL(fileURLWithPath: outputCompressedPath))
        }catch{
            print(" Error: \(error.localizedDescription)")
        }
        
    }
    
    static func decompress(compressedFilePath: String, outputFilePath: String) throws {
        let compressedData = try Data(contentsOf: URL(fileURLWithPath: compressedFilePath))
        print("Compressed file size: (\(compressedData.count) bytes)")
        
        let huffman = HuffmanCode()
        let (decodedBits, codes) = try huffman.extractFromCompressedFile(compressedData)
        let decodedData = huffman.decodeBits(decodedBits, codes: codes)
        
        do{
            try decodedData.write(to: URL(fileURLWithPath: outputFilePath))
        }catch{
            print(" Error: \(error.localizedDescription)")
        }
    }
        
}

