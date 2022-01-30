//
//  FirebaseRepo.swift
//  ClockWork
//
//  Created by Mattis on 13.01.22.
//

import Foundation
import Combine
import Firebase
import FirebaseDatabaseSwift

class FirebaseRepo {
    
    private static let groupPath = "groups"
    private static let userPath = "user"
    private static let ref = Database.database().reference()
    private static let dateFormat = "dd-MM-yyyy"
    
    static func addUser(onSuccess: @escaping(_ username : String) -> Void, onError: @escaping (_ errorMessage : String) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            onError("User konnte nicht erstellt werden")
            return
        }
        guard let username = currentUser.email?.components(separatedBy: "@")[0] else {
            onError("User konnte nicht erstellt werden")
            return
        }
        let user = User(id: currentUser.uid, username: username, groupID: "")
        do {
            try ref.child("\(userPath)/\(currentUser.uid)").setValue(from: user)
            onSuccess(username)
        } catch let error {
                 onError(error.localizedDescription)
        }
        
    }
    
    static func addGroup(name: String, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void) {
        
        guard let groupID = ref.child(groupPath).childByAutoId().key else {
            onError("Gruppe konnte nicht erstellt werden")
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            onError("Gruppe konnte nicht erstellt werden")
            return
        }
        
        let group = WorkGroup(id: groupID, name: name)
        do {
            try ref.child("\(groupPath)/\(groupID)").setValue(from: group)
            ref.child("\(groupPath)/\(groupID)/user/\(currentUser.uid)").setValue(["role": "admin" ,"name": AuthentificationObserver.shared.username]) {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    onError(error.localizedDescription)
                } else {
                    addUserToGroup(groupID: groupID, onSuccess: {
                        onSuccess()
                    }, onError: { errorMessage in
                        onError(errorMessage)
                    })
                }
            }
        } catch let error {
            onError(error.localizedDescription)
        }
        
    }
    
    static func enterGroup(groupID: String, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void ) {
        guard let currentUser = Auth.auth().currentUser else {
            onError("Gruppe konnte nicht erstellt werden")
            return
        }
        ref.child("\(groupPath)/\(groupID)").getData(completion:  { error, snapshot in
            guard error == nil else {
                onError(error?.localizedDescription ?? "sehr komischer Fehler")
                return
            }
            if snapshot.exists() {
            print(snapshot.exists())
                            ref.child("\(groupPath)/\(groupID)/user/\(currentUser.uid)").setValue(["role": "member" ,"name": AuthentificationObserver.shared.username]) {
                                (error:Error?, ref:DatabaseReference) in
                                if let error = error {
                                    onError(error.localizedDescription)
                                } else {
                                    addUserToGroup(groupID: groupID, onSuccess: {
                                        onSuccess()
                                    }, onError: { errorMessage in
                                        onError(errorMessage)
                                    })
                                }
                            }
            }
            else {
                print("nope")
                onError("Gruppe konnte nicht gefunden werden")
            }
        })
    }
    
    static func addUserToGroup(groupID: String, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void ) {
        
        guard let currentUser = Auth.auth().currentUser else {
            onError("User konnte nicht erstellt werden")
            return
        }
        
        let update = ["\(userPath)/\(currentUser.uid)/groupID": groupID]
                      
        ref.updateChildValues(update) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                onError(error.localizedDescription)
            } else {
                onSuccess()
            }
        }
        
    }
    
    static func addProjectToGroup(groupID: String, name: String, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void ) {
        print(groupID)
        let projectsRef = ref.child("\(groupPath)/\(groupID)/projects")
        guard let projectID = projectsRef.childByAutoId().key else {
            onError("Gruppe konnte nicht erstellt werden")
            return
        }
        let project = Project(id: groupID, name: name, issues: [])
        
        do {
            try projectsRef.child(projectID).setValue(from: project)
            onSuccess()
        }
        catch {
            onError("Es konnte kein Projekt erstellt werden")
        }
    }
    
    static func addIssue(groupID: String, issue: Issue, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void ) {
        guard let projectID =   UserDefaults.standard.string(forKey: "savedProjectId") else {
            onError("Es konnte kein Projekt erstellt werden")
            return
        }
        let issueRef = ref.child("\(groupPath)/\(groupID)/projects/\(projectID)/issues")
        guard let issueID = issueRef.childByAutoId().key else {
            onError("Es konnte kein Projekt erstellt werden")
            return
        }
        var saveIssue = issue
        saveIssue.id = issueID
        do {
            try issueRef.child("\(issueID)").setValue(from: saveIssue)
            onSuccess()
        } catch {
            onError("Es konnte kein Projekt erstellt werden")
        }

    }
    
    static func updateIssue(issue: Issue, page: IssuePages, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void ) {
        guard let projectID =   UserDefaults.standard.string(forKey: "savedProjectId") else {
            onError("Es konnte kein Projekt erstellt werden")
            return
        }
        let groupID = GroupObserver.shared.groupID
        let issueRef = ref.child("\(groupPath)/\(groupID)/projects/\(projectID)/issues/\(issue.id)/")
        print(issueRef)
        issueRef.updateChildValues(["issueState" : page.rawValue])
    }
    
    static func addTime(groupID: String, startDate: Date,time: Double, issue: Issue, project: Project, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void ) {
        guard let currentUser = Auth.auth().currentUser else {
            onError("User konnte nicht erstellt werden")
            return
        }
        let groupUserDateRef = ref.child("\(groupPath)/\(groupID)/user/\(currentUser.uid)/dates").child(startDate.getFormattedDate(format: dateFormat))
        
        groupUserDateRef.getData(completion:  { error, snapshot in
            guard error == nil else {
                onError(error?.localizedDescription ?? "sehr komischer Fehler")
                return
            }
            if snapshot.exists() {
                // update Date
                let value = snapshot.value as? NSDictionary
                if let value = value?[(startDate.getFormattedDate(format: dateFormat))] as? NSDictionary {
                
                guard let issueDict = value["issues"] as? NSDictionary else {
                    onError("key falsch benannt")
                    print(#file, "wrong keyname")
                    return
                }
                if let toggleIssue = issueDict[issue.id] as? NSDictionary {
                    print("issue exists")
                    let issueTime =  Double(toggleIssue["issueTime"] as? String ?? "0") ?? 0
                    let issueUpdate = ["issueTime" : String((time + issueTime))]
                    let issueUpdateRef = groupUserDateRef.child("issues").child(issue.id)
                    issueUpdateRef.updateChildValues(issueUpdate)
                }
                else {
                    groupUserDateRef.child("issues").updateChildValues([issue.id : ["issueName": issue.name, "projectName": project.name, "issueTime" : String(time)]])
                }
                let totaltime = Double(value["totalTime"] as? String ?? "0") ?? 0
                print(totaltime)
                let update = ["totalTime": String((totaltime + time))]
                groupUserDateRef.updateChildValues(update)
                } else {
                    groupUserDateRef.setValue(["totalTime": String(time), "issues" : [ issue.id : ["issueName": issue.name, "projectName": project.name, "issueTime" : String(time)]]])
                }
                
            } else {
                // create Date
                groupUserDateRef.setValue(["totalTime": String(time), "issues" : [ issue.id : ["issueName": issue.name, "projectName": project.name, "issueTime" : String(time)]]])
            }
            
        })
        
    }
}
