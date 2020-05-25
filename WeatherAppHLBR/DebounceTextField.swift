//
//  DebounceTextField.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 24/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import Foundation

class DebounceTextField {
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    typealias Handler = () -> Void
    var handler: Handler?

    private let timeInterval: TimeInterval

    private var timer: Timer?

    func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] timer in
            self?.handleTimer(timer)
        })
    }
    private func handleTimer(_ timer: Timer) {
        guard timer.isValid else {
            return
        }
        handler?()
        handler = nil
    }
}
