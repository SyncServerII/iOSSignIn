import ServerShared

public enum AccountMode {
    case signIn
    case createOwningUser
    
    // May or may not involve creating a user.
    case acceptInvitation(invitation: Invitation)
}
