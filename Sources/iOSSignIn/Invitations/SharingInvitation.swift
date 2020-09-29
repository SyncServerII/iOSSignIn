
import ServerShared
import iOSShared
import UIKit

public protocol SharingInvitationDelegate : AnyObject {
    func sharingInvitationReceived(_ sharingInvitation: SharingInvitation, invite:Invitation)
}

public class SharingInvitation {    
    private var invitation:Invitation?
    
    static let queryItemAuthorizationCode = "code"
    
    public weak var delegate:SharingInvitationDelegate?
    
    // The upper/lower case sense of this is ignored.
    let urlScheme:String
    
    weak var signInServicesHelper: SignInServicesHelper!
    let dispatchQueue: DispatchQueue
    
    // Only keeps a weak reference to `SignInServicesHelper`
    // `dispatchQueue`-- queue to call delegate on if delegate given
    public init(appBundleIdentifier: String, signInServicesHelper: SignInServicesHelper, dispatchQueue: DispatchQueue = .main) {
        urlScheme = appBundleIdentifier + ".invitation"
        self.signInServicesHelper = signInServicesHelper
        self.dispatchQueue = dispatchQueue
    }
    
    /**
        This URL/String is suitable for sending in an email to the person being invited.
     
        Handles urls of the form:
          <AppBundleId>.invitation://?code=<InvitationCode>
          where <AppBundleId> is something like biz.SpasticMuffin.SharedImages
    */
    public func createSharingURL(invitationCode:String) -> String {
        let urlString = self.urlScheme + "://?\(Self.queryItemAuthorizationCode)=" + invitationCode
        return urlString
    }
    
    /// Returns true iff can handle the url.
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        logger.debug("url: \(url)")
        
        var returnResult = false
        // Use case insensitive comparison because the incoming url scheme will be lower case.
        if url.scheme?.caseInsensitiveCompare(urlScheme) == ComparisonResult.orderedSame {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                logger.debug("components.queryItems: \(String(describing: components.queryItems))")
                
                // 4/10/19; Keeping the count check as >= 1 to be backward compatible with the older style which included permission.
                if let queryItems = components.queryItems, queryItems.count >= 1 {
                    let queryItemCode = queryItems[0]
                    if queryItemCode.name == SharingInvitation.queryItemAuthorizationCode,
                        let invitationCodeString = queryItemCode.value,
                        let invitationCode = UUID(uuidString: invitationCodeString) {
                        
                        logger.debug("invitationCode: \(invitationCode)")
                        
                        signInServicesHelper.getSharingInvitationInfo(sharingInvitationUUID: invitationCode) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .failure(let error):
                                logger.error("\(error)")
                                DispatchQueue.main.async {
                                    Alert.show(withTitle: "Alert!", message: "There was an error contacting the server for the sharing information.")
                                }
                            case .success(let info):
                                switch info {
                                case .noInvitationFound:
                                    DispatchQueue.main.async {
                                        Alert.show(withTitle: "Alert!", message: "No invitation was found on the server. Did the invitation expire?")
                                    }
                                case .invitation(let invite):
                                    self.invitation = invite
                                    if let delegate = self.delegate{
                                        self.dispatchQueue.async { [weak self] in
                                            guard let self = self else { return }
                                            delegate.sharingInvitationReceived(self, invite: invite)
                                        }
                                    }
                                }
                            }
                        }
                        
                        returnResult = true
                    }
                }
            }
        }

        return returnResult
    }
}
