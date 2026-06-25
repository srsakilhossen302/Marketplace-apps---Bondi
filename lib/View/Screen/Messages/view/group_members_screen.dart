import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../Controller/group_members_controller.dart';

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> args = Get.arguments ?? {};
    final String conversationId = args['conversationId'] ?? '';
    final String groupName = args['groupName'] ?? 'Group';

    final controller = Get.put(GroupMembersController(conversationId: conversationId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "$groupName Members",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.accentColor,
            labelColor: AppColors.accentColor,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            tabs: const [
              Tab(text: "Members"),
              Tab(text: "Pending Requests"),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.backgroundColor,
          child: Obx(() {
            if (controller.isLoading.value && controller.participants.isEmpty && controller.pendingParticipants.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              );
            }
            return TabBarView(
              children: [
                _buildMembersTab(controller),
                _buildPendingRequestsTab(controller),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMembersTab(GroupMembersController controller) {
    if (controller.participants.isEmpty) {
      return Center(
        child: Text(
          "No members in this group.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14.sp,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: controller.participants.length,
      itemBuilder: (context, index) {
        final member = controller.participants[index];
        final String memberId = member['_id'] ?? '';
        final String fullName = member['fullName'] ?? member['username'] ?? 'User';
        final String username = member['username'] ?? '';
        final String rawImg = member['profileImage'] ?? member['picture'] ?? '';
        final String image = ImageHelper.formatImageUrl(rawImg);
        final bool isAdmin = controller.adminIds.contains(memberId);

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: image.startsWith('http') ? NetworkImage(image) : null,
                backgroundColor: Colors.white.withOpacity(0.1),
                child: image.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          fullName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isAdmin) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              "Admin",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (username.isNotEmpty)
                      Text(
                        "@$username",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPendingRequestsTab(GroupMembersController controller) {
    if (controller.pendingParticipants.isEmpty) {
      return Center(
        child: Text(
          "No pending requests.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14.sp,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: controller.pendingParticipants.length,
      itemBuilder: (context, index) {
        final pending = controller.pendingParticipants[index];
        final String pendingId = pending['_id'] ?? '';
        final String fullName = pending['fullName'] ?? pending['username'] ?? 'User';
        final String username = pending['username'] ?? '';
        final String rawImg = pending['profileImage'] ?? pending['picture'] ?? '';
        final String image = ImageHelper.formatImageUrl(rawImg);

        return Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage: image.startsWith('http') ? NetworkImage(image) : null,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    child: image.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (username.isNotEmpty)
                          Text(
                            "@$username",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.cancelJoinRequest(pendingId, fullName),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.acceptJoinRequest(pendingId, fullName),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        "Accept",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
