//
//  QueryBuilder.swift
//  WolframAlpha
//
//  Created by Roman Roibu on 8/29/15.
//  Copyright © 2015 Roman Roibu. All rights reserved.
//

import Foundation

public struct QueryBuilder {
    private let _appID:         String
    private var _query:         String

    private var _async:         Bool = false
    private var _formats:       [String] = []
    private var _assumptions:   [String] = []
    private var _includePodIDs: [String] = []
    private var _excludePodIDs: [String] = []
    private var _scanners:      [String] = []

    private var baseUrl: NSURLComponents {
        return NSURLComponents(string: "http://api.wolframalpha.com/v2")!
    }

    public init(query: String, appID: String) {
        self._query = query
        self._appID = appID
    }

    mutating public func fromat(fmt: String) -> QueryBuilder {
        self._formats.append(fmt)
        return self
    }

    mutating public func async(async: Bool) -> QueryBuilder {
        self._async = async
        return self
    }

    mutating public func assumption(value: String) -> QueryBuilder {
        self._assumptions.append(value)
        return self
    }

    mutating public func includePod(ID: String) -> QueryBuilder {
        self._includePodIDs.append(ID)
        return self
    }

    mutating public func excludePod(ID: String) -> QueryBuilder {
        self._excludePodIDs.append(ID)
        return self
    }

    mutating public func scanner(scanner: String) -> QueryBuilder {
        self._scanners.append(scanner)
        return self
    }

    public func build() -> NSURL {
        //Create new URL components from base URL
        let queryUrl = self.baseUrl

        //Append "/query" to the base url query path
        queryUrl.path = (queryUrl.path ?? "") + "/query"

        // Collect query items by adding to existing ones
        var queryItems = queryUrl.queryItems ?? []

        //Add single value items
        queryItems.append( NSURLQueryItem(name: "appid", value: self._appID) )
        queryItems.append( NSURLQueryItem(name: "input", value: self._query) )
        queryItems.append( NSURLQueryItem(name: "async", value: self._async ? "true" : "false") )

        //Add array query items as multiple items with the same name
        queryItems += self._formats.map       { NSURLQueryItem(name: "format",       value: $0) }
        queryItems += self._assumptions.map   { NSURLQueryItem(name: "assumption",   value: $0) }
        queryItems += self._scanners.map      { NSURLQueryItem(name: "scanner",      value: $0) }
        queryItems += self._includePodIDs.map { NSURLQueryItem(name: "includepodid", value: $0) }
        queryItems += self._excludePodIDs.map { NSURLQueryItem(name: "excludepodid", value: $0) }

        // Set query items to components
        queryUrl.queryItems = queryItems

        //Build the query URL
        return queryUrl.URL!
    }
}



