//
//  XMLParser.swift
//  WolframAlpha
//
//  Created by Roman Roibu on 8/29/15.
//  Copyright © 2015 Roman Roibu. All rights reserved.
//

import Foundation

public class XMLParser: NSObject {
    private var parser: NSXMLParser = NSXMLParser()
    private var error:  ErrorType? = nil
    private var root:   XMLMutableElementType? = nil
    private var stack: [XMLMutableElementType] = []

    func parse(data: NSData) throws -> XMLElementType {
        parser = NSXMLParser(data: data)
        parser.delegate = self

        if parser.parse() {
            if let root = self.root {
                return root
            } else {
                throw ParserError.NoRootXMLElement
            }
        } else {
            throw error ?? ParserError.FailedWithoutError
        }
    }
}

//MARK:- ParserError

extension XMLParser {
    public enum ParserError: ErrorType {
        /// Parsing the XML document didn't produce any XML elements
        case NoRootXMLElement
        /// Parsing the XML document failed, but didn't produce any errors
        case FailedWithoutError
    }
}

//MARK:- NSXMLParserDelegate

extension XMLParser: NSXMLParserDelegate {
    public func parserDidStartDocument(parser: NSXMLParser) {
        root = nil
        error = nil
        stack = []
    }

    public func parser(
        parser: NSXMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String])
    {
        let element = XMLElement(tag: elementName, qualifiedName: qName, attributes: attributeDict)
        stack.append(element)
    }

    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        let text = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        guard !text.isEmpty else { return }
        guard var element = stack.popLast() else { return }

        element.text = (element.text ?? "") + text
        stack.append(element)
    }

    public func parser(
        parser: NSXMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?)
    {
        if stack.count >= 2 && stack.last?.tag == elementName {
            let child  = stack.popLast()!
            var parent = stack.popLast()!
            parent.children.append(child)
            stack.append(parent)
        }
    }

    public func parserDidEndDocument(parser: NSXMLParser) {
        root = stack.first
    }

    public func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        error = validationError
    }

    public func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        error = parseError
    }
}



