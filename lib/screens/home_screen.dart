import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_tab_switcher.dart';
import '../providers/chat_provider.dart';
import 'users_list_screen.dart';
import 'chat_history_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToChat(String userId, String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(userId: userId, userName: userName),
      ),
    );
  }

  void _showAddUserDialog() {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add User"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: "Enter user name",
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Provider.of<ChatProvider>(
                  context,
                  listen: false,
                ).addUser(nameController.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("User '${nameController.text}' added"),
                  ),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false, // Scroll away behavior
              centerTitle: true,
              title: CustomTabSwitcher(
                selectedIndex: _selectedIndex,
                onTabSelected: _onTabSelected,
              ),
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            UsersListScreen(onUserTap: _navigateToChat),
            ChatHistoryScreen(onSessionTap: _navigateToChat),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddUserDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
