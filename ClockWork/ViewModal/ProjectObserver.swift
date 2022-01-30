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
    
    @Published var projects : [Project] = []
    @Published var savedProject : Project?
    @Published var issues : [Issue] = []
    @Published var isLoaded = false
    
    private var ref = Database.database().reference().child("groups")
    private var newProjectHandle: UInt = 0
    private var updateHandle: UInt = 0
    
    private func loadAllProjects( onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void) {
        
        ref.getData(completion: { error, snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                onError("Snapshot Error")
                return
            }
            self.projects = children.compactMap { snapshot in
                guard let project = Project(snapshot: snapshot) else {
                    onError("not worked")
                    print ()
                    return nil
                }
                return project
            }
            if !self.projects.isEmpty {
                if let savedID = UserDefaults.standard.string(forKey: "savedProjectId") {
                    if let loadedProject = self.projects.first(where:{ $0.id == savedID }) {
                        print("savedProject found")
                        self.savedProject = loadedProject
                        onSuccess()
                        self.isLoaded = true
                    } else {
                        print("no saved Project found")
                        self.savedProject = self.projects[0]
                        UserDefaults.standard.set(self.savedProject?.id,forKey: "savedProjectId")
                        onSuccess()
                        self.isLoaded = true
                    }
                }
                else {
                    print("nosavedProject")
                    self.savedProject = self.projects[0]
                    UserDefaults.standard.set(self.savedProject?.id,forKey: "savedProjectId")
                    onSuccess()
                    self.isLoaded = true
                }
            }
            else {
                print("Empty")
                onSuccess()
                self.isLoaded = true
            }
        })
    }
    private func observeAddandUpdate() {
        self.newProjectHandle = self.ref.observe(.childAdded, with: { snapshot in
                print("Project load")
                if let project = Project(snapshot: snapshot) {
                    //replace old data
                    if let index = self.projects.firstIndex(where: { $0.id ==  project.id}) {
                        self.projects[index] = project
                    }
                    // if not exist
                    else if !self.projects.contains(project) {
                        self.projects.append(project)
                        
                    }
                    else {
                        print("contains")
                    }
                    self.projects.sort{$0.name.localizedCompare($1.name) == .orderedAscending}
                }
            })
            print("aus cildAdded draußen")
        self.updateHandle = self.ref.observe(.childChanged, with: { snapshot in
            print("update")
                if let project = Project(snapshot: snapshot) {
                    if let index = self.projects.firstIndex(where: { $0.id == project.id }) {
                        self.projects[index] = project
                        if project.id == self.savedProject?.id{
                            self.savedProject = project
                        }
                        self.projects.sort{$0.name.localizedCompare($1.name) == .orderedAscending}
                    }
                }
               
            })
    }
    func observeProjects(groupID: String){
        if !groupID.isEmpty {
        ref = Database.database().reference().child("groups/\(groupID)/projects")
        loadAllProjects(onSuccess: {
                print(#line,"Observe issues")
            self.observeAddandUpdate()
        }, onError: {errorMessage in
            print(errorMessage)
        })
        }
        else {
            print("no groupID")
        }

    }

    func unlistenIssue() {
            print("removeIssueListener")
            ref.removeObserver(withHandle: updateHandle)
            ref.removeObserver(withHandle: newProjectHandle)
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
