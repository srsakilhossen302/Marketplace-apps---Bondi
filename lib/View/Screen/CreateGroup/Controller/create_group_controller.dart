import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController {
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();
  final searchFriendsController = TextEditingController();

  final invitedMembers = <Map<String, String>>[
    {
      'name': 'Alex',
      'image': 'https://i.pravatar.cc/150?u=alex',
    },
    {
      'name': 'Jordan',
      'image': 'https://i.pravatar.cc/150?u=jordan',
    },
  ].obs;

  void addMember() {
    // Logic to add more members
  }

  void createGroup() {
    // Logic to create group
  }

  @override
  void onClose() {
    groupNameController.dispose();
    groupDescriptionController.dispose();
    searchFriendsController.dispose();
    super.onClose();
  }
}
