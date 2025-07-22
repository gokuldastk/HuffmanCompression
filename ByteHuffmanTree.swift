

class ByteHuffmanNode: Prioritizable {
    var byte: UInt8?
    var frequency: Int
    var left: ByteHuffmanNode?
    var right: ByteHuffmanNode?

    init(_ byte: UInt8?, _ frequency: Int) {
        self.byte = byte
        self.frequency = frequency
    }

    static func == (lhs: ByteHuffmanNode, rhs: ByteHuffmanNode) -> Bool {
        return lhs.frequency == rhs.frequency
    }

    static func < (lhs: ByteHuffmanNode, rhs: ByteHuffmanNode) -> Bool {
        return lhs.frequency < rhs.frequency
    }

    static func > (lhs: ByteHuffmanNode, rhs: ByteHuffmanNode) -> Bool {
        return lhs.frequency > rhs.frequency
    }
}

class ByteHuffmanTree {
    func buildTree(_ frequencies: [UInt8: Int]) -> ByteHuffmanNode? {
        let pq = MinPriorityQueue<ByteHuffmanNode>()
        for (byte, freq) in frequencies {
            pq.enqueue(ByteHuffmanNode(byte, freq))
        }
        while pq.count > 1 {
            let left = pq.dequeue()!
            let right = pq.dequeue()!
            let parent = ByteHuffmanNode(nil, left.frequency + right.frequency)
            parent.left = left
            parent.right = right
            pq.enqueue(parent)
        }
        return pq.dequeue()
    }

    func generateHuffmanCodes(_ node: ByteHuffmanNode, _ code: String, _ codes: inout [UInt8: String]) {
        if let byte = node.byte {
            codes[byte] = code
        } else {
            if let left = node.left { generateHuffmanCodes(left, code + "0", &codes) }
            if let right = node.right { generateHuffmanCodes(right, code + "1", &codes) }
        }
    }
}
