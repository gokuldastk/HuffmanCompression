
import Foundation

class HuffmanCode {

    func encodeBytes(_ input: Data) -> (encodedBits: String, codes: [UInt8: String]) {
        var frequencies = [UInt8: Int]()
        for byte in input {
            frequencies[byte, default: 0] += 1
        }

        let tree = ByteHuffmanTree()
        guard let root = tree.buildTree(frequencies)
        else {
            return ("", [:])
        }

        var codes = [UInt8: String]()
        tree.generateHuffmanCodes(root, "", &codes)

        let encodedBits = input.map { codes[$0]! }.joined()
        return (encodedBits, codes)
    }

    func decodeBits(_ bits: String, codes: [UInt8: String]) -> Data {
        let reverseCodes = Dictionary(uniqueKeysWithValues: codes.map { ($1, $0) })
        var current = ""
        var output = [UInt8]()

        for bit in bits {
            current.append(bit)
            if let byte = reverseCodes[current] {
                output.append(byte)
                current = ""
            }
        }
        return Data(output)
    }

    //  Compressed File Handling

    func compressToFile(encodedBits: String, codes: [UInt8: String]) -> Data? {
        let (compressedData, validBits) = Self.bitStringToData(encodedBits)
        var codeTable = Data()

        codeTable.append(contentsOf: withUnsafeBytes(of: UInt16(codes.count).bigEndian, Array.init))

        // Appending table data to compressed data
        for (byte, code) in codes {
            codeTable.append(byte)
            codeTable.append(UInt8(code.count))
            codeTable.append(contentsOf: Self.bitStringToPacked(code))
        }

        var finalData = Data()
        finalData.append(UInt8(validBits))
        finalData.append(codeTable)
        finalData.append(compressedData)
        return finalData
    }

    func extractFromCompressedFile(_ data: Data) throws -> (String, [UInt8: String]) {
        var offset = 0
        let validBits = Int(data[offset]); // pading
        offset += 1

        let count = data.subdata(in: offset..<offset+2).withUnsafeBytes { $0.load(as: UInt16.self).bigEndian } // Table count
        offset += 2

        var codes = [UInt8: String]()
        for _ in 0..<count {
            let byte = data[offset]
            let bitLength = Int(data[offset + 1])
            offset += 2

            let bitBytes = (bitLength + 7) / 8
            let packedBits = data.subdata(in: offset..<offset + bitBytes)
            offset += bitBytes

            codes[byte] = Self.packedToBitString(packedBits).prefix(bitLength).description
        }

        let compressed = data[offset...]
        let bits = Self.dataToBitString(compressed, validBits)
        return (bits, codes)
    }

    //  Bit

    private static func bitStringToData(_ bits: String) -> (Data, Int) {
        
        var data = Data()
        var byte: UInt8 = 0
        var count = 0
        
        for bit in bits {
            byte <<= 1;
            if bit == "1" {
                byte |= 1
            }
            count += 1
            if count == 8 {
                data.append(byte);
                byte = 0;
                count = 0
            }
        }
        if count > 0 {
            byte <<= (8 - count);
            data.append(byte)
        }
        return (data, count == 0 ? 8 : count)
    }

    private static func dataToBitString(_ data: Data, _ validBits: Int) -> String {
        data.enumerated().map {
            let bits = String($0.element, radix: 2).padLeft(8, "0")
            return $0.offset == data.count - 1 ? String(bits.prefix(validBits)) : bits
        }.joined()
    }

    private static func bitStringToPacked(_ bits: String) -> Data {
        bitStringToData(bits).0
    }

    private static func packedToBitString(_ data: Data) -> String {
        data.map {
            String($0, radix: 2).padLeft(8, "0") }.joined()
    }
}

// padding
extension String {
    func padLeft(_ length: Int, _ char: Character) -> String {
        String(repeating: char, count: max(0, length - count)) + self
    }
}
