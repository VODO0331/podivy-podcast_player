import 'package:authentication_repository/authentication_repository.dart';


get  userId =>  AuthService.firebase().currentUser!.id;