//
//  Configurations.swift
//  AeroGearSdkExampleTests
//

import AGSCore
import Foundation

func getMockKeycloakConfig() -> MobileService {
    let mobileServiceData =
        """
        {
          "id": "keycloak",
          "name": "keycloak",
          "type": "keycloak",
          "url": "https://keycloak-myproject.192.168.64.74.nip.io/auth",
          "config": {
            "auth-server-url": "https://keycloak-myproject.192.168.64.74.nip.io/auth",
            "clientId": "juYAlRlhTyYYmOyszFa",
            "realm": "myproject",
            "resource": "juYAlRlhTyYYmOyszFa",
            "ssl-required": "external",
            "url": "https://keycloak-myproject.192.168.64.74.nip.io/auth"
          }
        }
        """.data(using: .utf8)!
    return try! JSONDecoder().decode(MobileService.self, from: mobileServiceData)
}
