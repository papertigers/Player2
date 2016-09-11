//
//  M3UParser.swift
//  TestTVApp
//
//  Created by Olivier Boucher on 2015-09-13.
// https://github.com/OlivierBoucher/StreamCenter/blob/master/StreamCenter/M3UParser.swift
//
// Modified by Michael Zeller <mike@mikezeller.net>

import Foundation

// TODO: Needs love
class M3UParser {
    
    static func parseToDict(_ data : String) -> [TwitchStreamVideo]? {
        let dataByLine = data.components(separatedBy: "\n")
        
        var resultArray = [TwitchStreamVideo]()
        
        if(dataByLine[0] == "#EXTM3U"){
            for i in 1 ..< dataByLine.count {
                if(dataByLine[i].hasPrefix("#EXT-X-STREAM-INF:PROGRAM-ID=1,")){
                    let line = dataByLine[i]
                    var codecs : String?
                    var quality : String?
                    var url : URL?
                    
                    if let codecsRange = line.range(of: "CODECS=\"") {
                        if let videoRange = line.range(of: "VIDEO=\"") {
                            codecs = line.substring(with: codecsRange.upperBound..<line.characters.index(line.endIndex, offsetBy: -2))
                            quality = line.substring(with: videoRange.upperBound..<line.characters.index(line.endIndex, offsetBy: -1))
                            
                            if(dataByLine[i+1].hasPrefix("http")){
                                url = URL(string: dataByLine[i+1].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                            }
                        }
                    }
                    
                    if(codecs != nil && quality != nil && url != nil){
                        resultArray.append(TwitchStreamVideo(quality: quality!, url: url!, codecs: codecs!))
                    }
                    
                }
            }
        }
        else {
           // Logger.Error("Data is not a valid M3U file")
        }
        
        return resultArray
    }
}
