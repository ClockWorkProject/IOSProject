//
//  Timer.swift
//  ClockWork
//
//  Created by Mattis on 29.12.21.
//https://stackoverflow.com/questions/63765532/swiftui-how-to-run-a-timer-in-background

import Foundation
import SwiftUI
import Combine

class Stopwatch: ObservableObject {
    /// String to show in UI
    @Published private(set) var message = "Not running"

    /// Is the timer running?
    @Published private(set) var isRunning = false

    /// Time that we're counting from
    private var startTime: Date?                        { didSet { saveStartTime() } }

    /// The timer
    private var timer: AnyCancellable?

    init() {
        startTime = fetchStartTime()

        if startTime != nil {
            start()
        }
    }
}

// MARK: - Public Interface

extension Stopwatch {
    func start() {
        timer?.cancel()               // cancel timer if any

        if startTime == nil {
            startTime = Date()
        }

        message = ""

        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let startTime = self.startTime
                else { return }

                let now = Date()
                let elapsed = now.timeIntervalSince(startTime)

                let (h, m, s) = self.secondsToHoursMinutesSeconds(elapsed)
                self.message = String(format: "%02d:%02d:%02d", h, m, s)
            }

        isRunning = true
    }

    func stop() {
        timer?.cancel()
        timer = nil
        startTime = nil
        isRunning = false
        message = "Not running"
    }
}

// MARK: - Private implementation

private extension Stopwatch {
    func saveStartTime() {
        if let startTime = startTime {
            UserDefaults.standard.set(startTime, forKey: "startTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
    }

    func fetchStartTime() -> Date? {
        UserDefaults.standard.object(forKey: "startTime") as? Date
    }
    func secondsToHoursMinutesSeconds(_ seconds: Double) -> (Int, Int, Int) {
        return (Int(seconds) / 3600, (Int(seconds) % 3600) / 60, (Int(seconds) % 3600) % 60)
    }
}
