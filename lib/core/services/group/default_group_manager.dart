import 'package:flutter/material.dart';
import '../../../data/models/default_group_model.dart';
import 'default_group_service.dart';

class DefaultGroupManager {
  final DefaultGroupService _service = DefaultGroupService();

  Future<List<DefaultGroup>> getDefaultGroups() async {
    return await _service.fetchDefaultGroups();
  }

  Future<bool> joinGroup(BuildContext context, DefaultGroup group) async {
    try {
      final response = await _service.joinGroup(group.id);
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Joined group successfully')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to join group')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining group: $e')),
      );
      return false;
    }
  }

  Future<bool> leaveGroup(BuildContext context, DefaultGroup group) async {
    try {
      final response = await _service.leaveGroup(group.id);
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Left group successfully')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to leave group')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error leaving group: $e')),
      );
      return false;
    }
  }
}