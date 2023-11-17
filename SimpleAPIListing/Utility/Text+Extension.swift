//
//  Text+Extension.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import SwiftUI

public func DesignText(_ string: String,
                    style: Font.CustomTextStyle,
                    overrideForegroundColor: Color? = nil) -> Text {
    Text(string)
        .font(style: style)
        .foregroundColor(overrideForegroundColor ?? .primary)
}

extension Text {
    func font(style: Font.CustomTextStyle) -> Text {
        font(.custom(style.font.fontName,
                    size: style.size))
    }
}
