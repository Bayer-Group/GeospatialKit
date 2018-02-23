internal extension Collection {
    var empty: Bool { return count == 0 }
    
    var head: Self.Iterator.Element? { return first }
}
