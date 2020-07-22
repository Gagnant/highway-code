//
//  AppDelegate.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let controller = UITabBarController()
        controller.viewControllers = [
            CamerasBuilder.build()
        ]
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.tintColor = #colorLiteral(red: 0.9490196078, green: 0.1058823529, blue: 0.3176470588, alpha: 1)
        return window
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Core.configure()
        window?.makeKeyAndVisible()

        let string = #"{ "id": 173313, "type": 1, "series": "1АВ", "num": "00170106", "violationDate": "2020-06-01T19:31:42+03:00", "resolutionDate": "2020-06-13T09:59:00+03:00", "latitude": 50.568831758999998, "longitude": 30.098156944999999, "vehicleMake": 201000, "vehicleBrand": "FORD", "vehicleModel": "FOCUS", "vehiclePlate": "АМ7266СЕ", "violationText": "Особа, яка керувала транспортним засобом, перевищила встановлені обмеження швидкості руху транспортних засобів на 34 км/год, чим порушила пункт 12.9.(б) Правил дорожнього руху України", "points": 0, "amount": 25500, "payAmount": 25500, "isPaid": false, "url": null, "urlAccessCode": "S7PszpNfE9h", "dateDelivered": null, "payState": 3, "payStateDaysLeft": null, "media": [{ "type": 1, "pos": "body", "url": "https://vfx-api.mvs.gov.ua/user/media/2020-07-22-01/173313/7c20a02090188f95d0bfc5abd399b246.jpeg" }, { "type": 1, "pos": "close", "url": "https://vfx-api.mvs.gov.ua/user/media/2020-07-22-01/173313/e512b33fddd99094436e0ef8abc9c2d7.jpeg" }, { "type": 1, "pos": "far", "url": "https://vfx-api.mvs.gov.ua/user/media/2020-07-22-01/173313/cdb52d83f73c6421c52263007f8154d6.jpeg" }, { "type": 1, "pos": "plate", "url": "https://vfx-api.mvs.gov.ua/user/media/2020-07-22-01/173313/52cd130efcc22fce834a44030bc38c79.jpeg" }, { "type": 1, "pos": "thumb", "url": "https://vfx-api.mvs.gov.ua/user/media/2020-07-22-01/173313/bf8590ecdada09c51a83b7144d5dfaf5.jpeg" }, { "type": 2, "pos": "video", "url": "https://vfx-api.mvs.gov.ua/user/media/2020-07-22-01/173313/f961dde19ff9e16b6b68bc660f37c4a3.mp4" } ] }"#
        let data = Data(string.utf8)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        print(try? decoder.decode(Resolution.self, from: data))

        return true
    }

}



