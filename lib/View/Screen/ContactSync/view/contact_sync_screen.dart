import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/contact_sync_controller.dart';
import '../Data/DataSource/contact_sync_data_source.dart';
import '../Data/ApiService/contact_sync_api_service.dart';
import '../Data/Repository/contact_sync_repository.dart';

class ContactSyncScreen extends StatelessWidget {
  const ContactSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller with Clean Architecture dependencies
    final ContactSyncDataSource dataSource = ContactSyncDataSourceImpl();
    final ContactSyncApiService apiService = ContactSyncApiServiceImpl();
    final ContactSyncRepository repository = ContactSyncRepositoryImpl(
      dataSource: dataSource,
      apiService: apiService,
    );
    final controller = Get.put(ContactSyncController(repository: repository));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: Obx(() {
                  final state = controller.syncState.value;
                  if (state == ContactSyncState.success) {
                    return _buildSuccessView(context, controller);
                  } else if (state == ContactSyncState.error) {
                    return _buildErrorView(context, controller);
                  } else {
                    return _buildProgressView(context, controller);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
                ),
              ),
              Text(
                'Contact Sync',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 40), // Spacer matching back button size for center alignment
            ],
          ),
        ),
        Container(
          height: 1.h,
          width: double.infinity,
          color: Colors.white.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _buildProgressView(BuildContext context, ContactSyncController controller) {
    final state = controller.syncState.value;
    final isScanning = state == ContactSyncState.requestingPermission ||
        state == ContactSyncState.readingContacts ||
        state == ContactSyncState.uploading;

    // Calculate step states
    final step1State = _getStepState(1, state, controller.errorMessage.value);
    final step2State = _getStepState(2, state, controller.errorMessage.value);
    final step3State = _getStepState(3, state, controller.errorMessage.value);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          SizedBox(height: 50.h),
          
          // Scanning animation
          Center(
            child: RadarScanner(isScanning: isScanning),
          ),
          
          SizedBox(height: 60.h),
          
          Text(
            "Syncing Contacts",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Securely match your phone contacts to see who is on Bondi.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14.sp,
            ),
          ),
          
          SizedBox(height: 50.h),
          
          // Steps checklist
          _buildStepItem(
            title: "Contacts Permission",
            description: "Granting access to contacts",
            state: step1State,
          ),
          _buildStepItem(
            title: "Read & Clean Contacts",
            description: "Reading local contacts list and cleaning numbers",
            state: step2State,
          ),
          _buildStepItem(
            title: "Secure Sync",
            description: "Matching phone numbers on the server",
            state: step3State,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, ContactSyncController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: const BoxDecoration(
              color: Color(0xFF003366),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.accentColor,
              size: 80.sp,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            "Contacts Synced!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            "Successfully synced and matched ${controller.syncedCount.value} contacts with the database.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 60.h),
          SizedBox(
            width: double.infinity,
            height: 55.h,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.r),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, ContactSyncController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 80.sp,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            "Sync Failed",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade200,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: 60.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 55.h,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.r),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: SizedBox(
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.startContactSync();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.r),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  StepState _getStepState(int step, ContactSyncState currentState, String errMsg) {
    if (currentState == ContactSyncState.error) {
      // Find out which step failed
      if (errMsg.contains("Permission") || errMsg.contains("permission")) {
        return step == 1 ? StepState.failed : StepState.pending;
      }
      if (errMsg.contains("No contacts")) {
        return step == 1 ? StepState.completed : (step == 2 ? StepState.failed : StepState.pending);
      }
      // Otherwise, upload failed
      return step < 3 ? StepState.completed : StepState.failed;
    }

    switch (step) {
      case 1:
        if (currentState == ContactSyncState.requestingPermission) return StepState.running;
        if (currentState == ContactSyncState.idle) return StepState.pending;
        return StepState.completed;
      case 2:
        if (currentState == ContactSyncState.readingContacts) return StepState.running;
        if (currentState == ContactSyncState.uploading || currentState == ContactSyncState.success) {
          return StepState.completed;
        }
        return StepState.pending;
      case 3:
        if (currentState == ContactSyncState.uploading) return StepState.running;
        if (currentState == ContactSyncState.success) return StepState.completed;
        return StepState.pending;
      default:
        return StepState.pending;
    }
  }

  Widget _buildStepItem({
    required String title,
    required String description,
    required StepState state,
  }) {
    Color iconColor;
    Widget iconWidget;

    switch (state) {
      case StepState.pending:
        iconColor = Colors.white.withOpacity(0.3);
        iconWidget = Container(
          width: 24.r,
          height: 24.r,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 8.r,
              height: 8.r,
              decoration: const BoxDecoration(
                color: Color(0xFF000039), // Same as screen background color
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
        break;
      case StepState.running:
        iconColor = AppColors.accentColor;
        iconWidget = SizedBox(
          width: 24.r,
          height: 24.r,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(iconColor),
          ),
        );
        break;
      case StepState.completed:
        iconColor = Colors.green;
        iconWidget = Container(
          width: 24.r,
          height: 24.r,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: Colors.white, size: 16.sp),
        );
        break;
      case StepState.failed:
        iconColor = Colors.red;
        iconWidget = Container(
          width: 24.r,
          height: 24.r,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.close, color: Colors.white, size: 16.sp),
        );
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
          iconWidget,
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: state == StepState.pending ? Colors.white.withOpacity(0.5) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: state == StepState.pending ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.6),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum StepState { pending, running, completed, failed }

// Custom Painted Radar Scanner Widget for beautiful premium scanning look
class RadarScanner extends StatefulWidget {
  final bool isScanning;
  const RadarScanner({super.key, required this.isScanning});

  @override
  State<RadarScanner> createState() => _RadarScannerState();
}

class _RadarScannerState extends State<RadarScanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.isScanning) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(RadarScanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isScanning && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RadarPainter(_controller.value),
          child: SizedBox(
            width: 220.r,
            height: 220.r,
            child: Center(
              child: Container(
                width: 70.r,
                height: 70.r,
                decoration: const BoxDecoration(
                  color: AppColors.selectColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sync,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RadarPainter extends CustomPainter {
  final double value;
  RadarPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final double progress = (value + i / 3.0) % 1.0;
      final double radius = progress * maxRadius;
      final double opacity = 1.0 - progress;

      final paint = Paint()
        ..color = AppColors.accentColor.withOpacity(opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);

      final fillPaint = Paint()
        ..color = AppColors.accentColor.withOpacity(opacity * 0.05)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) => true;
}
