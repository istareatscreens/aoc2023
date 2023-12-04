import Foundation

extension String {
    subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start ... end])
    }

    subscript(bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start ..< end])
    }
}

// read text file line by line
public func readFile(_ path: String, callback: (Int, String) -> Void) {
    errno = 0
    if freopen(path, "r", stdin) == nil {
        perror(path)
        return
    }

    var row = 0
    while let line = readLine() {
        callback(row, String(line))
        row += 1
    }
}

public func getPath(_ filePath: String) -> String {
    var path = URL(fileURLWithPath: #file).absoluteString
    var index = path.lastIndex(of: "/")
    path = String(path.prefix(upTo: index!))
    index = path.lastIndex(of: "/")
    return String(path.prefix(upTo: index!)).dropFirst(7) + "/" + filePath
}

func printSolutionOne(_ solution: Any) {
    print("🎄 Solution 1 = \(solution)  🎄")
}

func printSolutionTwo(_ solution: Any) {
    print("🎄 Solution 2 = \(solution)  🎄")
}

func getAllSubstrings(_ str: String) -> [String] {
    var result: [String] = []
    for i in 0 ..< str.count + 1 {
        for j in (i + 1) ..< str.count + 1 {
            result.append(str[i ..< j])
        }
    }
    return result
}

func updateDictionary<K, V: Comparable>(key: K, value: V, condition: (_ value: V) -> Bool, dict: inout [K: V]) {
    guard let foundValue: V = dict[key] else {
        dict[key] = value
        return
    }
    if condition(foundValue) {
        dict[key] = value
    }
}
