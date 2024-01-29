//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Dang Hung on 29/01/2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
