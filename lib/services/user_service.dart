import '../models/user.dart';
import '../repo/user_repo.dart';

class UserService {
  final UserRepository _repository;

  UserService(this._repository);

  Future<List<User>> fetchUsers() {
    return _repository.fetchUsers();
  }
}
