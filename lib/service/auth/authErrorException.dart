//login Exception
class UserNotFindAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class ChannelWorngAuthException implements Exception{}
class TooManyRequestsAuthException implements Exception{}
//register
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyUserInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}
class PasswordsNotSameAuthException implements Exception{}
//generic
class GenericAuthException implements Exception {}

class UserNotLogInAuthException implements Exception {}
