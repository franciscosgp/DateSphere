//
//  String+.swift
//  DateSphere
//

// MARK: - [Extension] String

extension String {

    // MARK: Initializers

    init?(key: [UInt8]?) {
        guard let key = key, !key.isEmpty else { return nil }
        let cipher = [UInt8](Constants.Security.salt.utf8)
        let length = cipher.count
        var decrypted: [UInt8] = []
        for k in key.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }
        guard let result = String(bytes: decrypted, encoding: .utf8) else { return nil }
        self = result
    }

}
