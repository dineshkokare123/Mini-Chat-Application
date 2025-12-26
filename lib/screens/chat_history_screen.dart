import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../widgets/avatar_bubble.dart';

class ChatHistoryScreen extends StatefulWidget {
  final Function(String userId, String userName) onSessionTap;

  const ChatHistoryScreen({super.key, required this.onSessionTap});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.sessions.isEmpty) {
          return const Center(child: Text("No chat history yet."));
        }
        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: ListView.separated(
            controller: _scrollController,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: provider.sessions.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            separatorBuilder: (ctx, i) =>
                Divider(height: 1, color: Colors.grey.shade100, indent: 80),
            itemBuilder: (context, index) {
              final session = provider.sessions[index];
              final timeStr = _formatTime(session.lastMessageTime);

              // Generate deterministic color based on name length/hash
              final colorIndex =
                  session.contactName.length % _avatarColors.length;
              final avatarColor = _avatarColors[colorIndex];

              return InkWell(
                onTap: () =>
                    widget.onSessionTap(session.contactId, session.contactName),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      AvatarBubble(
                        initials: session.initials,
                        radius: 28, // Slightly larger as per designs
                        backgroundColor: avatarColor,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.contactName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              session.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            timeStr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (session.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2962FF), // Bright Blue
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${session.unreadCount}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            const SizedBox(
                              width: 20,
                              height: 20,
                            ), // Placeholder to align
                        ],
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(time.year, time.month, time.day);

    if (date == today) {
      // Check if less than an hour ago
      final diff = now.difference(time);
      if (diff.inMinutes < 60) {
        return "${diff.inMinutes} min ago";
      }
      // Else show hours ago if less than 24h?
      // The image shows "2 min ago", "10 min ago", "1 hour ago", "3 hours ago" -- Relative time
      if (diff.inHours < 24) {
        if (diff.inHours == 1) return "1 hour ago";
        return "${diff.inHours} hours ago";
      }
    }

    final diff = now.difference(time);
    if (diff.inDays == 1 || (now.day - time.day == 1 && diff.inHours < 48)) {
      return "Yesterday";
    }
    if (diff.inDays < 7) {
      return "${diff.inDays} days ago";
    }

    return DateFormat.yMd().format(time); // Fallback
  }

  static const List<Color> _avatarColors = [
    Color(0xFF00C853), // Green (Alice)
    Color(0xFF00BFA5), // Teal (Bob)
    Color(0xFFFFD600), // Amber
    Color(0xFF6200EA), // Deep Purple
    Color(0xFF2962FF), // Blue
    Color(0xFFD50000), // Red
    Color(0xFFAA00FF), // Purple Accent
  ];
}
