import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/group_model.dart';
import '../../../routes/app_router.dart';

class GroupManagementPage extends StatefulWidget {
  final String groupId; // Not used in this page, but kept for consistency
  final String conversationId;
  final String currentUserId;
  final bool isCurrentUserAdmin;

  const GroupManagementPage({
    super.key,
    required this.groupId,
    required this.conversationId,
    required this.currentUserId,
    required this.isCurrentUserAdmin,
  });

  @override
  State<GroupManagementPage> createState() => _GroupManagementPageState();
}

class _GroupManagementPageState extends State<GroupManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  static const String _baseUrl = 'http://10.10.13.27:8000/api/chat/conversations/';

  bool _isLoading = false;
  bool _isActionLoading = false;
  bool get _isCurrentUserAdmin => widget.isCurrentUserAdmin;
  String? _error;
  List<GroupMember> _members = [];
  List<GroupMember> _filteredMembers = [];
  String _groupName = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applySearch);
    _fetchGroupDetails();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applySearch() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredMembers = List.from(_members);
      } else {
        _filteredMembers = _members.where((m) {
          return m.name.toLowerCase().contains(q) ||
              m.email.toLowerCase().contains(q) ||
              m.children.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      debugPrint('[GroupManagementPage] Access token not found.');
      return null;
    }
    debugPrint('[GroupManagementPage] Retrieved token.');
    return token;
  }

  Future<void> _fetchGroupDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final token = await _getToken();
    if (token == null) {
      setState(() {
        _error = 'Authentication token missing. Please login again.';
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('$_baseUrl${widget.groupId}');
    debugPrint('[GroupManagementPage] Fetching group details from groupId ${widget.groupId}');
    debugPrint('[GroupManagementPage] Fetching group details from conversationId ${widget.conversationId}');
    debugPrint('[GroupManagementPage] Fetching group details from $url');

    try {
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      debugPrint('[GroupManagementPage] Response status: ${resp.statusCode}');
      debugPrint('[GroupManagementPage] Response body: ${resp.body}');

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);

        List membersJson = [];

        if (body is Map && body.containsKey('results')) {
          final results = body['results'] as Map<String, dynamic>;

          if (results.containsKey('conversation')) {
            final conversation = results['conversation'] as Map<String, dynamic>;

            _groupName = (conversation['name'] ?? '').toString();

            if (conversation.containsKey('participants')) {
              membersJson = conversation['participants'] as List<dynamic>;
            }
          }
        }

        // Map to GroupMember
        final fetchedMembers = membersJson.map<GroupMember>((m) {
          final id = (m['id'] ?? m['user_id'] ?? '').toString();
          final name = (m['name'] ?? m['full_name'] ?? m['username'] ?? '').toString();
          final email = (m['email'] ?? '').toString();
          final children = (m['children'] ?? '').toString();
          final imageUrl = (m['avatar'] ?? m['image_url'] ?? m['profile_image'] ?? m['profile_photo_url'] ?? '').toString();
          final roleStr = (m['role'] ?? '').toString().toLowerCase();
          final isAdmin = roleStr == 'admin';

          return GroupMember(
            id: id,
            name: name.isNotEmpty ? name : 'Unknown',
            email: email,
            children: children,
            imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
            role: isAdmin ? MemberRole.admin : MemberRole.member,
          );
        }).toList();

        setState(() {
          _members = fetchedMembers;
          _filteredMembers = List.from(_members);
          _isLoading = false;
        });

      } else {
        setState(() {
          _error = 'Failed to load group: ${resp.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching group: $e';
        _isLoading = false;
      });
      debugPrint('[GroupManagementPage] Error fetching group details: $e');
    }
  }

  Future<void> _addMembers() async {
    debugPrint('[GroupManagementPage] _addMembers() called');

    if (!widget.isCurrentUserAdmin) {
      debugPrint('[GroupManagementPage] User is not admin, cannot add members');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Only admins can add members.'))
      );
      return;
    }

    // Get existing member IDs to prevent re-adding
    final existingMemberIds = _members.map((member) => member.id).toList();

    // Use groupId as conversationId if conversationId is empty
    final conversationIdToUse = widget.conversationId.isNotEmpty ? widget.conversationId : widget.groupId;

    debugPrint('[GroupManagementPage] Navigating to AddMemberPage');
    debugPrint('[GroupManagementPage] GroupId: ${widget.groupId}');
    debugPrint('[GroupManagementPage] ConversationId: ${widget.conversationId}');
    debugPrint('[GroupManagementPage] ConversationIdToUse: $conversationIdToUse');
    debugPrint('[GroupManagementPage] CurrentUserId: ${widget.currentUserId}');
    debugPrint('[GroupManagementPage] ExistingMemberIds: $existingMemberIds');

    final result = await context.push(RoutePaths.addmemberpage, extra: {
      'conversationId': conversationIdToUse,
      'currentUserId': widget.currentUserId,
      'existingMemberIds': existingMemberIds,
    });

    debugPrint('[GroupManagementPage] Returned from AddMemberPage with result: $result');

    if (result == null || result is! List<String>) {
      debugPrint('[GroupManagementPage] No valid user IDs returned, aborting');
      return;
    }

    final userIds = result as List<String>;
    if (userIds.isEmpty) {
      debugPrint('[GroupManagementPage] No user IDs to add, aborting');
      return;
    }

    await _performAddMembers(userIds, conversationIdToUse);
  }

  Future<void> _performAddMembers(List<String> userIds, String conversationId) async {
    final token = await _getToken();
    if (token == null) {
      debugPrint('[GroupManagementPage] Token missing, cannot add members');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token missing.'))
      );
      return;
    }

    setState(() => _isActionLoading = true);

    final url = Uri.parse('$_baseUrl$conversationId/add-members/');
    debugPrint('[GroupManagementPage] Adding members to URL: $url');
    debugPrint('[GroupManagementPage] User IDs to add: $userIds');

    // Convert string IDs to integers for the API
    final userIdsAsInts = userIds.map((id) {
      final parsed = int.tryParse(id);
      debugPrint('[GroupManagementPage] Converting id "$id" to int: $parsed');
      return parsed ?? id;
    }).toList();

    final payload = {
      'user_ids': userIdsAsInts,
    };

    debugPrint('[GroupManagementPage] Request payload: ${jsonEncode(payload)}');

    try {
      final resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      debugPrint('[GroupManagementPage] Add members response status: ${resp.statusCode}');
      debugPrint('[GroupManagementPage] Add members response body: ${resp.body}');

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final responseData = jsonDecode(resp.body);

        // Parse the response to show detailed feedback
        final addedUsers = responseData['added_users'] as List<dynamic>? ?? [];
        final alreadyMembers = responseData['already_members'] as List<dynamic>? ?? [];

        String message = '';
        if (addedUsers.isNotEmpty) {
          message = 'Added ${addedUsers.length} member(s): ${addedUsers.join(', ')}';
        }
        if (alreadyMembers.isNotEmpty) {
          if (message.isNotEmpty) message += '\n';
          message += '${alreadyMembers.length} user(s) were already members: ${alreadyMembers.join(', ')}';
        }

        if (message.isEmpty) {
          message = 'Members processed successfully';
        }

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 4),
            )
        );

        // Refresh the group details to show new members
        await _fetchGroupDetails();
      } else {
        final errorMessage = resp.body.isNotEmpty ?
        'Failed to add members (${resp.statusCode}): ${resp.body}' :
        'Failed to add members (${resp.statusCode})';

        debugPrint('[GroupManagementPage] Failed to add members: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage))
        );
      }
    } catch (e) {
      debugPrint('[GroupManagementPage] Error adding members: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding members: $e'))
      );
    } finally {
      setState(() => _isActionLoading = false);
      debugPrint('[GroupManagementPage] _performAddMembers() finished');
    }
  }

  Future<void> _removeMember(GroupMember member) async {
    if (!widget.isCurrentUserAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Only admins can remove members.'))
      );
      return;
    }

    // Prevent removing yourself
    if (member.id == widget.currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You cannot remove yourself from the group.'))
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove ${member.name} from this group?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Cancel')
          ),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Remove', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final token = await _getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token missing.'))
      );
      return;
    }

    setState(() => _isActionLoading = true);
    final url = Uri.parse('$_baseUrl${widget.conversationId}/remove-member/');
    debugPrint('[GroupManagementPage] Removing member ${member.id} from $url');

    try {
      final resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': int.tryParse(member.id) ?? member.id}),
      );

      debugPrint('[GroupManagementPage] Remove member response status: ${resp.statusCode}');
      debugPrint('[GroupManagementPage] Remove member response body: ${resp.body}');

      if (resp.statusCode == 200 || resp.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${member.name} has been removed from the group.'))
        );
        await _fetchGroupDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove member: ${resp.statusCode}'))
        );
      }
    } catch (e) {
      debugPrint('[GroupManagementPage] Error removing member: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing member: $e'))
      );
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  Future<void> _promoteToAdmin(GroupMember member) async {
    if (!widget.isCurrentUserAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Only admins can promote members.')));
      return;
    }

    final token = await _getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication token missing.')));
      return;
    }

    setState(() => _isActionLoading = true);
    final url = Uri.parse('$_baseUrl${widget.conversationId}/promote-admin/');
    debugPrint('[GroupManagementPage] Promoting member ${member.id} to admin at $url');

    try {
      final resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': int.tryParse(member.id) ?? member.id}),
      );

      debugPrint('[GroupManagementPage] Promote response status: ${resp.statusCode}');
      debugPrint('[GroupManagementPage] Promote response body: ${resp.body}');

      if (resp.statusCode == 200 || resp.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${member.name} is now an admin.')));
        await _fetchGroupDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to promote member: ${resp.statusCode}')));
      }
    } catch (e) {
      debugPrint('[GroupManagementPage] Error promoting member: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error promoting member: $e')));
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  Future<void> _changeGroupName() async {
    if (!widget.isCurrentUserAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Only admins can change group name.')));
      return;
    }

    final controller = TextEditingController(text: _groupName);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Group Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new group name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isEmpty) return;
              Navigator.pop(context, val);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );

    if (newName == null || newName.trim().isEmpty || newName.trim() == _groupName) return;

    final token = await _getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication token missing.')));
      return;
    }

    setState(() => _isActionLoading = true);
    final url = Uri.parse('$_baseUrl${widget.conversationId}/');
    debugPrint('[GroupManagementPage] Changing group name to "$newName" at $url');

    try {
      final resp = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': newName}),
      );

      debugPrint('[GroupManagementPage] Change name response status: ${resp.statusCode}');
      debugPrint('[GroupManagementPage] Change name response body: ${resp.body}');

      if (resp.statusCode == 200) {
        setState(() {
          _groupName = newName;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Group name changed.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to change group name: ${resp.statusCode}')));
      }
    } catch (e) {
      debugPrint('[GroupManagementPage] Error changing group name: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error changing group name: $e')));
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  Widget _buildMemberTile(GroupMember member) {
    final isAdmin = member.role == MemberRole.admin;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: member.imageUrl != null && member.imageUrl!.isNotEmpty
              ? Image.network(member.imageUrl!).image
              : const AssetImage('assets/images/default_avatar.png'),
        ),

        title: Row(
          children: [
            Expanded(child: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isAdmin ? Colors.blue.shade50 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isAdmin ? 'Admin' : 'Member',
                style: TextStyle(
                  color: isAdmin ? Colors.blue.shade700 : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text('Children: ${member.children}\n${member.email}'),
        isThreeLine: true,
        tileColor: isAdmin ? Colors.blue.withOpacity(0.04) : null,
        trailing: _isCurrentUserAdmin
            ? PopupMenuButton<String>(
          onSelected: (v) async {
            if (v == 'chat') {
              context.push(RoutePaths.onetooneconversationpage,
                  extra: {'name': member.name, 'id': member.id});
            } else if (v == 'promote') {
              await _promoteToAdmin(member);
            } else if (v == 'remove') {
              await _removeMember(member);
            }
          },
          itemBuilder: (context) {
            final items = <PopupMenuEntry<String>>[
              const PopupMenuItem(value: 'chat', child: Text('Message')),
            ];
            if (!isAdmin) {
              items.add(const PopupMenuItem(
                  value: 'promote', child: Text('Promote to Admin')));
            }
            items.add(const PopupMenuItem(
                value: 'remove',
                child: Text('Remove', style: TextStyle(color: Colors.red))));
            return items;
          },
        )
            : null,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _fetchGroupDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_groupName.isNotEmpty ? '$_groupName' : 'Group Management',
        style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search members or children',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _applySearch();
                    },
                  )
                      : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Members (${_filteredMembers.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      if (widget.isCurrentUserAdmin)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: _isActionLoading ? null : _addMembers,
                            icon: const Icon(Icons.person_add),
                            label: const Text('Add'),
                          ),
                        ),
                      // FloatingActionButton.small(
                      //   onPressed: _isActionLoading
                      //       ? null
                      //       : () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('View More tapped'))),
                      //   child: const Icon(Icons.list),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!))
                  : _filteredMembers.isEmpty
                  ? const Center(child: Text('No members found.'))
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredMembers.length,
                itemBuilder: (context, idx) {
                  final member = _filteredMembers[idx];
                  return _buildMemberTile(member);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

