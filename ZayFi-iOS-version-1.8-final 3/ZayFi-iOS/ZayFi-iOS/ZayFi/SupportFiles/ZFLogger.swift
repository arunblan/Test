//
//  BELogger.swift
//  BeCoMap-iOS-SDK
//
//  Created by Mithin Thomas on 25/06/19.
//  Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
//

//REF: https://github.com/sauvikdolui/swiftlogger/blob/master/SwiftLogger/Debug/Logger.swift

import Foundation

enum LogEvent: String {
    case e = "‼️ [ZayFi SDK]" // error
    case i = "ℹ️ [ZayFi SDK]" // info
    case d = "💬 [ZayFi SDK]" // debug
}

var ZFdebugLogs: [String] = []
/**
 BELog
 - Version: 1.0
 - Copyright: Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
 */
class ZFLog {
    static var dateFormat = "yyyy-MM-dd hh:mm:ss.SSS z"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    /**
     *  BELog: errorLog:
     *
     *  Discussion:
     *      Logs Error messages
     *      This log is not public.
     *      Parameters
     *      - object: Object or message to be logged
     *      - filename: File name from where loggin to be done
     *      - line: Line number in file from where the logging is done
     *      - column: Column number of the log message
     *      - funcName: Name of the function from where the logging is done
     */
    class func errorLog( _ object: Any) {
        Swift.print("\(Date().toString()) \(LogEvent.e.rawValue) → \(object)")
    }
    
    /**
     *  BELog: infoLog:
     *
     *  Discussion:
     *      Logs info messages
     *      This log is public.
     */
    class func infoLog ( _ object: Any) {
        Swift.print("\(Date().toString()) \(LogEvent.i.rawValue) → \(object)")
    }
    
    /**
     *  BELog: debugLog:
     *
     *  Discussion:
     *      Logs debug messages
     *      This log is not public.
     *      Parameters
     *      - object: Object or message to be logged
     *      - filename: File name from where loggin to be done
     *      - line: Line number in file from where the logging is done
     *      - column: Column number of the log message
     *      - funcName: Name of the function from where the logging is done
     */
    class func debugLog( _ object: Any, filename: String = #file, funcName: String = #function) {
        if ZFDefault.getDataFromDefault(.isDebugMode) as? Bool == true {
            DispatchQueue.main.async {
                ZFdebugLogs.append("\(Date().toString()) → \(object)")
                Swift.print("\(Date().toString()) \(LogEvent.d.rawValue) → [\(sourceFileName(filePath: filename))]:\(funcName) → \(object)")
            }
        }
    }
    
    /**
     *  BELog: sourceFileName:
     *
     *  Discussion:
     *      Extract the file name from the file path
     *      - Parameter filePath: Full file path in bundle
     *      - Returns: File Name with extension
     */
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return ZFLog.dateFormatter.string(from: self as Date)
    }
}
