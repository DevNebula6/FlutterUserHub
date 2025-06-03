import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_hub/auth/bloc/auth_event.dart';
import 'package:flutter_user_hub/user/bloc/user_bloc.dart';
import 'package:flutter_user_hub/user/bloc/user_event.dart';
import 'package:flutter_user_hub/user/bloc/user_state.dart';
import 'package:flutter_user_hub/utils/widgets/enhanced_snackbar.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../user/user_model.dart';
import '../utils/widgets/dialog_neomorphic.dart';
import '../utils/widgets/user_list_item.dart';
import 'onboarding_page.dart';
import 'user_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // fetch users when the screen is loaded
    Future.microtask(() => 
      context.read<UserBloc>().add(const UserFetchRequested())
    );
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_isBottom) {
      context.read<UserBloc>().add(const UserLoadMoreRequested());
    }
  }
  
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  
  void _confirmLogout() async {
    final shouldLogout = await showNeomorphicDialog(
      context: context, 
      title: 'Logout Confirmation', 
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.logout,
      iconColor: Colors.red[700],
    );
    
    if (shouldLogout && mounted) {
      context.read<AuthBloc>().add(LogoutRequested());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                (route) => false,
              );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search users...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.blueGrey[400]),
                      ),
                      style: TextStyle(color: Colors.blueGrey[800]),
                      autofocus: true,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<UserBloc>().add(UserSearchRequested(value));
                        } else if (value.isEmpty) {
                          context.read<UserBloc>().add(const UserFetchRequested());
                        }
                      },
                    )
                  : const Text('User Hub'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.blueGrey[800],
              actions: [
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _searchController.clear();
                        context.read<UserBloc>().add(const UserFetchRequested());
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: _confirmLogout,
                ),
              ],
            ),
            body: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserError) {
                  EnhancedSnackBar.showError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is UserInitial || (state is UserLoading && state != UserSearching)) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (state is UserLoaded) {
                  if (state.users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.blueGrey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No users found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<UserBloc>().add(const UserRefreshRequested());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.hasReachedMax
                          ? state.users.length
                          : state.users.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.users.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        
                        final user = state.users[index];
                        return UserListItem(
                          user: user,
                          onTap: () => _navigateToUserDetail(user),
                        );
                      },
                    ),
                  );
                }
                
                if (state is UserSearching) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                // Fallback for any other state
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<UserBloc>().add(const UserFetchRequested());
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
  
  void _navigateToUserDetail(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailScreen(userId: user.id! ),
      ),
    );
  }
}