#  Huffman Compression in Swift

This project implements **Huffman Encoding and Decoding** in Swift to compress any file — text, binary, or image — using the lossless Huffman compression technique.

## Features
### Supports:

- Compression and decompression of text files, images, and any binary data.
- Self-contained compressed file (stores header + compressed data).
- Lossless compression with verification.
- Simple-to-use interface with a clean Swift API.
- Works as a library module with minimal main function code.

---

##  Project Structure

| File                  | Description                                               |
|-----------------------|-----------------------------------------------------------|
| `main.swift`          | Example usage that compresses and decompresses a file.    |
| `HuffmanCode.swift`   | Core logic: Huffman encoding, decoding, file handling.    |
| `ByteHuffmanTree.swift` | Tree-building using Min-Heap and Node structure.         |
| `PriorityQueue.swift` | Generic min-priority queue to build the tree efficiently. |

---

##  Compressed File Format

The compressed `.gokul` file contains both data and metadata, stored in this format:

| **Section**            | **Size (Bytes)** | **Description**                                                                            |
|------------------------|------------------|--------------------------------------------------------------------------------------------|
| `Padding Info`         | 1                | Number of valid bits in the last byte of compressed data.                                  |
| `Code Table Count`     | 2 (UInt16)       | Number of unique byte symbols in the file.                                                 |
| `Code Table Entries`   | Variable         | Each entry has 1 byte for symbol, 1 byte for code length, and `ceil(length/8)` packed bits.|
| → Symbol (Byte)        | 1                | The actual byte (e.g., `0x41` for `'A'`).                                                  |
| → Code Length (Bits)   | 1                | The bit-length of Huffman code.                                                            |
| → Packed Code          | N bytes          | Code packed into bytes.                                                                    |
| `Compressed Data`      | Variable         | The actual Huffman-encoded data bitstream in packed bytes.                                 |

---

##  How It Works

### Step-by-Step Compression & Decompression Flow

#### 1.  Read File
- Load any file (text/image/binary) using `Data(contentsOf:)`.

#### 2.  Count Frequencies
- Count how many times each byte appears in the file. 
- Store this in a dictionary: `[UInt8: Int]`.

#### 3.  Build Huffman Tree
- Use a Min-Heap to combine the lowest frequency nodes into a binary tree.
- Each leaf node represents a symbol.

#### 4.  Generate Huffman Codes
- Traverse the tree using **pre-order traversal**.
- Assign `'0'` for left and `'1'` for right traversal.
- Generate a unique binary code for each symbol.

#### 5.  Encode the Input
- Replace each byte in the original data with its Huffman code.
- Result: a long bit string (e.g., `"011011000..."`).

#### 6.  Build Compressed File
- Pack the bitstring into bytes.
- Add header: padding info + code table.
- Save as `.gokul` or any custom extension.

#### 7.  Decode the Compressed File
- Read the header to rebuild the code table.
- Convert the packed bitstream back into the original byte data.

#### 8.  Save Decoded Output
- Write the decompressed bytes to a file.
- Optional: verify it matches the original input using `Data == Data`.

---


<img width="3004" height="760" alt="image" src="https://github.com/user-attachments/assets/39f4e8e6-201f-467e-ba04-e22eca2992c7" />

## Example Walkthrough (for understanding)

- Padding Info = 4 → last byte of compressed data only has 4 valid bits.
- Code Count = 3 → there are 3 unique symbols.
- Code Table Entries = for example:
  
[Symbol: A][Length: 3][Code: 101]

[Symbol: B][Length: 2][Code: 11]

[Symbol: C][Length: 4][Code: 0101]
- Compressed Data = Encoded bitstream of your actual input using the codes above, packed into bytes.

## Author
### Gokul Das T K

Built as a learning project on compression algorithms.
