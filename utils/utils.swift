import Foundation

// read text file line by line
public func readFile(_ path: String, callback: (String) -> Void) -> Int {
    errno = 0
    if freopen(path, "r", stdin) == nil {
        perror(path)
        return 1
    }

    while let line = readLine() {
        callback(String(line))
    }
    return 0
}

public func getPath(_ filePath: String) -> String {
    var path = URL(fileURLWithPath: #file).absoluteString
    var index = path.lastIndex(of: "/")
    path = String(path.prefix(upTo: index!))
    index = path.lastIndex(of: "/")
    return String(path.prefix(upTo: index!)).dropFirst(7) + "/" + filePath
}

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
