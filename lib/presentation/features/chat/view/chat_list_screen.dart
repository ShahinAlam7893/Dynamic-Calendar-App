import 'dart:convert';
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/user_search_service.dart';
import '../../../../data/models/user_search_result_model.dart';
import '../conversation_service.dart';

enum ChatMessageStatus { sent, delivered, seen }

class Chat {
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrl;
  final int unreadCount;
  final bool isOnline;
  final ChatMessageStatus status;
  final bool isGroupChat;
  final bool? isCurrentUserAdminInGroup;
  final List<dynamic> participants; // Add this to hold participants info

  const Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    this.status = ChatMessageStatus.seen,
    this.isGroupChat = false,
    this.isCurrentUserAdminInGroup,
    this.participants = const [],
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    final lastMsg = json['last_message'];
    final participants = json['participants'] as List<dynamic>? ?? [];
    final firstParticipant = participants.isNotEmpty ? participants[0] : null;
    return Chat(
      name: json['display_name'] ?? 'Unknown',
      lastMessage: lastMsg != null ? lastMsg['content'] ?? '' : '',
      time: lastMsg != null ? lastMsg['timestamp'] ?? '' : '',
      imageUrl: 'assets/images/default_user.png',
      unreadCount: json['unread_count'] ?? 0,
      isOnline: firstParticipant != null ? firstParticipant['is_online'] ?? false : false,
      status: ChatMessageStatus.seen,
      isGroupChat: json['is_group'] ?? false,
      isCurrentUserAdminInGroup: json['user_role'] == 'admin',
      participants: participants,
    );
  }
}

class ChatListPage extends StatefulWidget {
  final String currentUserId;

  const ChatListPage({super.key, required this.currentUserId});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserSearchResult> _userSearchResults = [];
  List<Chat> _userList = [];
  final UserSearchService _userSearchService = UserSearchService();
  bool _isSearching = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    // Fetch chat list via HTTP API
    print('ChatListPage currentUserId: ${widget.currentUserId}');
    ChatService.fetchChats().then((chatList) {
      setState(() {
        _userList = chatList;
      });
    }).catchError((e) {
      debugPrint('Error loading chat list: $e');
    });

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _userSearchResults.clear();
        _isSearching = false;
        _searchError = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    _performSearch(query);
  }

  void _performSearch(String query) async {
    try {
      final results = await _userSearchService.searchUsers(query);
      if (mounted) {
        setState(() {
          _userSearchResults = results;
          _isSearching = false;
          _searchError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userSearchResults.clear();
          _isSearching = false;
          _searchError = 'Search failed: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _userSearchService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearchMode = _searchController.text.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context.push('/group_chat');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create Group Tapped!')),
              );
            },
            child: const Text(
              'Create Group',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: const TextStyle(
                    color: AppColors.textColorSecondary, fontFamily: 'Poppins'),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textColorPrimary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          // Content area
          Expanded(
            child: isSearchMode ? _buildSearchResults() : _buildChatList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchError!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _performSearch(_searchController.text.trim()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_userSearchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _userSearchResults.length,
      itemBuilder: (context, index) {
        final user = _userSearchResults[index];
        return _buildUserSearchItem(context, user);
      },
    );
  }

  Widget _buildUserSearchItem(BuildContext context, UserSearchResult user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: user.profilePhotoUrl != null
                  ? NetworkImage(user.profilePhotoUrl!)
                  : const AssetImage(AppAssets.johnProfile) as ImageProvider,
            ),
            if (user.isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
            fontFamily: 'Poppins',
          ),
        ),
        subtitle: Text(
          user.email,
          style: const TextStyle(
            fontSize: 14.0,
            color: AppColors.textColorSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        trailing: Icon(
          user.isOnline ? Icons.circle : Icons.circle_outlined,
          color: user.isOnline ? Colors.green : Colors.grey,
          size: 12,
        ),
        onTap: () {
          // Navigate to chat with this user
          context.push(
            RoutePaths.onetooneconversationpage,
            extra: {
              'chatPartnerName': user.fullName,
              'chatPartnerId': user.id.toString(),
              'currentUserId': widget.currentUserId, // Use widget's currentUserId
              'isGroupChat': false,
              'isCurrentUserAdminInGroup': false,
            },
          );
        },
      ),
    );
  }

  Widget _buildChatList() {
    if (_userList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No active chats',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        final chat = _userList[index];
        return _buildChatItem(context, chat);
      },
    );
  }

  Widget _buildChatItem(BuildContext context, Chat chat) {
    return GestureDetector(
      onTap: () {
        // For one-to-one chat, get current user ID and partner ID from participants
        if (!chat.isGroupChat && chat.participants.isNotEmpty) {
          final partner = chat.participants.firstWhere(
                (p) => p['id'].toString() != widget.currentUserId,
            orElse: () => null,
          );

          if (partner == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chat partner not found')),
            );
            return;
          }

          context.push(
            RoutePaths.onetooneconversationpage,
            extra: {
              'chatPartnerName': chat.name,
              'chatPartnerId': partner['id'].toString(),
              'currentUserId': widget.currentUserId,
              'isGroupChat': false,
              'isCurrentUserAdminInGroup': false,
              'conversationId': chat.name, // Optionally add conversation id if you have one
            },
          );
        } else {
          // For group chat, just pass group info
          context.push(
            RoutePaths.onetooneconversationpage,
            extra: {
              'chatPartnerName': chat.name,
              'isGroupChat': true,
              'isCurrentUserAdminInGroup': chat.isCurrentUserAdminInGroup ?? false,
              'currentUserId': widget.currentUserId,
              // You can add more group-specific info here
            },
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: Image.asset(
                      chat.imageUrl,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person),
                    ).image,
                  ),
                ],
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        if (chat.isGroupChat)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.group,
                              size: 12,
                              color: AppColors.textColorSecondary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      chat.lastMessage,
                      style: TextStyle(
                        fontSize: 9.0,
                        color: chat.unreadCount > 0
                            ? AppColors.textColorPrimary
                            : AppColors.textColorSecondary,
                        fontWeight: chat.unreadCount > 0
                            ? FontWeight.w500
                            : FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        chat.time,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      if (chat.status == ChatMessageStatus.sent)
                        Icon(Icons.check,
                            size: 14, color: AppColors.textColorSecondary),
                      if (chat.status == ChatMessageStatus.delivered)
                        Row(
                          children: const [
                            Icon(Icons.check,
                                size: 14, color: AppColors.textColorSecondary),
                            Icon(Icons.check,
                                size: 14, color: AppColors.textColorSecondary),
                          ],
                        ),
                      if (chat.status == ChatMessageStatus.seen)
                        Row(
                          children: const [
                            Icon(Icons.check,
                                size: 12, color: AppColors.primaryBlue),
                            Icon(Icons.check,
                                size: 12, color: AppColors.primaryBlue),
                          ],
                        ),
                    ],
                  ),
                  if (chat.unreadCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: AppColors.unreadCountBg,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          chat.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
