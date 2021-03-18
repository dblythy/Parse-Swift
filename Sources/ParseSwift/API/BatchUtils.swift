//
//  RESTBatchCommand.swift
//  ParseSwift
//
//  Created by Florent Vilmart on 17-08-19.
//  Copyright © 2020 Parse Community. All rights reserved.
//

import Foundation

typealias ParseObjectBatchCommand<T> = BatchCommand<T, T> where T: ParseObject
typealias ParseObjectBatchResponse<T> = [(Result<T, ParseError>)]
// swiftlint:disable line_length
typealias RESTBatchCommandType<T> = API.Command<ParseObjectBatchCommand<T>, ParseObjectBatchResponse<T>> where T: ParseObject

typealias ParseObjectBatchCommandNoBody<T> = BatchCommandNoBody<NoBody, NoBody>
typealias ParseObjectBatchResponseNoBody<NoBody> = [(Result<Void, ParseError>)]
typealias RESTBatchCommandNoBodyType<T> = API.NonParseBodyCommand<ParseObjectBatchCommandNoBody<T>, ParseObjectBatchResponseNoBody<T>> where T: Encodable

typealias ParseObjectBatchCommandEncodable<T> = BatchChildCommand<T, PointerType> where T: Encodable
typealias ParseObjectBatchResponseEncodable<U> = [(Result<PointerType, ParseError>)]
// swiftlint:disable line_length
typealias RESTBatchCommandTypeEncodable<T> = API.NonParseBodyCommand<ParseObjectBatchCommandEncodable<T>, ParseObjectBatchResponseEncodable<Encodable>> where T: Encodable
 // swiftlint:enable line_length

internal struct BatchCommand<T, U>: ParseType where T: ParseType {
    let requests: [API.Command<T, U>]
    var transaction: Bool
}

internal struct BatchCommandNoBody<T, U>: Encodable where T: Encodable {
    let requests: [API.NonParseBodyCommand<T, U>]
    var transaction: Bool
}

internal struct BatchChildCommand<T, U>: Encodable where T: Encodable {
    let requests: [API.BatchCommand<T, U>]
    var transaction: Bool
}

struct BatchUtils {
    static func splitArray<U>(_ array: [U], valuesPerSegment: Int) -> [[U]] {
        if array.count < valuesPerSegment {
            return [array]
        }

        var returnArray = [[U]]()
        var index = 0
        while index < array.count {
            let length = Swift.min(array.count - index, valuesPerSegment)
            let subArray = Array(array[index..<index+length])
            returnArray.append(subArray)
            index += length
        }
        return returnArray
    }
}
