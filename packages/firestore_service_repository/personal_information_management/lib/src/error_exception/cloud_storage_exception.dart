class CloudStorageException implements Exception{
  const CloudStorageException();
}

class CloudNotCreateException extends CloudStorageException{}

class CloudNotGetException extends CloudStorageException{}

class CloudNotUpdateException extends CloudStorageException{}

class CloudDeleteException extends CloudStorageException{}


class ImageErrorException implements Exception{}

class FileNotExistsException implements Exception{}