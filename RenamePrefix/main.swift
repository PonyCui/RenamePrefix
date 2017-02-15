//
//  main.swift
//  RenamePrefix
//
//  Created by 崔明辉 on 2017/2/15.
//  Copyright © 2017年 UED Center. All rights reserved.
//

import Foundation

let env = ProcessInfo().environment["PWD"]!
let from = ProcessInfo().arguments[1]
let to = ProcessInfo().arguments[2]

if let enumerator = FileManager.default.enumerator(atPath: env) {
    for file in enumerator {
        if let file = file as? String, (file.hasSuffix(".h") || file.hasSuffix(".m") || file.hasSuffix(".pbxproj")) {
            let file = env + "/" + file
            do {
                let contents = try String(contentsOfFile: file)
                let newContents = contents.replacingOccurrences(of: from, with: to).replacingOccurrences(of: from.lowercased() + "_", with: to.lowercased() + "_")
                let fileName = URL(fileURLWithPath: file).lastPathComponent
                if fileName.hasPrefix(from) {
                    try FileManager.default.removeItem(atPath: file)
                    try newContents.write(toFile: file.replacingOccurrences(of: from, with: to),
                                          atomically: true,
                                          encoding: String.Encoding.utf8)
                }
                if fileName.contains("+" + from) {
                    try FileManager.default.removeItem(atPath: file)
                    try newContents.write(toFile: file.replacingOccurrences(of: "+" + from, with: "+" + to),
                                          atomically: true,
                                          encoding: String.Encoding.utf8)
                }
                else {
                    try newContents.write(toFile: file, atomically: true, encoding: String.Encoding.utf8)
                }
            }
            catch {
                continue
            }
        }
    }
}


