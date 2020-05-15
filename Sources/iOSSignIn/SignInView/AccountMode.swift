import ServerShared

public enum AccountMode {
    case signIn
    case createOwningUser
    case acceptInvitationAndCreateUser(invitation: Invitation)
}
