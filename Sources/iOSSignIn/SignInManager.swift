
//
//  SignInManager.swift
//  SyncServer
//
//  Created by Christopher Prince on 6/23/17.
//  Copyright © 2017 Christopher Prince. All rights reserved.
//

import UIKit
import iOSShared
import Foundation
import PersistentValue
import Combine

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

// This class needs to be derived from NSObject because of use of `Network.session().connectionStateCallbacks` below.
public class SignInManager : NSObject, ObservableObject {
    let refreshInterval: TimeInterval = 60 * 10 // 10 minutes
    var refreshTimer: Timer?
    
    enum SignInManagerError: Error {
        case duplicateSignIn(String)
    }
    
    /// These must be stored in user defaults-- so that if they delete the app, we lose it, and can start again. Storing both the currentUIDisplayName and userId because the userId (at least for Google) is just a number and not intelligible in the UI.
    // public static var currentUIDisplayName = try! PersistentValue<String>(name: "SignInManager.currentUIDisplayName", storage: .userDefaults)
    
    //public static var currentUserId = try! PersistentValue<String>(name: "SignInManager.currentUserId", storage: .userDefaults)
    
    /// The class name of the current GenericSignIn
    // [1] Changing to using PersistentValue .file to deal with background launching.
    //static var currentSignInName0 = try! PersistentValue<String>(name: "SignInManager.currentSignIn", storage: .userDefaults)
    
    static var currentSignInName = try! PersistentValue<String>(name: "SignInManager.currentSignIn", storage: .file)

    public class SignInStateChanged: SelectorTargets {
        public var selectorTargets = [(target: NSObject, action: Selector)]()
    }

    // Add a target/selector to this to be informed of sign in state changes.
    public var signInStateChanged = SignInStateChanged()
    
    public fileprivate(set) var lastStateChangeSignedUserIn = false
    
    // The intent is that this delegate operates "down" to the controller
    weak var controlDelegate:SignInManagerControlDelegate?
    var controlDelegateQueue: DispatchQueue = .main
    
    // And this delegate operates "up" to the owner of the manager
    public weak var delegate: SignInManagerDelegate!
    
    weak var signIns: SignInsDelegate?
    
    /// `signIns` is the main integration point with iOSBasics. It must be the
    /// `SignIns` object you also pass to the SyncServer constructor with iOSBasics.
    /// This object is weakly retained.
    init(signIns: SignInsDelegate) {
        self.signIns = signIns
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
            if let currentSignIn = currentSignIn {
                Self.currentSignInName.value = currentSignIn.stringNameForClass
            }
            else {
                Self.currentSignInName.value = nil
            }
        }
    }
    
    /// In a sharing extension, this can be non-nil and yet `userIsSignedIn` can be false-- if the sign in type doesn't support sharing extension use. (e.g., currently for Facebook-- https://github.com/facebook/facebook-ios-sdk/issues/1607)
    public var currentSignInClassName: String? {
        return Self.currentSignInName.value
    }
    
    /// This is @Published because (a) some `GenericSignIn`'s are asynchronous in terms of providing `userIsSignedIn` indication and (b) some client code needs to depend on when the sign in occurs.
    /// Use `currentSignIn` to get the current sign in if this returns true.
    @Published public var userIsSignedIn:Bool?
    
    // I'm not updating `userIsSignedIn` when `currentSignIn` is assigned because `currentSignIn` gets updated in `addSignIn`.
    private func updateUserIsSignedIn(_ signedIn: Bool) {
        userIsSignedIn = signedIn
    }
    
    /// At app launch, you must set up all the SignIn's that you'll be presenting to the user. This will call their `appLaunchSetup` method.
    public func addSignIns(_ signIns:[GenericSignIn], launchOptions options: [UIApplication.LaunchOptionsKey: Any]?) throws {
        for signIn in signIns {
            try addSignIn(signIn, launchOptions: options)
        }
        
        // Two cases in which I need to set `userIsSignedIn` to false.
        // First: If there was no `currentSignInName`. i.e., no user signed in at app launch.
        // Second: A user was signed in at app launch, but the sign in didn't take responsiblity. This can happen if a sign in isn't being used in a sharing extension, for example.
        
        if currentSignInClassName == nil {
            userIsSignedIn = false
        }
        else if let currentSignInName = currentSignInClassName {
            let signInNameInDescriptions = allSignIns.first(where: {$0.stringNameForClass == currentSignInName})
            if signInNameInDescriptions == nil {
                userIsSignedIn = false
            }
        }
        
        startPeriodicCredentialsRefresh()
    }
    
    func addSignIn(_ signIn:GenericSignIn, launchOptions options: [UIApplication.LaunchOptionsKey: Any]?) throws {

        // Make sure we don't already have an instance of this signIn
        let name = signIn.stringNameForClass
        let result = allSignIns.filter({$0.stringNameForClass == name})
        
        guard result.count == 0 else {
            throw SignInManagerError.duplicateSignIn(name)
        }
        
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
            controlDelegateQueue.async { [weak self] in
                self?.controlDelegate?.silentSignIn(signIn)
            }
        }
    }
    
    /// Based on the currently active signin method, this will call the corresponding method on that class.
    @discardableResult
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        for signIn in allSignIns {
            if SignInManager.currentSignInName.value == signIn.stringNameForClass {
                return signIn.application(app, open: url, options: options)
            }
        }
        
        // 10/1/17; Up until today, I had this assert here. For some reason, I was assuming that if I got a `open url` call, the user *had* to be signed in. But this is incorrect. For example, I could get a call for a sharing invitation.
        // assert(false)
        return false
    }
    
    // Starts an auto-refresh mechanism, to refresh credentials periodically while the app is in the foreground.
    // Solution to this problem: https://github.com/SyncServerII/iOSBasics/issues/3
    func startPeriodicCredentialsRefresh() {
        if let _ = refreshTimer {
            return
        }
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            self?.refreshCredentials()
        }

        // Not going to do a `refreshCredentials`-- assuming this will be done by specific credentials on app start.
    }
    
    func refreshCredentials() {
        guard let credentials = currentSignIn?.credentials else {
            return
        }
        
        logger.debug("Refreshing credentials")
        
        credentials.refreshCredentials { error in
            if let error = error {
                logger.error("\(error)")
            }
            else  {
                logger.debug("Success refreshing credentials!")
            }
        }
    }
}

extension SignInManager: GenericSignInDelegate {
    public func signInStarted(_ signIn: GenericSignIn) {
        // Must not have any other signin's active when attempting to sign in.
        guard currentSignIn == nil else {
            controlDelegateQueue.async { [weak self] in
                self?.controlDelegate?.showAlert(signIn, title: "Alert!", message: "Somehow another sign in was active. Please try again.")
            }
            currentSignIn = nil
            return
        }

        // This is necessary to enable the `application(_ application: UIApplication!,...` method to be called during the sign in process.
        currentSignIn = signIn
        
        controlDelegateQueue.async { [weak self] in
            self?.controlDelegate?.signInStarted(signIn)
        }
    }
    
    public func signInCancelled(_ signIn: GenericSignIn) {
        currentSignIn = nil
        controlDelegateQueue.async { [weak self] in
            self?.controlDelegate?.signInCancelled(signIn)
        }
    }
    
    // TODO: Can we get rid of this? And just rely on `signInCompleted`? So far, it's not used in the iOSFacebook signin.
    public func haveCredentials(_ signIn: GenericSignIn, credentials: GenericCredentials) {
        currentSignIn = signIn
    }
    
    public func signInCompleted(_ signIn: GenericSignIn, autoSignIn: Bool) {
        controlDelegateQueue.async { [weak self] in
            guard let self = self else { return }
            
            // This is necessary for silent sign in's.
            self.currentSignIn = signIn
                        
            self.controlDelegate?.signInCompleted(signIn)
            self.updateUserIsSignedIn(signIn.userIsSignedIn)
            
            if let mode = self.controlDelegate?.accountMode(signIn) {
                self.signInCompleted(signIn: signIn, mode: mode, autoSignIn: autoSignIn)
            } else if autoSignIn {
                // Nil mode returned from `controlDelegate?.accountMode`, but I want to do a check creds if only because I want to allow for a check creds call for Apple sign in-- this drives the periodic credential validity check.
                self.signInCompleted(signIn: signIn, mode: .signIn, autoSignIn: autoSignIn)
            }
            else {
                logger.error("SignInManager.signInCompleted: ERROR: Could not get AccountMode")
            }
                        
            logger.info("Credentials: \(String(describing: self.currentSignIn?.credentials))")
        }
    }
    
    public func userIsSignedOut(_ signIn: GenericSignIn) {
        currentSignIn = nil
        controlDelegateQueue.async { [weak self] in
            self?.controlDelegate?.userIsSignedOut(signIn)
        }
        userIsSignedOut(signIn: signIn)
        updateUserIsSignedIn(false)
    }
}

// Call delegate methods.
private extension SignInManager {
    func signInCompleted(signIn: GenericSignIn, mode: AccountMode, autoSignIn: Bool) {
       delegate?.signInCompleted(self, signIn: signIn, mode: mode, autoSignIn: autoSignIn)
       signIns?.signInCompleted(self, signIn: signIn, mode: mode, autoSignIn: autoSignIn)
    }
    
    func userIsSignedOut(signIn: GenericSignIn) {
        delegate?.userIsSignedOut(self, signIn: signIn)
        signIns?.userIsSignedOut(self, signIn: signIn)
    }
}
