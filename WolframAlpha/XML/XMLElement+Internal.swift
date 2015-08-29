//
//  XMLElementTypeInternal.swift
//  WolframAlpha
//
//  Created by Roman Roibu on 8/29/15.
//  Copyright © 2015 Roman Roibu. All rights reserved.
//

import Foundation

internal protocol XMLMutableElementType: XMLElementType {
    var text: String? { get set }
    var children:   [XMLElementType] { get set }
    var attributes: [String: String] { get set }
}

internal protocol XMLInternalElementType: XMLMutableElementType {}

extension XMLElement: XMLInternalElementType {}

