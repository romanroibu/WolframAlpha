//
//  XMLElement.swift
//  WolframAlpha
//
//  Created by Roman Roibu on 8/29/15.
//  Copyright © 2015 Roman Roibu. All rights reserved.
//

import Foundation

public protocol SubscriptableType {
    subscript(key: String) -> String? { get }
}

public protocol XMLElementType: SubscriptableType {
    var tag:  String  { get }
    var text: String? { get }
    var attributes: [String: String] { get }
    var children:   [XMLElementType] { get }
}

extension XMLElementType {
    public subscript(key: String) -> String? {
        return attributes[key]
    }
}

public struct XMLElement: XMLElementType {
    public let tag: String
    public let qualifiedName: String?
    public internal(set) var text: String?
    public internal(set) var children: [XMLElementType]
    public internal(set) var attributes: [String: String]
    
    public init(tag: String, qualifiedName: String?=nil, attributes: [String: String], text: String?=nil, children: [XMLElementType]=[]) {
        self.tag  = tag
        self.text = text
        self.qualifiedName = qualifiedName
        self.attributes = attributes
        self.children = children
    }
}


