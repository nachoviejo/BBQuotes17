//
//  StringExt.swift
//  BBQuotes17
//
//  Created by Kinamic Kinamic on 05/11/2024.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpace() -> String {
        self.removeSpaces().lowercased()
    }
}
