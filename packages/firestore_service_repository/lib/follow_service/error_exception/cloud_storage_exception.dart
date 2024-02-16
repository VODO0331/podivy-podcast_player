class CloudStorageException implements Exception{
  const CloudStorageException();
}

class CloudNotCreateNoteException extends CloudStorageException{}

class CloudNotGetAllNoteException extends CloudStorageException{}

class CloudNotUpdateAllNoteException extends CloudStorageException{}

class CloudNotDeleteAllNoteException extends CloudStorageException{}