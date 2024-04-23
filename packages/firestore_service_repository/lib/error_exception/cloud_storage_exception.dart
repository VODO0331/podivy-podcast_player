class CloudStorageException implements Exception{
  const CloudStorageException();
}

class CloudNotCreateException extends CloudStorageException{}

class CloudNotGetException extends CloudStorageException{}

class CloudNotUpdateException extends CloudStorageException{}

sealed class CloudDeleteException extends CloudStorageException{}

class CloudInitException extends CloudStorageException{}

class FollowDeleteException extends CloudDeleteException{}
class InterestDeleteException extends CloudDeleteException{}
class ListDeleteException extends CloudDeleteException{}
class InfoDeleteException extends CloudDeleteException{}