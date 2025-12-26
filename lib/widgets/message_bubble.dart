import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'avatar_bubble.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String senderName;
  final String time;
  final Function(String word)? onWordLongPress;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.senderName,
    required this.time,
    this.onWordLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final initials = senderName.isNotEmpty ? senderName[0].toUpperCase() : "?";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            AvatarBubble(
              initials: initials,
              radius: 16,
              backgroundColor: AppTheme.accentColor,
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? AppTheme.bubbleSelf : AppTheme.bubbleOther,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selectable word logic could go here, or just simple text for now
                  // To enable word selection, we can use SelectableText or RichText with recognizers
                  // For "Long press on any word", RichText with splitting by space is easiest way to detect word
                  _buildWordClickableText(context),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe ? Colors.white70 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isMe)
            AvatarBubble(
              initials: initials,
              radius: 16, // Smaller in bubble row
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.8),
            ),
        ],
      ),
    );
  }

  Widget _buildWordClickableText(BuildContext context) {
    // final words = text.split(RegExp(r'(\s+)')); // Split but keep delimiters if we want, or just space
    // Simple split by space
    final splitWords = text.split(' ');

    return Wrap(
      children: splitWords.map((word) {
        return GestureDetector(
          onLongPress: () {
            if (onWordLongPress != null) {
              onWordLongPress!(
                word.replaceAll(RegExp(r'[^\w\s]+'), ''),
              ); // Remove punctuation
            }
          },
          child: Text(
            "$word ",
            style: TextStyle(
              color: isMe ? Colors.white : AppTheme.textBody,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        );
      }).toList(),
    );
  }
}
