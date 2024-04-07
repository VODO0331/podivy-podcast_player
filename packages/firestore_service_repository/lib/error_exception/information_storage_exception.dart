class InformationStorageException implements Exception{
  const InformationStorageException();
}

class ImageErrorException extends InformationStorageException{}
class EmailAlreadyInUse extends InformationStorageException{}