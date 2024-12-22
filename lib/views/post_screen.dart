import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../helpers/service_helper.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final PostService _postService;
  late final UserService _userService;

  List<Post> posts = [];
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _postService = ServiceHelper.getPostService();
    _userService = ServiceHelper.getUserService();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedPosts = await _postService.fetchPosts();
      final fetchedUsers = await _userService.fetchUsers();
      setState(() {
        posts = fetchedPosts;
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deletePost(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                _postService.deletePost(post.id);
                posts = _postService.getPosts();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void createOrEditPost({Post? post}) {
    final isEdit = post != null;
    final titleController = TextEditingController(text: post?.title);
    final bodyController = TextEditingController(text: post?.body);
    int selectedUserId =
        post?.userId ?? (users.isNotEmpty ? users.first.id : 0);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Post' : 'Create Post'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: bodyController,
                      decoration: const InputDecoration(labelText: 'Body'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    DropdownButton<int>(
                      value: selectedUserId,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedUserId = value;
                          });
                        }
                      },
                      items: users.map((user) {
                        return DropdownMenuItem(
                          value: user.id,
                          child: Text(user.name),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newPost = Post(
                  id: post?.id ?? (posts.length + 1),
                  title: titleController.text,
                  body: bodyController.text,
                  userId: selectedUserId,
                );
                setState(() {
                  if (isEdit) {
                    _postService.editPost(newPost);
                  } else {
                    _postService.createPost(newPost);
                  }
                  posts = _postService.getPosts();
                });
                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Save' : 'Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final user = users.firstWhere(
                  (user) => user.id == post.userId,
                  orElse: () => User(id: 0, name: 'Unknown'),
                );
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Text(post.body),
                        const SizedBox(height: 5),
                        Text('- ${user.name}',
                            style: const TextStyle(color: Colors.grey)),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => createOrEditPost(post: post),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deletePost(post),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createOrEditPost(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
