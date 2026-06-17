import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../../Messages/view/chat_detail_screen.dart';

class CreateGroupController extends GetxController {
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();
  final searchFriendsController = TextEditingController();
  final searchInBottomSheetController = TextEditingController();

  final selectedImage = Rxn<File>();
  final friendsList = <Map<String, dynamic>>[].obs;
  final selectedFriendIds = <String>{}.obs;
  final selectedFriends = <Map<String, dynamic>>[].obs;
  
  final isFriendsLoading = false.obs;
  final isSubmitting = false.obs;
  final searchFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriends();
    searchFriendsController.addListener(() {
      searchFilter.value = searchFriendsController.text;
    });
    searchInBottomSheetController.addListener(() {
      searchFilter.value = searchInBottomSheetController.text;
    });

    // Automatically trigger live API search whenever the search filter changes, with a 500ms debounce
    debounce(searchFilter, (String query) {
      fetchFriends(query: query);
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> fetchFriends({String query = ''}) async {
    isFriendsLoading.value = true;
    try {
      String url = '${ApiUrl.social}/friends';
      if (query.trim().isNotEmpty) {
        url += '?search=${Uri.encodeComponent(query.trim())}&q=${Uri.encodeComponent(query.trim())}';
      }
      final response = await ApiClient.get(url, requireAuth: true);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> list = body['data'];
          friendsList.assignAll(list.map((e) => Map<String, dynamic>.from(e)).toList());
        }
      }
    } catch (e) {
      print('Error fetching friends list: $e');
    } finally {
      isFriendsLoading.value = false;
    }
  }

  Future<void> pickGroupImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      print('Error picking group image: $e');
    }
  }

  List<Map<String, dynamic>> get filteredFriends {
    final filter = searchFilter.value.toLowerCase().trim();
    if (filter.isEmpty) return friendsList;
    return friendsList.where((friend) {
      final name = (friend['displayName'] ?? friend['username'] ?? '').toString().toLowerCase();
      return name.contains(filter);
    }).toList();
  }

  List<Map<String, String>> get invitedFriendsList {
    return selectedFriends
        .map((f) => {
              'id': (f['_id'] ?? f['id'] ?? '').toString(),
              'name': (f['displayName'] ?? f['username'] ?? 'User').toString(),
              'image': ImageHelper.formatImageUrl((f['profileImage'] ?? f['picture'] ?? '').toString()),
            })
        .toList();
  }

  void toggleFriendSelection(Map<String, dynamic> friend) {
    final id = (friend['_id'] ?? friend['id'] ?? '').toString();
    if (selectedFriendIds.contains(id)) {
      selectedFriendIds.remove(id);
      selectedFriends.removeWhere((element) => (element['_id'] ?? element['id'] ?? '').toString() == id);
    } else {
      selectedFriendIds.add(id);
      selectedFriends.add(friend);
    }
  }

  void addMember() {
    searchInBottomSheetController.clear();
    searchFilter.value = '';
    
    Get.bottomSheet(
      Container(
        height: 500.h,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // Premium dark theme matching background
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StaticString.inviteFriends,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 18.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Bottom Sheet Search Bar
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TextField(
                controller: searchInBottomSheetController,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: StaticString.searchFriendsHint,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5), size: 18.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                if (isFriendsLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.accentColor));
                }
                
                final list = filteredFriends;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No friends found.',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14.sp),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final friend = list[index];
                    final id = (friend['_id'] ?? friend['id'] ?? '').toString();
                    final name = friend['displayName'] ?? friend['username'] ?? 'User';
                    final img = ImageHelper.formatImageUrl((friend['profileImage'] ?? friend['picture'] ?? '').toString());

                    return Obx(() {
                      final isSelected = selectedFriendIds.contains(id);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 20.r,
                          backgroundImage: NetworkImage(img.isNotEmpty ? img : 'https://i.pravatar.cc/150?u=$name'),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          activeColor: AppColors.accentColor,
                          checkColor: Colors.black,
                          side: const BorderSide(color: Colors.white30),
                          onChanged: (_) => toggleFriendSelection(friend),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 15.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  StaticString.done,
                  style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> createGroup() async {
    final name = groupNameController.text.trim();
    final description = groupDescriptionController.text.trim();

    if (selectedImage.value == null) {
      Get.snackbar(
        StaticString.cancel,
        StaticString.groupImageRequired,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    if (name.isEmpty) {
      Get.snackbar(
        StaticString.cancel,
        StaticString.groupNameRequired,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      final fields = {
        'conversationType': 'GROUP',
        'groupName': name,
        'description': description,
        'participantIds': jsonEncode(selectedFriendIds.toList()),
        'isPublic': 'true',
      };

      print('Calling API POST ${ApiUrl.conversation}');
      print('Payload fields: $fields');
      print('Payload files: groupImage: ${selectedImage.value!.path}');

      List<http.MultipartFile> files = [];
      files.add(await http.MultipartFile.fromPath('groupImage', selectedImage.value!.path));

      final response = await ApiClient.multipartPost(
        ApiUrl.conversation,
        fields,
        files: files,
        requireAuth: true,
      );

      final responseData = await http.Response.fromStream(response);
      print('Create Group API response status: ${response.statusCode}');
      print('Create Group API response body: ${responseData.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseData.body);
        if (data['success'] == true && data['data'] != null) {
          final conversationId = data['data']['_id'] ?? '';
          final groupImageRemote = ImageHelper.formatImageUrl(data['data']['groupImage']?.toString() ?? '');

          Get.off(
            () => const ChatDetailScreen(),
            arguments: {
              'conversationId': conversationId,
              'conversationType': 'group',
              'isGroup': true,
              'name': name,
              'image': groupImageRemote,
            },
          );

          Get.snackbar(
            StaticString.done,
            StaticString.groupCreatedSuccessfully,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.9),
            colorText: Colors.white,
          );
          return;
        }
      }

      String errorMsg = StaticString.failedToCreateGroup;
      try {
        final data = jsonDecode(responseData.body);
        if (data is Map && data['message'] != null) {
          errorMsg = data['message'].toString();
        } else if (responseData.body.isNotEmpty) {
          errorMsg = responseData.body;
        }
      } catch (_) {
        errorMsg = 'Server Error (${response.statusCode}): ${responseData.body}';
      }

      Get.snackbar(
        StaticString.cancel,
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      print('Exception during createGroup: $e');
      Get.snackbar(
        StaticString.cancel,
        '${StaticString.failedToCreateGroup}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    groupNameController.dispose();
    groupDescriptionController.dispose();
    searchFriendsController.dispose();
    searchInBottomSheetController.dispose();
    super.onClose();
  }
}
