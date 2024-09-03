import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/dashboard_service.dart';
import 'package:amrny_seller/services/push_notification_service.dart';
import 'package:amrny_seller/services/recent_orders_service.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/home/chart_dashboard.dart';
import 'package:amrny_seller/view/home/components/home_cards.dart';
import 'package:amrny_seller/view/home/components/recent_orders.dart';
import 'package:amrny_seller/view/home/components/sidebar_drawer.dart';
import 'package:amrny_seller/view/home/components/subscription_badge.dart';
import 'package:amrny_seller/view/notification/push_notification_helper.dart';
import 'package:amrny_seller/view/profile/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/profile_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    runAtStart(context);
    initPusherBeams(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    setChatBuyerId(null);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? currentBackPressTime;

  //Notification alert
  //=================>
  initPusherBeams(BuildContext context) async {
    var pusherInstance =
        await Provider.of<PushNotificationService>(context, listen: false)
            .pusherInstance;

    if (pusherInstance == null) return;

    if (!kIsWeb) {
      await PusherBeams.instance
          .onMessageReceivedInTheForeground(_onMessageReceivedInTheForeground);
    }
    await _checkForInitialMessage(context);
    //init pusher instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');

    await PusherBeams.instance.addDeviceInterest('debug-seller$userId');
  }

  Future<void> _checkForInitialMessage(BuildContext context) async {
    final initialMessage = await PusherBeams.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotificationHelper().notificationAlert(
          context,
          asProvider.getString('Initial Message Is') + ':',
          initialMessage.toString());
    }
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    Map metaData = data["data"] is Map ? data["data"] as Map : {};
    if (metaData["type"] == "message" && metaData["sender-id"] == chatBuyerId) {
      return;
    }
    print(data);
    PushNotificationHelper().notificationAlert(
        context, data["title"].toString(), data["body"].toString());
  }

  bool isSeller(BuildContext context) {
    ProfileService profileEditProvider =
        Provider.of<ProfileService>(context, listen: false);
    return profileEditProvider.profileDetails != null &&
        profileEditProvider.profileDetails.userType == 0;
  }

  @override
  Widget build(BuildContext context) {
    //fetch data
    Provider.of<DashboardService>(context, listen: false).fetchData();
    Provider.of<RecentOrdersService>(context, listen: false)
        .fetchRecentOrders();

    ConstantColors cc = ConstantColors();
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: const SidebarDrawer(),
        body: Consumer<AppStringService>(
          builder: (context, ln, child) => WillPopScope(
            onWillPop: () {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = now;
                OthersHelper().showToast(
                    ln.getString("Press again to exit"), Colors.black);
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: SafeArea(
              child: SingleChildScrollView(
                physics: physicsCommon,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenPadding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //profile image and name ========>
                        // const NameImage(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 2, bottom: 12),
                                    child: Icon(
                                      Icons.menu,
                                      color: cc.greyFour,
                                    ))),
                            Consumer<ProfileService>(
                              builder: (context, profileProvider, child) =>
                                  profileProvider.profileDetails != null
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        const ProfilePage(),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                ln.getString('Welcome') + '!',
                                                style: TextStyle(
                                                  color: cc.greyParagraph,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                profileProvider
                                                        .profileDetails.name ??
                                                    '',
                                                style: TextStyle(
                                                  color: cc.greyFour,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                            )
                          ],
                        ),

                        sizedBoxCustom(16),
                        //subscription details
                        const SubscriptionBadge(),
                        sizedBoxCustom(5),

                        //Home cards
                        //==============>
                        const HomeCards(),

                        if (isSeller(context)) const SizedBox(height: 20),
                        if (isSeller(context)) const ChartDashboard(),

                        const SizedBox(
                          height: 20,
                        ),

                        //Recent orders
                        const RecentOrders(),
                        const SizedBox(
                          height: 30,
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
