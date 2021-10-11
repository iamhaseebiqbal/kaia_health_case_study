import Foundation

enum EndPoint: String {
    case exercises = "jsonBlob/027787de-c76e-11eb-ae0a-39a1b8479ec2"
    
    static let apiHost = "https://jsonblob.com/api/"
    
    var path: String {
        return EndPoint.apiHost + rawValue
    }
}
