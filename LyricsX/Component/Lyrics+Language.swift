//
//  Lyrics+Language.swift
//  LyricsX - https://github.com/ddddxxx/LyricsX
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import LyricsCore

private extension NSCountedSet {
    
    var mostFrequentElement: Any? {
        var result: (Any?, Int) = (nil, 0)
        for element in self {
            let count = self.count(for: element)
            if count > result.1 {
                result = (element, count)
            }
        }
        return result.0
    }
}

extension Lyrics {
    
    func recognizeLanguage() {
        var lyricsContent = ""
        var translationContent = ""
        for line in self {
            lyricsContent += line.content
            if let trans = line.attachments.translation() {
                translationContent += trans
            }
        }
        metadata.language = (lyricsContent as NSString).dominantLanguage
        if let transLan = (translationContent as NSString).dominantLanguage {
            let tag = LyricsLine.Attachments.Tag.translation(languageCode: transLan)
            guard !metadata.attachmentTags.contains(tag) else {
                return
            }
            for idx in indices {
                if let trans = self[idx].attachments.translation() {
                    self[idx].attachments[.translation()] = nil
                    self[idx].attachments[.translation(languageCode: transLan)] = trans
                }
            }
            metadata.attachmentTags.insert(tag)
        }
    }
}
