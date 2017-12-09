//
//  Response.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation


public enum ResponseError: Error {
    case cancelled
    case invalidStatusCode(Int)
    case invalidContentType(String)
}

public class Response: NSObject {

    public struct Result {

        public var urlResponse: URLResponse?
        public var location: URL?
        public var data: Data?

        public init(urlResponse: URLResponse?, location: URL? = nil, data: Data? = nil) {
            self.urlResponse = urlResponse
            self.location = location
            self.data = data
        }
    }

    private typealias ValidationBlock = (Result?, Error?, ErrorBlock?) -> Void

    var session: URLSession
    var request: URLRequest
    var task: URLSessionTask?

    var result: Result?
    var error: Error?

    #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)

    var startTime: CFAbsoluteTime?
    var endTime: CFAbsoluteTime?

    var progress: Progress?
    var progressHandler: ((Progress) -> Void)?

    #endif

    private var validations: [ValidationBlock] = []

    private var fulfill: ((Result) -> Void)?
    private var reject: ErrorBlock?

    public init(session: URLSession, request: URLRequest, task: Request.Task) {

        self.request = request
        self.session = session

        switch task {
        case .data:
            self.task = self.session.dataTask(with: self.request)
        case .download:
            self.task = self.session.downloadTask(with: self.request)
        case .upload:
            // swiftlint:disable:next force_unwrapping
            self.task = self.session.uploadTask(with: self.request, from: self.request.httpBody!)
        case .stream:
            guard let url = self.request.url, let host = url.host, let port = url.port else {
                break
            }
            #if os(iOS) || os(tvOS) || os(macOS)
                self.task = self.session.streamTask(withHostName: host, port: port)
            #endif
        }
        super.init()
    }

    func complete() {
        if let error = self.error {
            self.reject?(error)
            return
        }

        self.validations.forEach { block in block(self.result, self.error, self.reject) }
        // swiftlint:disable:next force_unwrapping
        self.fulfill?(self.result!)
    }
    #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
    public func progress(_ report: @escaping ((Progress) -> Void)) -> Response {
        self.progressHandler = report
        return self
    }
    #endif

}

public extension Response {

    private struct MIMEType {

        let type: String
        let subtype: String

        var isWildcard: Bool {
            return self.type == "*" && self.subtype == "*"
        }

        init?(_ string: String) {
            let stripped = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let index = stripped.range(of: ";")?.lowerBound ?? stripped.endIndex
            let split = String(stripped[..<index])
            let components = split.components(separatedBy: "/")

            guard let type = components.first, let subtype = components.last else {
                return nil
            }

            self.type = type
            self.subtype = subtype
        }

        func matches(_ mime: MIMEType) -> Bool {
            switch (self.type, self.subtype) {
            case (mime.type, mime.subtype), (mime.type, "*"), ("*", mime.subtype), ("*", "*"):
                return true
            default:
                return false
            }
        }
    }
    // swiftlint:disable:next line_length
    public func validate<S: Sequence>(statusCode acceptableStatusCodes: S) -> Response where S.Iterator.Element == Int {
        self.validations.append { result, _, reject in
            guard let httpResponse = result?.urlResponse as? HTTPURLResponse else {
                return
            }
            guard !acceptableStatusCodes.contains(httpResponse.statusCode) else {
                return
            }

            reject?(ResponseError.invalidStatusCode(httpResponse.statusCode))
        }
        return self
    }

    public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Response
        where S.Iterator.Element == String {
            self.validations.append { result, _, reject in
                guard let httpResponse = result?.urlResponse as? HTTPURLResponse else {
                    return
                }

                guard let mimeType = httpResponse.mimeType, let mime = MIMEType(mimeType) else {
                    for contentType in acceptableContentTypes {
                        if let mimeType = MIMEType(contentType), mimeType.isWildcard {
                            return
                        }
                    }

                    reject?(ResponseError.invalidContentType(httpResponse.mimeType ?? "unknown"))
                    return
                }

                for contentType in acceptableContentTypes {
                    if let acceptableMIMEType = MIMEType(contentType), acceptableMIMEType.matches(mime) {
                        return
                    }
                }

                reject?(ResponseError.invalidContentType(mimeType))
            }
            return self
    }

    private var acceptableStatusCodes: [Int] {
        return Array(200..<300)
    }

    private var acceptableContentTypes: [String] {
        if let accept = self.request.value(forHTTPHeaderField: "Accept") {
            return accept.components(separatedBy: ",")
        }

        return ["*/*"]
    }

    public func validate() -> Response {
        return self.validate(statusCode: self.acceptableStatusCodes)
            .validate(contentType: self.acceptableContentTypes)
    }

}

extension Response {

    public func start() -> Promise<Result> {
        self.task?.resume()

        return Promise<Result> { [weak self] fulfill, reject in
            self?.fulfill = fulfill
            self?.reject = reject
        }
    }

    public func resume(_ data: Data? = nil) -> Promise<Result> {
        if let resumeData = data, self.task is URLSessionDownloadTask {
            self.task = self.session.downloadTask(withResumeData: resumeData)
        }
        return self.start()
    }

    public func cancel(byProducingResumeData block: ValueBlock<Data?>? = nil) {
        defer {
            self.reject?(ResponseError.cancelled)
        }

        #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
            if let task = self.task as? URLSessionDownloadTask {
                return task.cancel { data in
                    block?(data)
                }
            }
        #endif
        self.task?.cancel()
        block?(nil)
    }

}
