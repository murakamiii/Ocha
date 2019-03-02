import Foundation
import Ocha
import SwiftShell
import PathKit
import RagnarokCore

print("You can confirm for `Ocha` is watched file changes when edit and save this file.")

let path = Path(#file)
let pathString = path.absolute().string

func ragnarok() {
    do {
        let ragnarok = try RagnarokRewriter.init(path: pathString)
        let content = try String(contentsOf: path.url)
        let formatted = try ragnarok.formatted()
        if content == formatted {
            return
        }
        try ragnarok.exec()
    } catch {
        print("[ERROR]: \(error.localizedDescription)")
        exit(1)
    }
}

let watcher = Watcher(paths: [pathString])
watcher.start { (events) in
    print(events)
    if events.isAddedFileInXcodeEvent() {
        print("xcode added: \(events.extractAddedFileWhenAddedFromXcode())")
    }
    events.forEach { event in
        print("------- path: \(event.path) --------")
        EventSet.allCases.forEach { set in
            print("\(set): \(event.flag.contains(set))")
        }
        ragnarok()
    }
}


RunLoop.current.run()
