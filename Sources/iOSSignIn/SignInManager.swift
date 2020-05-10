
//
//  SignInManager.swift
//  SyncServer
//
//  Created by Christopher Prince on 6/23/17.
//  Copyright © 2017 Christopher Prince. All rights reserved.
//

import UIKit

public protocol SelectorTargets {
    var selectorTargets:[(target: NSObject, action: Selector)] { get set }
}

public extension SelectorTargets {
    mutating func addTarget(_ target: NSObject, action: Selector) {
        removeTarget(target, action: action)
        selectorTargets += [(target, action)]
    }
    
    mutating func removeTarget(_ target: NSObject?, action: Selector?) {
        var removalSet = IndexSet()
        for (index, selectorTarget) in selectorTargets.enumerated() {
            if selectorTarget.action != action && selectorTarget.target == target {
                removalSet.insert(index)
            }
            else {
                continue
            }
        }
        
        selectorTargets.remove(atOffsets: removalSet)
    }
    
    func performActions() {
        for selectorTarget in selectorTargets {
            selectorTarget.target.perform(selectorTarget.action)
        }
    }
}

import Foundation
import PersistentValue

// This class needs to be derived from NSObject because of use of `Network.session().connectionStateCallbacks` below.
public class SignInManager : NSObject {
    /// These must be stored in user defaults-- so that if they delete the app, we lose it, and can start again. Storing both the currentUIDisplayName and userId because the userId (at least for Google) is just a number and not intelligible in the UI.
    public static var currentUIDisplayName = try! PersistentValue<String>(name: "SignInManager.currentUIDisplayName", storage: .userDefaults)
    
    public static var currentUserId = try! PersistentValue<String>(name: "SignInManager.currentUserId", storage: .userDefaults)
    
    /// The class name of the current GenericSignIn
    // [1] Changing to using PersistentValue .file to deal with background launching.
    static var currentSignInName0 = try! PersistentValue<String>(name: "SignInManager.currentSignIn", storage: .userDefaults)
    
    static var currentSignInName = try! PersistentValue<String>(name: "SignInManager.currentSignIn", storage: .file)
    
    public class SignInStateChanged: SelectorTargets {
        public var selectorTargets = [(target: NSObject, action: Selector)]()
    }
    
    // Add a target/selector to this to be informed of sign in state changes.
    public var signInStateChanged = SignInStateChanged()
    
    public fileprivate(set) var lastStateChangeSignedUserIn = false
    
    private let transitions:SignInTransitions
    
    init(transitions:SignInTransitions) {
        self.transitions = transitions
        super.init()
/*
        signInStateChanged.resetTargets!()
        _ = Network.session().connectionStateCallbacks.addTarget!(self, with: #selector(networkChangedState))
        
        // See [1].
        if SignInManager.currentSignInName.value == nil && SignInManager.currentSignInName0.stringValue != "" {
            SignInManager.currentSignInName.value = SignInManager.currentSignInName0.stringValue
        }
*/
    }
    
    @objc private func networkChangedState() {
/*
        let networkOnline = Network.session().connected()
        for signIn in alternativeSignIns {
            signIn.networkChangedState(networkIsOnline: networkOnline)
        }
*/
    }
    
    private(set) var allSignIns = [GenericSignIn]()
    
    /// Set this to establish the current SignIn mechanism in use in the app.
    public var currentSignIn:GenericSignIn? {
        didSet {
            if currentSignIn == nil {
                Self.currentSignInName.value = nil
            }
            else {
                Self.currentSignInName.value = stringNameForSignIn(currentSignIn!)
            }
        }
    }
    
    fileprivate func stringNameForSignIn(_ signIn: GenericSignIn) -> String {
        // This gives "GenericSignIn"
        // String(describing: type(of: currentSignIn!))
        
        let mirror = Mirror(reflecting: signIn)
        return "\(mirror.subjectType)"
    }
    
    /// A shorthand-- because it's often used.
    public var userIsSignedIn:Bool {
        return currentSignIn?.userIsSignedIn ?? false
    }
    
    /// At app launch, you must set up all the SignIn's that you'll be presenting to the user. This will call their `appLaunchSetup` method.
    public func addSignIn(_ signIn:GenericSignIn, launchOptions options: [UIApplication.LaunchOptionsKey: Any]?) {

        // Make sure we don't already have an instance of this signIn
        let name = stringNameForSignIn(signIn)
        let result = allSignIns.filter({stringNameForSignIn($0) == name})
        assert(result.count == 0)
        
        allSignIns.append(signIn)
        signIn.delegate = self
        
        func userSignedIn(withSignInName name: String) -> Bool {
            return SignInManager.currentSignInName.value == name
        }
        
        signIn.appLaunchSetup(userSignedIn: userSignedIn(withSignInName: name), withLaunchOptions: options)
        
        // 12/3/17; In some cases, the `userSignedIn` state can change with the call `appLaunchSetup`-- so, recompute userSignedIn each time. This is related to the fix for https://github.com/crspybits/SharedImages/issues/64
        
        // To accomodate sticky sign-in's-- we might as well have a `currentSignIn` value immediately after addSignIn's are called.
        if userSignedIn(withSignInName: name) {
            currentSignIn = signIn
        }
    }
    
    /// Based on the currently active signin method, this will call the corresponding method on that class.
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        for signIn in allSignIns {
            if SignInManager.currentSignInName.value == stringNameForSignIn(signIn) {
                return signIn.application(app, open: url, options: options)
            }
        }
        
        // 10/1/17; Up until today, I had this assert here. For some reason, I was assuming that if I got a `open url` call, the user *had* to be signed in. But this is incorrect. For example, I could get a call for a sharing invitation.
        // assert(false)
        return false
    }
}

/*
extension SignInManager : SignInManagerDelegate {
    public func signInStateChanged(to state: SignInState, for signIn:GenericSignIn) {
        let priorSignIn = currentSignIn
        
        switch state {
        case .signInStarted:
            // Must not have any other signin's active when attempting to sign in.
            assert(currentSignIn == nil)
            // This is necessary to enable the `application(_ application: UIApplication!,...` method to be called during the sign in process.
            currentSignIn = signIn
            
        case .signedIn:
            // This is necessary for silent sign in's.
            currentSignIn = signIn
            
        case .signedOut:
            currentSignIn = nil
        }
        
        lastStateChangeSignedUserIn = priorSignIn == nil && currentSignIn != nil
        
        signInStateChanged.forEachTarget!() { (target, selector, dict) in
            if let targetObject = target as? NSObject {
                targetObject.performVoidReturn(selector)
            }
        }
    }
}
*/

extension SignInManager: GenericSignInDelegate {
    public func signInStarted(_ signIn: GenericSignIn) {
        transitions.signInStarted(signIn)
    }
    
    public func signInCancelled(_ signIn: GenericSignIn) {
        transitions.signInCancelled(signIn)
    }
    
    public func haveCredentials(_ signIn: GenericSignIn, credentials: GenericCredentials) {
        //currentSignIn // = credentials
    }
    
    public func signInCompleted(_ signIn: GenericSignIn, autoSignIn: Bool) {
        transitions.signInCompleted(signIn)
    }
    
    public func userIsSignedOut(_ signIn: GenericSignIn) {
        transitions.userIsSignedOut(signIn)
    }
}
