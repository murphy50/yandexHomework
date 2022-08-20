// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import CocoaLumberjack

final class Logger {
    
    static func log(_ message: String) {
        DDLog.add(DDOSLogger.sharedInstance)
        DDLogInfo(message)
    }
}
