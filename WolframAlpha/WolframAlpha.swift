//
//  WolframAlpha.swift
//  WolframAlpha
//
//  Created by Roman Roibu on 8/29/15.
//  Copyright © 2015 Roman Roibu. All rights reserved.
//

import Foundation

public typealias DataCallbackType   = Result<NSData>         -> Void
public typealias XMLCallbackType    = Result<XMLElementType> -> Void
//public typealias ResultCallbackType = Result<QueryResult>    -> Void

public class WolframAlpha {

    private let appID: String

    private let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()

    public init(appID: String) {
        self.appID = appID
    }

    public func queryData(query: String, dataCallback: DataCallbackType) -> QueryBuilder {
        let builder = QueryBuilder(query: query, appID: self.appID)
        return self.queryData(builder, dataCallback: dataCallback)
    }

    public func queryData(builder: QueryBuilder, dataCallback: DataCallbackType) -> QueryBuilder {
        let url = builder.build()
        let task = self.session.dataTaskWithURL(url) { data, response, error in
            if let data = data {
                dataCallback(.Success(data))
            } else {
                dataCallback(.Failure(error!))
            }
        }
        task.resume()
        return builder
    }

    public func queryXML(query: String, xmlCallback: XMLCallbackType) -> QueryBuilder {
        let builder = QueryBuilder(query: query, appID: self.appID)
        return self.queryXML(builder, xmlCallback: xmlCallback)
    }

    public func queryXML(builder: QueryBuilder, xmlCallback: XMLCallbackType) -> QueryBuilder {
        return self.queryData(builder) { dataResult in
            if let data = dataResult.value {
                let backgroundQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

                dispatch_async(backgroundQ) {
                    var arg: Result<XMLElementType>
                    let parser = XMLParser()
                    do {
                        let xml = try parser.parse(data)
                        arg = .Success(xml)
                    } catch let error {
                        arg = .Failure(error)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        xmlCallback(arg)
                    }
                }
            } else {
                //If no data, propagate the error to the xml callback
                xmlCallback(.Failure(dataResult.error!))
            }
        }
    }
}

