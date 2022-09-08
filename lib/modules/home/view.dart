import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:intl/intl.dart';
import 'package:t_save_sp/controller/fcm_controller.dart';
import '../../controller/general_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_drawer.dart';
// import '../order_detail/view.dart';
// import '../product_detail/view.dart';
import 'logic.dart';
import 'state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;
  final _generalController = Get.find<GeneralController>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    Get.find<HomeLogic>().updateToken();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('apear--->>>');
    Get.find<HomeLogic>().currentShop();
  }

  TabController? tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      body: Stack(
        children: [
          ///---gradient
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                customThemeColor.withOpacity(0.3),
                customThemeColor.withOpacity(0.8),
                customThemeColor
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )),
          ),

          ///---main
          GetBuilder<HomeLogic>(
            builder: (_homeLogic) => AdvancedDrawer(
              disabledGestures: false,
              backdropColor: Colors.transparent,
              controller: _homeLogic.advancedDrawerController,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              childDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              drawer: const MyCustomDrawer(),
              child: GestureDetector(
                onTap: () {
                  _generalController.focusOut(context);
                },
                child: Scaffold(
                  drawerEnableOpenDragGesture: false,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    leading: InkWell(
                      onTap: () {
                        _homeLogic.handleMenuButtonPressed();
                      },
                      child: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: _homeLogic.advancedDrawerController,
                        builder: (_, value, __) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
                            child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: value.visible
                                    ? const Icon(
                                        Icons.arrow_back,
                                        size: 25,
                                        color: customTextColor,
                                      )
                                    : SvgPicture.asset(
                                        'assets/drawerIcon.svg')),
                          );
                        },
                      ),
                    ),
                  ),
                  body: _homeLogic.currentShopData == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: customThemeColor,
                          ),
                        )
                      : ListView(
                          controller: _homeLogic.scrollController,
                          children: [
                            ///---heading
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 20, 0, 0),
                                child: Text(
                                    "${_homeLogic.currentShopData!.get('name')}",
                                    style: state.homeHeadingTextStyle)),

                            ///---rating
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                              child: Container(
                                height: 57,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(19),
                                  boxShadow: [
                                    BoxShadow(
                                      color: customThemeColor.withOpacity(0.19),
                                      blurRadius: 40,
                                      spreadRadius: 0,
                                      offset: const Offset(
                                          0, 22), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'My Ratings',
                                          style: state.listTileTitleTextStyle,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: customThemeColor,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        _homeLogic.averageRating!
                                            .toStringAsPrecision(2),
                                        style: state.listTileSubTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            const Center(
                              child: const Text(
                                'All Bookings',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),

                            ///---tables-list
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('booking')
                                    .orderBy('date_time', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    log('Waiting');
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 15, 18, 5),
                                      child: SizedBox(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    );
                                  } else if (snapshot.hasData) {
                                    if (snapshot.data!.docs.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 30),
                                        child: Text(
                                          'Record not found',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    } else {
                                      return FadedSlideAnimation(
                                        beginOffset: const Offset(0.3, 0.2),
                                        endOffset: const Offset(0, 0),
                                        slideCurve: Curves.linearToEaseOut,
                                        child: Wrap(
                                          children: List.generate(
                                              snapshot.data!.docs.length,
                                              (index) {
                                            if (snapshot.data!.docs[index]
                                                    .get('shop') ==
                                                _homeLogic.currentShopData!
                                                    .get('name')) {
                                              DateTime dt = (snapshot
                                                          .data!.docs[index]
                                                          .get('date_time')
                                                      as Timestamp)
                                                  .toDate();
                                              // var orderReference = snapshot
                                              //     .data!.docs[index]
                                              //     .get('orderReference')
                                              //     .toString();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 30, 15, 0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            19),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Column(
                                                      children: [
                                                        ///---image
                                                        Hero(
                                                          tag:
                                                              '${snapshot.data!.docs[index].get('shop_image')}',
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Container(
                                                              height: 80,
                                                              width: 80,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40),
                                                                child: Image
                                                                    .network(
                                                                  '${snapshot.data!.docs[index].get('shop_image')}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .01,
                                                                ),

                                                                ///---Booking Time
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                          'Booking Time',
                                                                          softWrap:
                                                                              true,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style:
                                                                              state.nameTextStyle),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child: Text(
                                                                            DateFormat('dd-MM-yy').format(
                                                                                dt),
                                                                            style:
                                                                                state.otpTextStyle),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .01,
                                                                ),

                                                                ///---Booking Start
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                          'Booking Start',
                                                                          softWrap:
                                                                              true,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style:
                                                                              state.nameTextStyle),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child: Text(
                                                                            DateTime.fromMicrosecondsSinceEpoch(snapshot.data!.docs[index].get('bookingStart')).toString().substring(0,
                                                                                16),
                                                                            style:
                                                                                state.otpTextStyle),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .03,
                                                                ),

                                                                ///---Phone
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                          'Phone',
                                                                          softWrap:
                                                                              true,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style:
                                                                              state.nameTextStyle),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child: Text(
                                                                            snapshot.data!.docs[index].get(
                                                                                'Customerphone'),
                                                                            style:
                                                                                state.otpTextStyle),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .03,
                                                                ),

                                                                ///---Problem
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        'Problem',
                                                                        softWrap:
                                                                            true,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: state
                                                                            .nameTextStyle),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        child: Text(snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .get('problem'))),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .03,
                                                                ),

                                                                ///---Status
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    snapshot.data!.docs[index].get('status') ==
                                                                            'Complete'
                                                                        ? const SizedBox()
                                                                        : Expanded(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                showAnimatedDialog(
                                                                                    animationType: DialogTransitionType.size,
                                                                                    curve: Curves.fastOutSlowIn,
                                                                                    duration: const Duration(seconds: 1),
                                                                                    context: context,
                                                                                    builder: (ctx) {
                                                                                      return AlertDialog(
                                                                                        title: const Text("Alert"),
                                                                                        content: const Text("Do your realy want to cancel the booking"),
                                                                                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        actions: [
                                                                                          ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(backgroundColor: customThemeColor),
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: const Text("No")),
                                                                                          ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(backgroundColor: customThemeColor),
                                                                                              onPressed: () {
                                                                                                snapshot.data!.docs[index].reference.delete();
                                                                                                Get.back();
                                                                                              },
                                                                                              child: const Text("Yes")),
                                                                                        ],
                                                                                      );
                                                                                    });
                                                                              },
                                                                              child: Align(
                                                                                alignment: Alignment.center,
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(19), color: customThemeColor),
                                                                                  child: const Padding(
                                                                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                                    child: Center(child: Text('Cancel')),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),

                                                                    ///---button
                                                                    snapshot.data!.docs[index].get('status') ==
                                                                            'Pending'
                                                                        ? Expanded(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () async {
                                                                                FirebaseFirestore.instance.collection('booking').doc(snapshot.data!.docs[index].id).update({
                                                                                  'status': 'Accepted'
                                                                                });
                                                                                var uid = snapshot.data!.docs[index].get('uid');
                                                                                FirebaseFirestore.instance.collection('users').doc(uid).get().then((userDoc) {
                                                                                  var token = userDoc.get('token');
                                                                                  print('token--- $token');
                                                                                  sendNotificationCall(token, 'Alert!', 'your request hass been accepted');
                                                                                });
                                                                                // QuerySnapshot query = await FirebaseFirestore.instance.collection('orders').get();
                                                                                // if (query.docs.isNotEmpty) {
                                                                                //   query.docs.forEach((element) {
                                                                                //     if (element.id == snapshot.data!.docs[index].id) {
                                                                                //       widget.orderModel = element;
                                                                                //       setState(() {});
                                                                                //     }
                                                                                //   });
                                                                                // }

                                                                                // QuerySnapshot queryForUser = await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: widget.orderModel!.get('uid')).get();
                                                                                // sendNotificationCall(queryForUser.docs[0].get('token'), 'Oreder ALERT !!', 'Choice! ${widget.orderModel!.get('shop')} has accepted your order and has it ready for you to collect!');
                                                                              },
                                                                              child: Container(
                                                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),

                                                                                // height: 70,
                                                                                // width: MediaQuery.of(context).size.width,
                                                                                decoration: BoxDecoration(color: customThemeColor, borderRadius: BorderRadius.circular(30)),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'Click to Accept',
                                                                                    style: state.priceTextStyle,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),

                                                                    snapshot.data!.docs[index].get('status') ==
                                                                            'Accepted'
                                                                        ? Expanded(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () async {
                                                                                // biteCodeDialog(context);
                                                                                int startingTime = snapshot.data!.docs[index].get('bookingStart');
                                                                                if (startingTime <= DateTime.now().microsecondsSinceEpoch) {
                                                                                  FirebaseFirestore.instance.collection('booking').doc(snapshot.data!.docs[index].id).update({
                                                                                    'status': 'Complete'
                                                                                  });
                                                                                  var uid = snapshot.data!.docs[index].get('uid');
                                                                                  FirebaseFirestore.instance.collection('users').doc(uid).get().then((userDoc) {
                                                                                    var token = userDoc.get('token');
                                                                                    print('token--- $token');
                                                                                    sendNotificationCall(token, 'Alert!', 'your service has been completed');
                                                                                  });
                                                                                } else {
                                                                                  Get.snackbar('', 'Completed after appointment time');
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                                decoration: BoxDecoration(color: customThemeColor, borderRadius: BorderRadius.circular(30)),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'Mark as Complete',
                                                                                    style: state.priceTextStyle,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                    snapshot.data!.docs[index].get('status') ==
                                                                            'Complete'
                                                                        ? Expanded(
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                              decoration: BoxDecoration(color: customTextColor, borderRadius: BorderRadius.circular(30)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'Completed Successfully',
                                                                                  style: state.priceTextStyle,
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),

                                                                    // Expanded(
                                                                    //   child:
                                                                    //       Align(
                                                                    //     alignment:
                                                                    //         Alignment.center,
                                                                    //     child:
                                                                    //         Container(
                                                                    //       decoration: BoxDecoration(
                                                                    //           borderRadius: BorderRadius.circular(19),
                                                                    //           color: customThemeColor),
                                                                    //       child:
                                                                    //           Padding(
                                                                    //         padding: const EdgeInsets.fromLTRB(
                                                                    //             0,
                                                                    //             10,
                                                                    //             0,
                                                                    //             10),
                                                                    //         child: snapshot.data!.docs[index].get('status') == 'Pending'
                                                                    //             ? GestureDetector(
                                                                    //                 onTap: () {
                                                                    //                   snapshot.data!.docs[index].reference.update({
                                                                    //                     'status': 'Booking Confirmed'
                                                                    //                   });
                                                                    //                 },
                                                                    //                 child: Center(
                                                                    //                   child: Text('Accept Booking', style: state.priceTextStyle!.copyWith(color: Colors.white)),
                                                                    //                 ),
                                                                    //               )
                                                                    //             : const Center(child: Text('Booking Confirmed')),
                                                                    //       ),
                                                                    //     ),
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          }),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Text(
                                      'Record not found',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    );
                                  }
                                }),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
