internal extension Array {
    var tail: Array? {
        let tail = Array(dropFirst())
        if tail.empty { return nil }
        return tail
    }
}
