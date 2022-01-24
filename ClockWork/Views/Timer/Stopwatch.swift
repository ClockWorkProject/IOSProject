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
    
    static let shared = Stopwatch()
    
    @Published var message = "Not running"
    @Published var isRunning: Bool? { didSet { saveIsRunning() } }
    @Published var issue: Issue? { didSet { saveRunningIssue() } }
    @Published var project: Project? { didSet { saveRunningProject() } }

    /// Time that we're counting from
    private var startTime: Date? { didSet { saveStartTime() } }

    private var timer: AnyCancellable?
    
    init() {
        isRunning = fetchIsRunning()
        issue = fetchRunningIssue()
        project = fetchRunningProject()
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
        FirebaseRepo.addTime(groupID: GroupObserver.shared.groupID, startDate: startTime!, time: Date().timeIntervalSince(startTime!), issue: issue!, project: project!, onSuccess: {print("Sucess")}, onError: { errorMessage in print(errorMessage)})
        timer?.cancel()
        timer = nil
        startTime = nil
        isRunning = false
        project = nil
        issue = nil
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
    func saveRunningProject() {
        if let project = project {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(project) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "SavedProject")
            }
        }
    }
    func saveRunningIssue() {
        if let issue = issue {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(issue) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "SavedIssue")
            }
        }
    }
    func fetchRunningIssue() -> Issue?{
        if let savedIssue = UserDefaults.standard.object(forKey: "SavedIssue") as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(Issue.self, from: savedIssue)
        }
        else {
            return nil
        }
    }
    func fetchRunningProject() -> Project?{
        if let savedProject = UserDefaults.standard.object(forKey: "SavedProject") as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(Project.self, from: savedProject)
        }
        else {
            return nil
        }
    }
    func saveIsRunning() {
        UserDefaults.standard.set(isRunning, forKey: "timerIsRunning")
    }
    func fetchIsRunning() -> Bool {
        return UserDefaults.standard.bool(forKey: "timerIsRunning")
    }
    func fetchStartTime() -> Date? {
        UserDefaults.standard.object(forKey: "startTime") as? Date
    }
    func secondsToHoursMinutesSeconds(_ seconds: Double) -> (Int, Int, Int) {
        return (Int(seconds) / 3600, (Int(seconds) % 3600) / 60, (Int(seconds) % 3600) % 60)
    }
}
