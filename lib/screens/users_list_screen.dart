import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/avatar_bubble.dart';

class UsersListScreen extends StatefulWidget {
  final Function(String userId, String userName) onUserTap;

  const UsersListScreen({super.key, required this.onUserTap});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.users.isEmpty) {
          return const Center(child: Text("No users yet. Tap + to add one!"));
        }
        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: ListView.separated(
            controller: _scrollController,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: provider.users.length,
            separatorBuilder: (ctx, i) =>
                Divider(height: 1, color: Colors.grey.shade100, indent: 80),
            itemBuilder: (context, index) {
              final user = provider.users[index];

              return InkWell(
                onTap: () => widget.onUserTap(user.id, user.name),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          AvatarBubble(
                            initials: user.initials,
                            radius: 28,
                            backgroundGradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF9089FC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          if (user.isOnline)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF00C853,
                                  ), // Green online
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.lastActive ?? "Offline",
                              style: TextStyle(
                                color: user.isOnline
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
