import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/common_providers/auth_provider.dart';
import 'package:circleslate/presentation/routes/app_router.dart';

import '../../../../core/services/group/default_group_manager.dart';
import '../../../../data/models/default_group_model.dart';


class JoinGroupsSection extends StatefulWidget {
  const JoinGroupsSection({super.key});

  @override
  State<JoinGroupsSection> createState() => _JoinGroupsSectionState();
}

class _JoinGroupsSectionState extends State<JoinGroupsSection> {
  List<DefaultGroup> _defaultGroups = [];
  bool _loadingGroups = true;
  final DefaultGroupManager _groupManager = DefaultGroupManager();

  @override
  void initState() {
    super.initState();
    _fetchDefaultGroups();
  }

  Future<void> _fetchDefaultGroups() async {
    setState(() {
      _loadingGroups = true;
    });

    try {
      final groups = await _groupManager.getDefaultGroups();
      setState(() {
        _defaultGroups = groups;
      });
    } catch (e) {
      debugPrint('Error fetching default groups: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching groups: $e')),
      );
    } finally {
      setState(() {
        _loadingGroups = false;
      });
    }
  }

  Future<void> _handleGroupSelection(DefaultGroup group, bool join) async {
    try {
      bool success;
      if (join) {
        success = await _groupManager.joinGroup(context, group);
      } else {
        success = await _groupManager.leaveGroup(context, group);
      }
      if (success) {
        setState(() {
          group.isMember = join;
        });
      }
    } catch (e) {
      debugPrint('Error handling group selection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font sizes
    final double sectionTitleFontSize = screenWidth * 0.04;
    final double groupSelectionHintFontSize = screenWidth * 0.025;
    final double groupNameFontSize = screenWidth * 0.038;

    // Responsive spacing
    final double extraSmallSpacing = screenWidth * 0.02;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join Groups *',
          style: TextStyle(
            fontSize: sectionTitleFontSize,
            fontWeight: FontWeight.w500,
            color: AppColors.textColorPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          "Select one or more groups you'd like to join",
          style: TextStyle(
            fontSize: groupSelectionHintFontSize,
            fontWeight: FontWeight.w400,
            color: const Color(0x991B1D2A),
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: extraSmallSpacing),
        _loadingGroups
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: screenWidth / (screenWidth * 0.3),
            crossAxisSpacing: screenWidth * 0.025,
            mainAxisSpacing: screenWidth * 0.025,
          ),
          itemCount: _defaultGroups.length,
          itemBuilder: (context, index) {
            final group = _defaultGroups[index];
            return GestureDetector(
              onTap: group.isMember
                  ? () {
                context.push(
                  RoutePaths.groupConversationPage,
                  extra: {
                    'groupName': group.name,
                    'isGroupChat': true,
                    'isCurrentUserAdminInGroup': true,
                    'currentUserId': context.read<AuthProvider>().currentUserId,
                    'conversationId': group.conversationId,
                    'groupId': group.id.toString(),
                  },
                );
              }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: group.isMember ? AppColors.primaryBlue.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  border: Border.all(
                    color: group.isMember ? AppColors.primaryBlue : AppColors.inputOutline,
                    width: 1.0,
                  ),
                ),
                child: CheckboxListTile(
                  title: Text(
                    group.name,
                    style: TextStyle(
                      color: group.isMember ? AppColors.primaryBlue : AppColors.textColorPrimary,
                      fontFamily: 'Poppins',
                      fontSize: groupNameFontSize,
                    ),
                  ),
                  value: group.isMember,
                  onChanged: (bool? newValue) {
                    _handleGroupSelection(group, newValue!);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primaryBlue,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}