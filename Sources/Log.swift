//
//  Log.swift
//  Monolingual
//
//  Created by Ingmar Stein on 14.07.14.
//
//

import Foundation

final class Log {

	// use the real (non-sandboxed) directory $HOME/Library/Logs for the log file as long as we have the temporary exception com.apple.security.temporary-exception.files.home-relative-path.read-write.
	// FileManager.homeDirectoryForCurrentUser points to $HOME/Library/Containers/com.github.IngmarStein.Monolingual/Data
	class var realHomeDirectory: String {
		if let pw = getpwuid(getuid()) {
			return String(cString: pw.pointee.pw_dir)
		} else {
			return FileManager.default.homeDirectoryForCurrentUser.path
		}
	}

	lazy var logFileURL: URL = {
		return URL(fileURLWithPath: "\(Log.realHomeDirectory)/Library/Logs/Monolingual.log", isDirectory: false)
	}()
	var logFile: OutputStream?

	func open() {
		logFile = OutputStream(url: logFileURL, append: true)
		logFile?.open()
	}

	func message(_ message: String) {
		let data = [UInt8](message.utf8)
		logFile?.write(data, maxLength: data.count)
	}

	func close() {
		logFile?.close()
		logFile = nil
	}

	deinit {
		close()
	}
}

let log = Log()
