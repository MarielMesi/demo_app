import '../models/post.dart';
import '../helpers/api_helper.dart';

class PostRepository {
  final String _baseUrl = 'http://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> fetchPosts() async {
    final data = await ApiHelper.get(_baseUrl);
    return (data as List).map((json) => Post.fromJson(json)).toList();
  }
}
