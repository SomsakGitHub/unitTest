import Foundation
import Combine

protocol NetworkSession: AnyObject {
    func publisher(for  request: URLRequest) -> AnyPublisher<Data, Error>
}

final class MockNetworkSession: NetworkSession {
    var shouldAuthorizeStub: Bool?
    
    func publisher(for request: URLRequest) -> AnyPublisher<Data, Error> {
        #if DEBUG
        
        let statusCode: Int
        let data: Data
        
        switch request.url?.absoluteString {
        case "nothttps://netguru.com/api/authMeInPlease":
            let path: String?
            let shouldAuthorizeValue = shouldAuthorizeStub ?? Bool.random()
            
            switch shouldAuthorizeValue {
            case true:
                path = Bundle.main.path(forResource: "AuthService+positiveResponse", ofType: "json")
            case false:
                path = Bundle.main.path(forResource: "AuthService+negativeResponse", ofType: "json")
            }
            data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)

            statusCode = 200
        case _:
            data = """
            {
              "errors": ["invalid_request"]
            }
            """.data(using: .utf8)!
            statusCode = 500
        }
        
        let response
            = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        return Deferred {
            Future { promise in
                DispatchQueue.global().asyncAfter(deadline: .now(), execute: {
                    promise(.success((data: data, response: response)))
                })
            }
        }
        .setFailureType(to: URLError.self)
        .tryMap({ result in
            guard result.response.statusCode >= 200 && result.response.statusCode < 300 else {
                let error = try JSONDecoder().decode(DefaultAuthService.ServiceError.self, from: result.data)
                throw error
            }
            return result.data
        })
        .eraseToAnyPublisher()
        
        #else
        
        fatalError("\(String(describing: self)) cannot be used on production")
        
        #endif
    }
}
