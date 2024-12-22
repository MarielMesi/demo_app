import '../models/user.dart';
import '../helpers/api_helper.dart';

class UserRepository {
  final String _baseUrl = 'http://jsonplaceholder.typicode.com/users';

  Future<List<User>> fetchUsers() async {
    final data = await ApiHelper.get(_baseUrl);
    return (data as List).map((json) => User.fromJson(json)).toList();
  }
}
