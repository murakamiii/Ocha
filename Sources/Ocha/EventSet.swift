//
//  EventSet.swift
//  Ocha
//
//  Created by Yudai.Hirose on 2019/03/01.
//

import Foundation

public struct EventSet: OptionSet {
    public let rawValue: Int
    public typealias RawValue = Int
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public static let none = EventSet(rawValue: kFSEventStreamEventFlagNone) // 0
    public static let mustScanSubDirs = EventSet(rawValue: kFSEventStreamEventFlagMustScanSubDirs) // 1
    public static let userDropped = EventSet(rawValue: kFSEventStreamEventFlagUserDropped) // 2
    public static let kernelDropped = EventSet(rawValue: kFSEventStreamEventFlagKernelDropped) // 4
    public static let eventIdsWrapped = EventSet(rawValue: kFSEventStreamEventFlagEventIdsWrapped) // 8
    public static let historyDone = EventSet(rawValue: kFSEventStreamEventFlagHistoryDone) // 16
    public static let rootChanged = EventSet(rawValue: kFSEventStreamEventFlagRootChanged) // 32
    public static let mount = EventSet(rawValue: kFSEventStreamEventFlagMount) // 64
    public static let unmount = EventSet(rawValue: kFSEventStreamEventFlagUnmount) // 128
    public static let itemCreated = EventSet(rawValue: kFSEventStreamEventFlagItemCreated) // 256
    public static let itemRemoved = EventSet(rawValue: kFSEventStreamEventFlagItemRemoved) // 512
    public static let itemInodeMetaMod = EventSet(rawValue: kFSEventStreamEventFlagItemInodeMetaMod) // 1024
    public static let itemRenamed = EventSet(rawValue: kFSEventStreamEventFlagItemRenamed) // 2048
    public static let itemModified = EventSet(rawValue: kFSEventStreamEventFlagItemModified) // 4096
    public static let itemFinderInfoMod = EventSet(rawValue: kFSEventStreamEventFlagItemFinderInfoMod) // 8192
    public static let itemChangeOwner = EventSet(rawValue: kFSEventStreamEventFlagItemChangeOwner) // 16384
    public static let itemXattrMod = EventSet(rawValue: kFSEventStreamEventFlagItemXattrMod) // 32768
    public static let itemIsFile = EventSet(rawValue: kFSEventStreamEventFlagItemIsFile) // 65536
    public static let itemIsDir = EventSet(rawValue: kFSEventStreamEventFlagItemIsDir) // 131072
    public static let itemIsSymlink = EventSet(rawValue: kFSEventStreamEventFlagItemIsSymlink) // 262144
    public static let ownEvent = EventSet(rawValue: kFSEventStreamEventFlagOwnEvent) // 524288
    public static let itemIsHardlink = EventSet(rawValue: kFSEventStreamEventFlagItemIsHardlink) // 1048576
    public static let itemIsLastHardlink = EventSet(rawValue: kFSEventStreamEventFlagItemIsLastHardlink) // 2097152
    @available(OSX 10.13, *)
    public static let itemCloned = EventSet(rawValue: kFSEventStreamEventFlagItemCloned) // 4194304
    
    public static let xcodeFileAddedFirstEventSet: EventSet = [.itemCreated, .itemRenamed, .itemModified, .itemXattrMod, .itemIsFile]
    public static let xcodeFileAddedSecondEventSet: EventSet = [.itemRenamed, .itemIsFile]
    
    public static let createdFile: EventSet = [.itemCreated, .itemIsFile]
    public static let removedFile: EventSet = [.itemRemoved, .itemIsFile]
    public static let trashedFile: EventSet = [.itemRenamed, .itemIsFile] // e.g) Command + DEL. If you use in machintosh
    public static let openedFile: EventSet = [.itemXattrMod, .itemIsFile]
    
    public static let createdDirectory: EventSet = [.itemCreated, .itemIsDir]
    public static let removedDirectory: EventSet = [.itemRemoved, .itemIsDir]
    public static let trashedDirectory: EventSet = [.itemRenamed, .itemIsDir] // e.g) Command + DEL. If you use in machintosh
}

extension EventSet: CaseIterable {
    public typealias AllCases = [EventSet]
    
    public static var baseAllCases: [EventSet] {
        return [
            .none,
            .mustScanSubDirs,
            .userDropped,
            .kernelDropped,
            .eventIdsWrapped,
            .historyDone,
            .rootChanged,
            .mount,
            .unmount,
            .itemCreated,
            .itemRemoved,
            .itemInodeMetaMod,
            .itemRenamed,
            .itemModified,
            .itemFinderInfoMod,
            .itemChangeOwner,
            .itemXattrMod,
            .itemIsFile,
            .itemIsDir,
            .itemIsSymlink,
            .ownEvent,
            .itemIsHardlink,
            .itemIsLastHardlink,
        ]
    }
    public static var allCases: [EventSet] {
        if #available(OSX 10.13, *) {
            return baseAllCases + [itemCloned]
        } else {
            return baseAllCases
        }
    }
}

extension EventSet: CustomDebugStringConvertible {
    func eachOptionDebugDescription(option: EventSet) -> String {
        if #available(OSX 10.13, *) {
            if case .itemCloned = option {
                return "itemCloned"
            }
        }
        switch option {
        case .none: return "none"
        case .mustScanSubDirs: return "mustScanSubDirs"
        case .userDropped: return "userDropped"
        case .kernelDropped: return "kernelDropped"
        case .eventIdsWrapped: return "eventIdsWrapped"
        case .historyDone: return "historyDone"
        case .rootChanged: return "rootChanged"
        case .mount: return "mount"
        case .unmount: return "unmount"
        case .itemCreated: return "itemCreated"
        case .itemRemoved: return "itemRemoved"
        case .itemInodeMetaMod: return "itemInodeMetaMod"
        case .itemRenamed: return "itemRenamed"
        case .itemModified: return "itemModified"
        case .itemFinderInfoMod: return "itemFinderInfoMod"
        case .itemChangeOwner: return "itemChangeOwner"
        case .itemXattrMod: return "itemXattrMod"
        case .itemIsFile: return "itemIsFile"
        case .itemIsDir: return "itemIsDir"
        case .itemIsSymlink: return "itemIsSymlink"
        case .ownEvent: return "ownEvent"
        case .itemIsHardlink: return "itemIsHardlink"
        case .itemIsLastHardlink: return "itemIsLastHardlink"
        case _:
            return "Unknown option: \(option.rawValue)"
        }
    }
    
    public var debugDescription: String {
        if self == .none {
            return eachOptionDebugDescription(option: .none)
        }
        return EventSet
            .allCases
            .filter { $0 != .none } // none is usually contains...
            .filter { self.contains($0) }
            .map { eachOptionDebugDescription(option: $0) }
            .joined(separator: ", ")
    }
}

extension EventSet: Equatable {
    public static func == (lhs: EventSet, rhs: EventSet) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
