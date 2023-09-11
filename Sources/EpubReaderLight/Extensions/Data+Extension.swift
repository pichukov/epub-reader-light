import Foundation

// TODO: Delete it later
extension Data {

    var jsonString: String? {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(
                with: self,
                options: []
            ),
            let data = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted]),
            let prettyJSON = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
            )
        else {
            return nil
        }

        return String(prettyJSON)
    }
}
