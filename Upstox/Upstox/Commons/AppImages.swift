//
//  AppIcons.swift
//  Upstox
//
//  Created by Shreyash Shah on 22/05/24.
//

import UIKit

enum AppImages: String {
    case refresh = "arrow.triangle.2.circlepath.circle.fill"
    
    var image: UIImage {
        guard let icon = UIImage(systemName: self.rawValue) else {
            assertionFailure("Failed to load refresh icon, this is not expected, Check if the SFSymbol name is valid.")
            return UIImage()
        }
        
        return icon
    }
}
