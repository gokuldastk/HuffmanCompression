import Foundation

protocol Prioritizable: Comparable {
    var frequency: Int { get }
}

class MinPriorityQueue<T: Prioritizable> {
    
    private var heap: [T] = []
    var isEmpty: Bool { return heap.isEmpty }
    var count: Int { return heap.count }
    
    func enqueue(_ element: T) {
        heap.append((element))
        heapifyUp()
    }
    
    func dequeue() -> T? {
        
        if heap.isEmpty { return nil }
        if heap.count  == 1 { return heap.removeFirst() }
        heap.swapAt(0, heap.count - 1)
        let dequeued = heap.removeLast()
        heapifyDown()

        return dequeued
    }
    
    private func heapifyUp() {
        
        var childIndex = heap.count - 1
        var parentIndex = (childIndex - 1) / 2
        while childIndex > 0 && heap[childIndex].frequency < heap[parentIndex].frequency {
            heap.swapAt(childIndex, parentIndex)
            childIndex = parentIndex
            parentIndex = (childIndex - 1) / 2
        }
    }

    
    private func heapifyDown() {
        var parentIndex = 0
        
        while true {
            let leftChildIndex = 2 * parentIndex + 1
            let rightChildIndex = 2 * parentIndex + 2
            
            var maxIndex = parentIndex
            
            if leftChildIndex < heap.count &&
                heap[leftChildIndex].frequency < heap[maxIndex].frequency {
                maxIndex = leftChildIndex
            }
            if rightChildIndex < heap.count &&
                heap[rightChildIndex].frequency < heap[maxIndex].frequency {
                maxIndex = rightChildIndex
            }
            if maxIndex == parentIndex { return }
            
            heap.swapAt(parentIndex, maxIndex)
            parentIndex = maxIndex
        }
    }
    
}

