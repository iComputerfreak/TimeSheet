// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation

func setupTesting() {
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.currency)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.wage)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.workTimes)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.payouts)

    // Don't show the "Generate Sample Data" button in the settings view to not interfere with the snapshot tests
    UserDefaults.standard.set(true, forKey: UserDefaultsKey.shouldHideGenerateSampleDataButton)

    let context = DependencyContext.current
    context.reset()
    context.register(Config.self) { Config() }
    context.register(UserData.self) { MockUserData() }
}
