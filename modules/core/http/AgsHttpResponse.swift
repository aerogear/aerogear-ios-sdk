import Foundation

/**
    Structure returned as response to http request.
    Represents data or error that was returned from request
*/
public struct AgsHttpResponse {
    /**
     Contains response body if no error is thrown
    */
    public let response: Any?

    /**
     Contains error if request failed
    */
    public let error: Error?

    /**
     Contains status code (could be empty if device is offline)
    */
    public let statusCode: Int?

    public init(response: Any? = nil,
                error: Error? = nil,
                statusCode: Int? = nil) {
        self.response = response
        self.error = error
        self.statusCode = statusCode
    }
}
