//
//  Fonts+Extension.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import SwiftUI

public extension Font {
    struct CustomTextStyle: Hashable {

        public struct Font: Hashable {
            let fontName: String
            let fontExtension: String
        }

        let font: Font
        let size: CGFloat

        private init(font: Font, size: CGFloat) {
            self.font = .init(fontName: font.fontName, fontExtension: font.fontExtension)
            self.size = size
        }

        public static var titleBold = CustomTextStyle(font: .init(fontName: "HelveticaNeue", fontExtension: "Bold"), size: 24)
        public static var titleRegular = CustomTextStyle(font: .init(fontName: "HelveticaNeue", fontExtension: "Medium"), size: 24)

        public static var subtitleBold = CustomTextStyle(font: .init(fontName: "HelveticaNeue", fontExtension: "Bold"), size: 16)
        public static var subtitleRegular = CustomTextStyle(font: .init(fontName: "HelveticaNeue", fontExtension: "Medium"), size: 16)


        public static var bodyBold = CustomTextStyle(font: .init(fontName: "HelveticaNeue", fontExtension: "Bold"), size: 12)
        public static var bodyRegular = CustomTextStyle(font: .init(fontName: "HelveticaNeue", fontExtension: "Medium"), size: 12)
    }
}
