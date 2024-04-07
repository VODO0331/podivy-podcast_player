//login Exception
class UserNotFindAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class ChannelWrongAuthException implements Exception{}
class TooManyRequestsAuthException implements Exception{}
//register
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyUserInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}
class PasswordsNotSameAuthException implements Exception{}
//generic
class GenericAuthException implements Exception {}

class UserNotLogInAuthException implements Exception {}
class RequiresRecentLoginException implements Exception{}
class NewEmailInvalid implements Exception{}
