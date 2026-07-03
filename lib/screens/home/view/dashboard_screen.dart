import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_design/config/app_string.dart';
import 'package:todo_design/config/app_theme.dart';
import 'package:todo_design/extensions/ext_on_num.dart';
import 'package:todo_design/extensions/ext_on_widget.dart';
import 'package:todo_design/screens/home/controller/dashboard_controller.dart';
import 'package:todo_design/screens/home/widget/complete_task_widget.dart';
import 'package:todo_design/screens/home/widget/drawer_widget.dart';
import 'package:todo_design/screens/home/widget/incomplete_task_widget.dart';
import 'package:todo_design/screens/home/widget/task_all.dart';
import 'package:todo_design/screens/home/widget/task_dialog_widget.dart';
import 'package:todo_design/utils/responsive.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard>
    with TickerProviderStateMixin {
  late final TabController tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppDimensions.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.appWhite,
      drawer: responsive.showsSidebar ? null : const MyDrawer(),
      drawerScrimColor: AppColors.white.withAlpha(60),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTaskDialog(
          context,
          onSubmit: dashboardController.addTask,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: Text(
          AppString.createTask,
          style: AppTextStyle.small.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: responsive.showsSidebar
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerFloat,
      body: Obx(
        () => Row(
          children: [
            if (responsive.showsSidebar)
              const SizedBox(
                width: 320,
                child: MyDrawer(embedded: true),
              ),
            Expanded(
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Padding(
                      padding: responsive.pagePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Header(
                            showMenuButton: !responsive.showsSidebar,
                            onMenuTap: () =>
                                scaffoldKey.currentState?.openDrawer(),
                          ),
                          24.height,
                          _buildTabs(tabController, responsive),
                          12.height,
                          _buildTabView(tabController),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ).appLoading(
          isLoading: dashboardController.isLoading.value,
        ),
      ),
    );
  }
}

Widget _buildTabView(TabController tabController) {
  return Expanded(
    child: TabBarView(
      controller: tabController,
      children: const [
        AllTask(),
        CompleteTaskWidget(),
        IncompleteTaskWidget(),
      ],
    ),
  );
}

Widget _buildTabs(TabController tabController, AppDimensions responsive) {
  return TabBar(
    controller: tabController,
    tabs: const [
      Tab(text: AppString.all),
      Tab(text: AppString.complete),
      Tab(text: AppString.incomplete),
    ],
    indicator: UnderlineTabIndicator(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: AppColors.primary, width: 4),
    ),
    indicatorColor: AppColors.primary,
    indicatorWeight: 2,
    indicatorPadding: const EdgeInsets.only(bottom: 2),
    dividerHeight: 0,
    tabAlignment: responsive.isMobile ? TabAlignment.start : TabAlignment.fill,
    labelStyle: AppTextStyle.small.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.textSecondary,
    isScrollable: responsive.isMobile,
  );
}

class _Header extends StatelessWidget {
  const _Header({
    required this.showMenuButton,
    required this.onMenuTap,
  });

  final bool showMenuButton;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showMenuButton)
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu_rounded),
          ),
          const SizedBox(width: 8),
        const Expanded(
          child: Text(
            AppString.hello,
            style: AppTextStyle.headline,
          ),
        ),
      ],
    );
  }
}
