//
//  ResultType.swift
//  WolframAlpha
//
//  Created by Roman Roibu on 8/29/15.
//  Copyright © 2015 Roman Roibu. All rights reserved.
//

import Foundation

public enum Result<SuccessType> {
    case Success(SuccessType)
    case Failure(ErrorType)

    public var value: SuccessType? {
        switch self {
        case Success(let value): return value
        case Failure(_): return nil
        }
    }

    public var error: ErrorType? {
        switch self {
        case Failure(let error): return error
        case Success(_): return nil
        }
    }
}

