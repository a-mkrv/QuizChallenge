//
//  Logger.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 12/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

enum LogLevel {
    case DEBUG, INFO, ERROR, MARK;
    
    fileprivate func emotionLevel() -> String {
        var emotion = ""
        switch self {
        case .DEBUG:
            emotion =  "\u{0001F937} "
        case .INFO:
            emotion =  "\u{0001F446} "
        case .ERROR:
            emotion =  "\u{0001F621} "
        case .MARK:
            emotion =  "\u{0001F340} "
        }
        
        return emotion + "\(self)" + " ➯ "
    }
}

class Logger {
    static func debug(msg: Any, _ line: Int = #line, _ fileName: String = #file, _ funcName: String = #function, type: LogLevel = .DEBUG) {
        
        var fullLogMessage = type.emotionLevel()
        fullLogMessage += CommonHelper.getCurrentTime() + ": "
        fullLogMessage += URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent + " ➯ "
        fullLogMessage += funcName + ":"
        fullLogMessage += "\(line) ➯ "
        
        print(fullLogMessage, msg)
    }
    
    
    static func error(msg: Any, _ line: Int = #line, _ fileName: String = #file, _ funcName: String = #function) {
        debug(msg: msg as Any, line, fileName, funcName, type: .ERROR)
    }
    
    static func info(msg: Any, _ line: Int = #line, _ fileName: String = #file, _ funcName: String = #function) {
        debug(msg: msg as Any, line, fileName, funcName, type: .INFO)
    }
    
    static func mark(_ line: Int = #line, _ fileName: String = #file, _ funcName: String = #function) {
        debug(msg: "MARK", line, fileName, funcName, type: .MARK)
    }
}

