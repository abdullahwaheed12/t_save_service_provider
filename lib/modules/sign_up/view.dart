// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:intl/intl.dart' as intl;

import '../../controller/general_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_dialog.dart';

import 'logic.dart';
import 'state.dart';
import 'view_map.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignUpLogic logic = Get.find<SignUpLogic>();
  final SignUpState state = Get.find<SignUpLogic>().state;

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  bool obscureText = true;
  final timeFormat = intl.DateFormat.jm();
  // List of items in our dropdown menu

  @override
  void initState() {
    super.initState();
    Get.find<SignUpLogic>().requestLocationPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpLogic>(
      builder: (_signUpLogic) =>
          GetBuilder<GeneralController>(builder: (_generalController) {
        return GestureDetector(
          onTap: () {
            Get.find<GeneralController>().focusOut(context);
          },
          child: ModalProgressHUD(
            inAsyncCall: _generalController.formLoader!,
            progressIndicator: const CircularProgressIndicator(
              color: customThemeColor,
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        //profile image
                        Column(
                          children: [
                            ///---image
                            InkWell(
                              onTap: () {
                                imagePickerDialog(context, isYourImage: true);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .2,
                                decoration: BoxDecoration(
                                    color: customTextColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: _signUpLogic.profile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _signUpLogic.profile!,
                                          fit: BoxFit.cover,
                                        ))
                                    : const Icon(
                                        Icons.add_a_photo,
                                        color: customThemeColor,
                                        size: 25,
                                      ),
                              ),
                            ),
                            Text(
                              'Profile image',
                              style: state.labelTextStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //back-front-id image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                ///---image
                                InkWell(
                                  onTap: () {
                                    imagePickerDialog(context, isIdBack: true);
                                  },
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height * .1,
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                    decoration: BoxDecoration(
                                        color: customTextColor.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: _signUpLogic.fileIdBack != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              _signUpLogic.fileIdBack!,
                                              fit: BoxFit.cover,
                                            ))
                                        : const Icon(
                                            Icons.add_a_photo,
                                            color: customThemeColor,
                                            size: 25,
                                          ),
                                  ),
                                ),
                                Text(
                                  'id back Image',
                                  style: state.labelTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ///---id-front-image
                                InkWell(
                                  onTap: () {
                                    imagePickerDialog(context, isIdFront: true);
                                  },
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height * .1,
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                    decoration: BoxDecoration(
                                        color: customTextColor.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: _signUpLogic.fileIdFront != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              _signUpLogic.fileIdFront!,
                                              fit: BoxFit.cover,
                                            ))
                                        : const Icon(
                                            Icons.add_a_photo,
                                            color: customThemeColor,
                                            size: 25,
                                          ),
                                  ),
                                ),
                                Text(
                                  'id front Image',
                                  style: state.labelTextStyle,
                                ),
                              ],
                            )
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        //shop1-shop2-id image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                ///---shop2-image
                                InkWell(
                                  onTap: () {
                                    imagePickerDialog(context, isShop1: true);
                                  },
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height * .1,
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                    decoration: BoxDecoration(
                                        color: customTextColor.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: _signUpLogic.fileShopImage1 != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              _signUpLogic.fileShopImage1!,
                                              fit: BoxFit.cover,
                                            ))
                                        : const Icon(
                                            Icons.add_a_photo,
                                            color: customThemeColor,
                                            size: 25,
                                          ),
                                  ),
                                ),
                                Text(
                                  'Shop 1 Image',
                                  style: state.labelTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ///---shop2-image
                                InkWell(
                                  onTap: () {
                                    imagePickerDialog(context, isShop2: true);
                                  },
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height * .1,
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                    decoration: BoxDecoration(
                                        color: customTextColor.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: _signUpLogic.fileShopImage2 != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              _signUpLogic.fileShopImage2!,
                                              fit: BoxFit.cover,
                                            ))
                                        : const Icon(
                                            Icons.add_a_photo,
                                            color: customThemeColor,
                                            size: 25,
                                          ),
                                  ),
                                ),
                                Text(
                                  'Shop 2 Image',
                                  style: state.labelTextStyle,
                                ),
                              ],
                            )
                          ],
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
//select service
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12),
                          height: 52,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.home_repair_service_sharp,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Select Service:'),
                              SizedBox(
                                width: 8,
                              ),
                              DropdownButton(
                                // Initial Value
                                value: _signUpLogic.serviceType,
                                underline: SizedBox(),

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: _signUpLogic.items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _signUpLogic.serviceType = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        ///--name-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _signUpLogic.ownerNameController,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---shop-name-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _signUpLogic.nameController,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Shop Name",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---shop-location-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            readOnly: true,
                            onTap: () async {
                              ///---------------GOOGLE_ADDRESS_API_START

                              Get.to(const MapView());

                              ///---------------GOOGLE_ADDRESS_API_END
                            },
                            controller: _signUpLogic.addressController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Shop Location",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---open-time
                        Theme(
                          data: ThemeData(
                              primaryColor: customThemeColor,
                              primarySwatch: Colors.amber),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: DateTimeField(
                              format: timeFormat,
                              controller: _signUpLogic.openTimeController,
                              decoration: InputDecoration(
                                labelText: "Opening Time",
                                labelStyle: state.labelTextStyle,
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5))),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: customThemeColor)),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                _signUpLogic.openTimeController.text =
                                    time!.format(context).toString();
                                log('--->>>OPEN_TIME-->>${_signUpLogic.openTimeController.text}');
                                return DateTimeField.convert(time);
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Field Required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---close-time
                        Theme(
                          data: ThemeData(
                              primaryColor: customThemeColor,
                              primarySwatch: Colors.amber),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: DateTimeField(
                              format: timeFormat,
                              controller: _signUpLogic.closeTimeController,
                              decoration: InputDecoration(
                                labelText: "Closing Time",
                                labelStyle: state.labelTextStyle,
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5))),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: customThemeColor)),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                _signUpLogic.closeTimeController.text =
                                    time!.format(context).toString();
                                log('--->>>CLOSE_TIME-->>${_signUpLogic.closeTimeController.text}');
                                return DateTimeField.convert(time);
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Field Required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---email-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _signUpLogic.emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else if (!GetUtils.isEmail(
                                  _signUpLogic.emailController.text)) {
                                return 'Enter Valid Email';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---website-address-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _signUpLogic.websiteAddressController,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Website Address",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---about-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _signUpLogic.aboutController,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "About",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---password-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _signUpLogic.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: Colors.black,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: state.labelTextStyle,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(
                                  !obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: customThemeColor,
                                  size: 25,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else if (_signUpLogic
                                      .passwordController.text.length <
                                  6) {
                                return 'Password length must be greater than 6 ';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),

                        ///---sign-up-button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: InkWell(
                            onTap: () async {
                              _generalController.focusOut(context);
                              if (_signUpFormKey.currentState!.validate()) {
                                if (_signUpLogic.profile != null &&
                                    _signUpLogic.fileIdBack != null &&
                                    _signUpLogic.fileIdFront != null &&
                                    _signUpLogic.fileShopImage1 != null &&
                                    _signUpLogic.fileShopImage2 != null) {
                                  // Get.toNamed(PageRoutes.phoneLogin);
                                  await Get.find<GeneralController>()
                                      .updateFormLoader(true);
                                  await Get.find<GeneralController>()
                                      .firebaseAuthentication
                                      .signUp(context);

                                  await Get.find<GeneralController>()
                                      .updateFormLoader(false);
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: 'FAILED!',
                                          titleColor: customDialogErrorColor,
                                          descriptions: 'Please Upload Image',
                                          text: 'Ok',
                                          functionCall: () {
                                            Navigator.pop(context);
                                          },
                                          img: 'assets/dialog_error.svg',
                                        );
                                      });
                                }
                              }
                            },
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: customThemeColor,
                                borderRadius: BorderRadius.circular(30),
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
                              child: Center(
                                child: Text("Sign Up",
                                    style: state.buttonTextStyle),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Have an account? ",
                                style: state.doNotTextStyle),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child:
                                  Text("Login", style: state.registerTextStyle),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  List shopImagesList = [];
  void imagePickerDialog(
    BuildContext context, {
    bool isYourImage = false,
    bool isIdFront = false,
    bool isIdBack = false,
    bool isShop1 = false,
    bool isShop2 = false,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      shopImagesList = [];
                    });
                    shopImagesList.add(await ImagePickerGC.pickImage(
                        enableCloseButton: true,
                        context: context,
                        source: ImgSource.Camera,
                        barrierDismissible: true,
                        imageQuality: 10,
                        maxWidth: 400,
                        maxHeight: 600));
                    setState(() {
                      if (isYourImage) {
                        Get.find<SignUpLogic>().profile =
                            File(shopImagesList[0].path);
                      } else if (isIdFront) {
                        Get.find<SignUpLogic>().fileIdFront =
                            File(shopImagesList[0].path);
                      } else if (isIdBack) {
                        Get.find<SignUpLogic>().fileIdBack =
                            File(shopImagesList[0].path);
                      } else if (isShop1) {
                        Get.find<SignUpLogic>().fileShopImage1 =
                            File(shopImagesList[0].path);
                      } else if (isShop2) {
                        Get.find<SignUpLogic>().fileShopImage2 =
                            File(shopImagesList[0].path);
                      }
                    });
                    log(shopImagesList[0].path);
                  },
                  child: Text(
                    "Camera",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 18),
                  )),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      shopImagesList = [];
                    });
                    shopImagesList.add(await ImagePickerGC.pickImage(
                        enableCloseButton: true,
                        context: context,
                        source: ImgSource.Gallery,
                        barrierDismissible: true,
                        imageQuality: 10,
                        maxWidth: 400,
                        maxHeight: 600));
                    setState(() {
                      if (isYourImage) {
                        Get.find<SignUpLogic>().profile =
                            File(shopImagesList[0].path);
                      } else if (isIdFront) {
                        Get.find<SignUpLogic>().fileIdFront =
                            File(shopImagesList[0].path);
                      } else if (isIdBack) {
                        Get.find<SignUpLogic>().fileIdBack =
                            File(shopImagesList[0].path);
                      } else if (isShop1) {
                        Get.find<SignUpLogic>().fileShopImage1 =
                            File(shopImagesList[0].path);
                      } else if (isShop2) {
                        Get.find<SignUpLogic>().fileShopImage2 =
                            File(shopImagesList[0].path);
                      }
                    });
                    log(shopImagesList[0].path);
                  },
                  child: Text(
                    "Gallery",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 18),
                  )),
            ],
          );
        });
  }
}
