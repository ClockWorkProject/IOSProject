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
    
    @Published var projects : [Project] = []
    @Published var savedProject : Project?
    @Published var issues : [Issue] = []
    @Published var isLoaded = false
    
    private var ref = Database.database().reference().child("groups")
    private var newProjectHandle: UInt = 0
    private var updateHandle: UInt = 0
    
    // lade Projects einmal um gespeichertes Projekt zu laden und überprüfen
    private func loadAllProjects( onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void) {
        //lade Projekte
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
            //Project ist nicht leer
            if !self.projects.isEmpty {
                // Wenn es ein gespeicherte ID gibt
                if let savedID = UserDefaults.standard.string(forKey: "savedProjectId") {
                    //Wenn gespeichertes Projekt vorhanden
                    if let loadedProject = self.projects.first(where:{ $0.id == savedID }) {
                        print("savedProject found")
                        self.savedProject = loadedProject
                        onSuccess()
                        self.isLoaded = true
                    } else {
                        // Wenn es  gespeichertes Projekt nicht mehr vorhanden ist, setzt erstes Projekt als gespeichertes Projekt
                        print("no saved Project found")
                        self.savedProject = self.projects[0]
                        UserDefaults.standard.set(self.savedProject?.id,forKey: "savedProjectId")
                        onSuccess()
                        self.isLoaded = true
                    }
                }// kein gespeichertes Projekt setzt erstes Projekt als gespeichertes Projekt
                else {
                    print("nosavedProject")
                    self.savedProject = self.projects[0]
                    UserDefaults.standard.set(self.savedProject?.id,forKey: "savedProjectId")
                    onSuccess()
                    self.isLoaded = true
                }
            }
            // Wenn es kein Projekt gibt
            else {
                print("Empty")
                onSuccess()
                self.isLoaded = true
            }
        })
    }
    // child Add und child updated Listener
    private func observeAddandUpdate() {
        // Added
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
        // Update
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
    // lade erst einmal alle Projekte um gespeichertes Projekt zu laden
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
    //create Project
    func createProject(name: String, groupId: String) {
        FirebaseRepo.addProjectToGroup(groupID: groupId, name: name, onSuccess: { project in
            self.savedProject = project
            UserDefaults.standard.set(self.savedProject?.id,forKey: "savedProjectId")
        }, onError: { errorMessage in
            
        })
    }
    
    //Wenn Klasse zerstörrt stoppe Listener
    deinit {
        print("removeProjectListener")
        ref.removeObserver(withHandle: updateHandle)
        ref.removeObserver(withHandle: newProjectHandle)
    }
}
