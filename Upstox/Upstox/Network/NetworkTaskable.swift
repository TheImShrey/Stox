//
//  NetworkTaskable.swift
//  Upstox
//
//  Created by Shreyash Shah on 25/05/24.
//

import Foundation

protocol NetworkTaskable {
    func cancel()
    func resume()
}

extension URLSessionDataTask: NetworkTaskable {}
extension URLSessionDownloadTask: NetworkTaskable {}

/// A no-op task that does nothing when called. Used in cases like when cache was hit and no network call was made.
struct NoopTask {}

extension NoopTask: NetworkTaskable {
    func cancel() {}
    func resume() {}
}
