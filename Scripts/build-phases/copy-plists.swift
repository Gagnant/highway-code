#!/usr/bin/xcrun --sdk macosx swift

import Foundation

class Script {

    static var inputs: [String] {
        return arguments(prefix: "SCRIPT_INPUT_FILE_")
    }

    static var outputs: [String] {
        return arguments(prefix: "SCRIPT_OUTPUT_FILE_")
    }

    private static func environment<T>(name: String, convert: (String) -> T?) -> T {
        guard let environment = ProcessInfo.processInfo.environment[name],
              let value = convert(environment) else {
            fatalError()
        }
        return value
    }

    private static func arguments(prefix: String) -> [String] {
        let getArgument: (Int) -> String = { index in
            return environment(name: prefix + String(index)) { $0 }
        }
        let argsCount = environment(name: prefix + "COUNT", convert: Int.init)
        let bounds = (0, argsCount - 1)
        return ClosedRange(uncheckedBounds: bounds).map(getArgument)
    }

}

extension NSMutableDictionary {

    @objc func accept(visitor: Processor) {
        visitor.process(dictionary: self)
    }

}

extension NSMutableArray {

    @objc func accept(visitor: Processor) {
        visitor.process(array: self)
    }

}

extension NSMutableString {

    @objc func accept(visitor: Processor) {
        visitor.process(string: self)
    }

}

class Processor: NSObject {

    func process(dictionary: NSMutableDictionary) {
        dictionary.allValues.forEach(processAny)
    }

    func process(array: NSMutableArray) {
        array.forEach(processAny)
    }

    func process(string: NSMutableString) {
        ProcessInfo.processInfo.environment.forEach { (key, value) in
            let encodedKey = "$(" + key + ")"
            let range = NSMakeRange(0, string.length)
            string.replaceOccurrences(of: encodedKey, with: value, range: range)
        }
    }

    private func processAny(_ any: Any) {
        let value = any as AnyObject
        value.accept?(visitor: self)
    }

}

func main() throws {
    let data = try Script.inputs.compactMap(FileManager.default.contents).map { data throws -> Data in
        let object = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as AnyObject
        object.accept?(visitor: Processor())
        return try PropertyListSerialization.data(fromPropertyList: object, format: .xml, options: 0)
    }
    let outputs = Script.outputs.map {
        return URL(fileURLWithPath: $0)
    }
    assert(data.count == outputs.count, "Invalid parameters!")
    try zip(outputs, data).forEach { (output, data) throws in
        try data.write(to: output, options: .atomic)
    }
}

try main()
