//
//  TagManager.swift
//  Stack
//
//  Created by Jacobs, Joe on 7/9/26.
//

import Foundation
import Gzip
import OSLog
import Forge

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

@Observable
class TagManager {
    
    private let client: ForgeClient = .shared
    private let session = URLSession.shared
    private let fm = FileManager.default
    
    var tags: [SFTag] = [] {
        didSet {
            rebuildTagIndex()
        }
    }
    
    var tagsFile: URL {
        let documentsURL = fm.getDocumentsDirectory()
        return documentsURL.appendingPathComponent("oracle-tags.jsonl")
    }
    
    private(set) var tagsByOracleID: [String: [SFTag]] = [:]
    
    private func rebuildTagIndex() {
        var tempDict: [String: [SFTag]] = [:]
        
        for tag in tags {
            for tagging in tag.taggings {
                if let oracleID = tagging.oracleID {
                    tempDict[oracleID, default: [] ].append(tag)
                }
            }
        }
        
        self.tagsByOracleID = tempDict
    }
    
    func getLatestTags() async {
        do {
            // Check if tag file exists and if it's up-to-date
            if fm.fileExists(atPath: tagsFile.path),
               let fileLastModified = checkFileModificationDate(at: tagsFile),
               Date().timeIntervalSince(fileLastModified) < 86400 {
                
                debugLog.info("Tag file exists and is up-to-date, decoding from there...")
                try decodeJSONData(at: tagsFile)
                return
            }
            
            debugLog.info("Tag file is missing or out-of-date, updating...")
            
            // Grab latest tag file URL from Scryfall
            guard let tagsURLResponse = try? await client.fetchBulkDataURLByType(for: "oracle-tags"),
                  let tagsURL = URL(string: tagsURLResponse.jsonlDOwnloadURI) else {
                return
            }
            
            // Download file from Scryfall
            let (tagsLocalURL, _) = try await session.download(from: tagsURL)
            
            // Decompress and decode
            if let tagJSONL = try decompressTagFile(at: tagsLocalURL) {
                try decodeJSONData(at: tagJSONL)
            }
        } catch {
            debugLog.error("Error while checking for latest tags:\(error.localizedDescription)")
        }
    }
        
    func decompressTagFile(at fileURL: URL) throws -> URL? {
        do {
            let compressedData = try Data(contentsOf: fileURL)
            guard compressedData.isGzipped else { return nil }
            let decompressedData = try compressedData.gunzipped()
            
            let documentsURL = fm.getDocumentsDirectory()
            let finalURL = documentsURL.appendingPathComponent("oracle-tags.jsonl")
            
            try decompressedData.write(to: finalURL)
            return finalURL
        } catch {
            throw error
        }
    }
    
    func decodeJSONData(at fileURL: URL) throws {
        
        let jsonlData = try Data(contentsOf: fileURL)
        guard let jsonlString = String(data: jsonlData, encoding: .utf8) else { return }
        let lines = jsonlString.components(separatedBy: .newlines)
        
        var tagResults: [SFTag] = []
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedLine.isEmpty else { continue }
            guard let lineData = trimmedLine.data(using: .utf8) else { continue }
            
            do {
                let response = try client.decode(data: lineData, as: SFTag.self)
                tagResults.append(response)
            } catch {
                print("Error: \(error)")
            }
        }
        
        self.tags = tagResults
    }
    
    func checkFileModificationDate(at fileURL: URL) -> Date? {
        do {
            let attributes = try fm.attributesOfItem(atPath: fileURL.path())
            return attributes[.modificationDate] as? Date
        } catch {
            print("Error reading file attributes: \(error.localizedDescription)")
            return nil
        }
    }
    
}
