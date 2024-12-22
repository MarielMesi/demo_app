import '../models/post.dart';
import '../repo/post_repo.dart';

class PostService {
  final PostRepository _repository;
  List<Post> _posts = [];

  PostService(this._repository);

  Future<List<Post>> fetchPosts() async {
    _posts = await _repository.fetchPosts();
    return _posts;
  }

  void deletePost(int postId) {
    _posts.removeWhere((post) => post.id == postId);
  }

  void editPost(Post updatedPost) {
    final index = _posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      _posts[index] = updatedPost;
    }
  }

  void createPost(Post newPost) {
    _posts.add(newPost);
  }

  List<Post> getPosts() => _posts;
}
