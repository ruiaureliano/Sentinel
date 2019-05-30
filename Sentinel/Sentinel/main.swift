import Foundation

private let kVersion = "0.9.2"

/***
 * USAGE:
 *  sentinel [debug|release] [json]
 ***/

let arguments = CommandLine.arguments

if arguments.count > 2 {
    let configuration = arguments[1]
    let path = arguments[2]

    do {

        var settings: [String: Any] = [:]
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let pathExtension = (path as NSString).pathExtension.lowercased()

        if pathExtension == "json" {
            if let json = data.json as? [String: Any] {
                settings = json
            }
        }

        if settings.count > 0 {
            if configuration.lowercased() == "debug" {
                if let debug = settings["debug"] as? [[String: Any]] {
                    for instruction in debug {
                        if let rule = instruction["rule"] as? String,
                            let message = instruction["message"] as? String,
                            let type = instruction["type"] as? String,
                            let file = instruction["file"] as? String {

                            if type == "warning" || type == "error" {
                                var line = "rules=\"\(rule)\""
                                line.append("\nfind \"$SRCROOT\" \\( -name \"\(file)\" \\) -print0 ")
                                line.append("| xargs -0 egrep --with-filename --line-number")
                                line.append(" --only-matching \"($rules)\" ")
                                line.append("| perl -p -e \"s/($rules)/ \(type): \(message)/\"")

                                let task = Process()
                                task.launchPath = "/bin/bash"
                                task.arguments = ["-c", line]

                                let pipe = Pipe()
                                task.standardOutput = pipe
                                task.launch()

                                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                                if let output = String(data: data, encoding: .utf8) {
                                    debugPrint(output as AnyObject)
                                }
                            }
                        }
                    }

                    debugPrint("+----------------------------------------+" as AnyObject)
                    debugPrint("| USAGE: sentinel [debug|release] [json] |" as AnyObject)
                    debugPrint("| VERSION: \(kVersion)                         |" as AnyObject)
                    debugPrint("+----------------------------------------+" as AnyObject)
                    debugPrint("| DEBUG: Done                            |" as AnyObject)
                    debugPrint("+----------------------------------------+" as AnyObject)
                }
            } else if configuration.lowercased() == "release" {
                if let release = settings["release"] as? [[String: Any]] {
                    for instruction in release {
                        if let rule = instruction["rule"] as? String,
                            let message = instruction["message"] as? String,
                            let type = instruction["type"] as? String,
                            let file = instruction["file"] as? String {

                            if type == "warning" || type == "error" {
                                var line = "rules=\"\(rule)\""
                                line.append("\nfind \"${SRCROOT}\" \\( -name \"\(file)\" \\) -print0 ")
                                line.append("| xargs -0 egrep --with-filename --line-number")
                                line.append(" --only-matching \"($rules).*\\$\" ")
                                line.append("| perl -p -e \"s/($rules)/ \(type): \(message)/\"")

                                let task = Process()
                                task.launchPath = "/bin/bash"
                                task.arguments = ["-c", line]

                                let pipe = Pipe()
                                task.standardOutput = pipe
                                task.launch()

                                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                                if let output = String(data: data, encoding: .utf8) {
                                    debugPrint(output as AnyObject)
                                }
                            }
                        }
                    }

                    debugPrint("+----------------------------------------+" as AnyObject)
                    debugPrint("| USAGE: sentinel [debug|release] [json] |" as AnyObject)
                    debugPrint("| VERSION: \(kVersion)                         |" as AnyObject)
                    debugPrint("+----------------------------------------+" as AnyObject)
                    debugPrint("| RELEASE: Done                          |" as AnyObject)
                    debugPrint("+----------------------------------------+" as AnyObject)
                }
            }
        }
    } catch {
        debugPrint("+----------------------------------------+" as AnyObject)
        debugPrint("| USAGE: sentinel [debug|release] [json] |" as AnyObject)
        debugPrint("| VERSION: \(kVersion)                         |" as AnyObject)
        debugPrint("+----------------------------------------+" as AnyObject)
        debugPrint("| ERROR: Could not parse json            |" as AnyObject)
        debugPrint("+----------------------------------------+" as AnyObject)
    }
} else {
    debugPrint("+----------------------------------------+" as AnyObject)
    debugPrint("| USAGE: sentinel [debug|release] [json] |" as AnyObject)
    debugPrint("| VERSION: \(kVersion)                         |" as AnyObject)
    debugPrint("+----------------------------------------+" as AnyObject)
}
