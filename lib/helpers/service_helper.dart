import '../services/post_service.dart';
import '../services/user_service.dart';
import '../repo/post_repo.dart';
import '../repo/user_repo.dart';

class ServiceHelper {
  static PostService getPostService() {
    return PostService(PostRepository());
  }

  static UserService getUserService() {
    return UserService(UserRepository());
  }
}
