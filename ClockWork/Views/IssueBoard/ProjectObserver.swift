//
//  ProjectObserver.swift
//  ClockWork
//
//  Created by Mattis on 20.01.22.
//

import Foundation
import FirebaseDatabaseSwift
import Firebase

final class ProjectObserver: ObservableObject {
    
    static let shared = ProjectObserver()
    
    let groupDB = Database.database().reference().child("groups")
    private let groupID = GroupObserver.shared.groupID
    
    @Published var projects : [Project] = []
    @Published var savedProject : Project?
    @Published var issues: [Issue] = []
    @Published var isLoaded = false
    
    func projectListener() {
        let ref = Database.database().reference().child("groups/\(groupID)/projects")
        ref.observeSingleEvent(of: .value, with: { [self] (snapshot) in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                print ("error")
                return
            }
            self.projects = children.compactMap { snapshot in
                print(snapshot)
                let project = try! snapshot.data(as: Project.self)
//                    print ("not worked")
//                    return nil
//                }
                return project
            }
            if !self.projects.isEmpty {
                if let savedID = UserDefaults.standard.string(forKey: "savedProjectId") {
                    if let loadedProject = self.projects.first(where:{ $0.id == savedID }) {
                        print("savedProject found")
                        self.savedProject = loadedProject
                        self.isLoaded = true
                    } else {
                        print("no saved Project found")
                        self.savedProject = self.projects[0]
                        UserDefaults.standard.set(self.savedProject?.id,forKey: "savedProjectId")
                        self.isLoaded = true
                    }
                }
                else {
                    print("nosavedProject")
                    self.savedProject = self.projects[0]
                    UserDefaults.standard.set(self.savedProject?.id,forKey: "savedProjectId")
                    self.isLoaded = true
                }
            }
            else {
                isLoaded = true
            }
        })
    }
    
    func observeIssues() -> (UInt, UInt){
        if !groupID.isEmpty, let savedProject = self.savedProject {
            print("Observe issues")
            let handle = groupDB.child("\(groupID)/projects/\(savedProject.id)/issues").observe(.childAdded, with: { snapshot in
                    if let issue = try? snapshot.data(as: Issue.self) {
                        //replace old data
                        if let index = self.issues.firstIndex(where: { $0.id == issue.id }) {
                            self.issues[index] = issue
                        }
                        // if not exist
                        else if !self.issues.contains(issue) {
                            self.issues.append(issue)
                        }
                    }
            })
            let updateHandler = groupDB.child("\(groupID)/projects/\(savedProject.id)/issues").observe(.childChanged, with: { snapshot in
                if let issue = try? snapshot.data(as: Issue.self) {
                    if let index = self.issues.firstIndex(where: { $0.id == issue.id }) {
                        self.issues[index] = issue
                    }
                }
            })
            return (handle, updateHandler)
        }
        else {
            return(0,0)
        }
    }
    
    func unlistenIssue(handle: (UInt, UInt)) {
        if !groupID.isEmpty, let savedProject = self.savedProject {
            print("removeIssueListener")
            groupDB.child("\(groupID)/projects/\(savedProject.id)/issues").removeObserver(withHandle: handle.0)
            groupDB.child("\(groupID)/projects/\(savedProject.id)/issues").removeObserver(withHandle: handle.1)
        }
    }
    
    
    
    private func indexOfMessage(snapshot: DataSnapshot) -> Int {
        var index = 0
        for  project in self.projects {
          if (snapshot.key == project.id) {
            return index
          }
          index += 1
        }
        return -1
      }
}
