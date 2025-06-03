import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_hub/repositories/user_repository.dart';
import 'package:flutter_user_hub/user_detail/bloc/user_detail_bloc.dart';
import 'package:flutter_user_hub/user_detail/bloc/user_detail_event.dart';
import 'package:flutter_user_hub/user_detail/bloc/user_detail_state.dart';
import 'package:flutter_user_hub/utils/widgets/enhanced_snackbar.dart';

import '../user/user_model.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  late final UserDetailBloc _userDetailBloc;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _userDetailBloc = UserDetailBloc(
      userRepository: RepositoryProvider.of<UserRepository>(context),
    );
    // Fetch data after widget has been fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userDetailBloc.add(UserDetailFetched(widget.userId));
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _userDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserDetailBloc>.value(
      value: _userDetailBloc,
      child: BlocConsumer<UserDetailBloc, UserDetailState>(
        listener: (context, state) {
          if (state is UserDetailError) {
            EnhancedSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: const Text('User Details'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.blueGrey[800],
              actions: [
                if (state is UserDetailLoaded) // Only show add button if loaded
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Add new post',
                    onPressed: () => _showAddPostDialog(context),
                  ),
              ],
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(UserDetailState state) {
    if (state is UserDetailLoading || state is UserDetailInitial) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading user details...'),
          ],
        ),
      );
    } 
    
    if (state is UserDetailLoaded) {
      return Column(
        children: [
          _buildUserInfoCard(state.user),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blueGrey[800],
            unselectedLabelColor: Colors.blueGrey[400],
            indicatorColor: Colors.blueGrey[700],
            tabs: const [
              Tab(text: 'POSTS', icon: Icon(Icons.article_outlined)),
              Tab(text: 'TODOS', icon: Icon(Icons.check_circle_outline)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPostsTab(state),
                _buildTodosTab(state),
              ],
            ),
          ),
        ],
      );
    }
    
    // Error state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(color: Colors.blueGrey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _userDetailBloc.add(UserDetailFetched(widget.userId));
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserInfoCard(User user) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.image ?? ''),
            ),
            const SizedBox(height: 12),
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.blueGrey[400]),
                const SizedBox(width: 4),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab(UserDetailLoaded state) {
    // Show loading indicator while fetching posts
    if (state.posts == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading posts...'),
          ],
        ),
      );
    }
    
    final posts = state.posts;
    if (posts!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Colors.blueGrey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No posts found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Post'),
              onPressed: () => _showAddPostDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[700],
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.body,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey[700],
                  ),
                ),
                const SizedBox(height: 8),
                if (post.tags.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: post.tags.map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blueGrey[50],
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (post.isLocal == true)
                      Chip(
                        label: const Text('Local', style: TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: Colors.green[400],
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      )
                    else Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red[400], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${post.reactions.likes}',
                          style: TextStyle(
                            color: Colors.blueGrey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTodosTab(UserDetailLoaded state) {
    // Show loading indicator while fetching todos
    if (state.todos == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading todos...'),
          ],
        ),
      );
    }
    
    final todos = state.todos;
    if (todos!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.blueGrey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No todos found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(
              todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: todo.completed ? Colors.green[600] : Colors.grey[400],
            ),
            title: Text(
              todo.todo,
              style: TextStyle(
                decoration: todo.completed ? TextDecoration.lineThrough : TextDecoration.none,
                color: todo.completed ? Colors.blueGrey[400] : Colors.blueGrey[800],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.blueGrey[400],
            ),
          ),
        );
      },
    );
  }
  
  void _showAddPostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create New Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Post Title',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Post Body',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.trim().isNotEmpty && 
                  _bodyController.text.trim().isNotEmpty) {
                
                // Add the post using the bloc instance
                _userDetailBloc.add(UserPostAdded(
                  userId: widget.userId,
                  title: _titleController.text.trim(),
                  body: _bodyController.text.trim(),
                ));
                
                // Clear fields and close dialog
                _titleController.clear();
                _bodyController.clear();
                Navigator.of(dialogContext).pop();
                
                // Show success message
                EnhancedSnackBar.showSuccess(context, 'Post added successfully!');
              } else {
                EnhancedSnackBar.showError(context, 'Title and body cannot be empty');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
