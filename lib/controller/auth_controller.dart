import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t_save_sp/modules/login_message/view.dart';
import 'package:get/get.dart';

import '../modules/login/logic.dart';
import '../modules/sign_up/logic.dart';
import '../route_generator.dart';
import '../utils/colors.dart';
import 'general_controller.dart';

class FirebaseAuthentication {
  void signInWithEmailAndPassword() async {
    try {
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Get.find<LoginLogic>().emailController.text,
        password: Get.find<LoginLogic>().passwordController.text,
      ))
              .user;
      if (user != null) {
        log(user.uid.toString());
        QuerySnapshot query = await _firestore
            .collection('shop')
            .where("uid_id", isEqualTo: user.uid)
            .where('isActive', isEqualTo: true)
            .get();

        if (query.docs.isNotEmpty) {
          Get.find<GeneralController>()
              .boxStorage
              .write('uid', user.uid.toString());
          log('user exist');
          Get.find<GeneralController>().boxStorage.write('session', 'active');

          Get.offAllNamed(PageRoutes.home);
        } else {
          Get.find<GeneralController>().updateFormLoader(false);
          Get.to(const LoginMessagePage());
          // Get.snackbar(
          //   'FAILED!',
          //   'User Not Found..',
          //   colorText: Colors.white,
          //   backgroundColor: customThemeColor.withOpacity(0.7),
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: const EdgeInsets.all(15),
          // );
        }
      } else {
        log('user not found');
        Get.find<GeneralController>().updateFormLoader(false);
        Get.find<GeneralController>().boxStorage.remove('session');
      }
    } on FirebaseAuthException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> signUp(BuildContext context) async {
    try {
      Get.find<SignUpLogic>().nameController.text = Get.find<SignUpLogic>()
          .nameController
          .text
          .toString()
          .capitalize
          .toString();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: Get.find<SignUpLogic>().emailController.text,
              password: Get.find<SignUpLogic>().passwordController.text)
          .then((user) async {
        var signuplogic = Get.find<SignUpLogic>();
        await signuplogic.uploadFile(context,
            isIdBack: true,
            isIdFront: true,
            isShop1: true,
            isShop2: true,
            isYourImage: true);
        // await uploadFile(profile!, context, isYourImage: true);
        // await uploadFile(fileIdFront, context, isIdFront: true);
        // await uploadFile(fileIdBack, context, isIdBack: true);
        // await uploadFile(fileShopImage1, context, isShop1: true);
        // await uploadFile(fileShopImage2, context, isShop2: true);
        Get.find<GeneralController>().boxStorage.write('uid', user.user!.uid);
        await _firestore.collection('users').doc(user.user!.uid).set({
          'name': Get.find<SignUpLogic>().ownerNameController.text,
          'phone': Get.find<SignUpLogic>().phoneNumber,
          'email': Get.find<SignUpLogic>().emailController.text,
          'address': Get.find<SignUpLogic>().addressController.text,
          'image': Get.find<SignUpLogic>().downloadURL,
          'uid': user.user!.uid,
        });
        await _firestore.collection('shop').doc(user.user!.uid).set({
          'name': Get.find<SignUpLogic>().nameController.text,
          'phone': Get.find<SignUpLogic>().phoneNumber,
          'email': Get.find<SignUpLogic>().emailController.text,
          'address': Get.find<SignUpLogic>().addressController.text,
          'lng': Get.find<SignUpLogic>().longitudeString,
          'lat': Get.find<SignUpLogic>().latitudeString,
          'website_address':
              Get.find<SignUpLogic>().websiteAddressController.text.isEmpty
                  ? ''
                  : Get.find<SignUpLogic>().websiteAddressController.text,
          'about': Get.find<SignUpLogic>().aboutController.text,
          'isActive': false,
          'role': 'shop',
          'image': Get.find<SignUpLogic>().downloadURL,
          'imageUrlIdFrontImage': Get.find<SignUpLogic>().imageUrlIdFrontImage,
          'imageUrlIdBackImage': Get.find<SignUpLogic>().imageUrlIdBackImage,
          'imageUrlShopImage1': Get.find<SignUpLogic>().imageUrlShopImage1,
          'imageUrlShopImage2': Get.find<SignUpLogic>().imageUrlShopImage2,
          'open_time': Get.find<SignUpLogic>().openTimeController.text,
          'close_time': Get.find<SignUpLogic>().closeTimeController.text,
          'total_rates': 0,
          'ratings': [],
          'reviews': [],
          'id': Get.find<SignUpLogic>().getRandomString(5),
          'uid_id': user.user!.uid,
          'service_type': Get.find<SignUpLogic>().serviceType
        });
      });
      Get.find<GeneralController>().updateFormLoader(false);
      // Get.find<GeneralController>().boxStorage.write('session', 'active');

      Get.offAllNamed(PageRoutes.login);
      return true;
    } on FirebaseAuthException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      log(e.toString());
      return false;
    }
  }

  setSearchParam(String caseNumber) {
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      i = (caseNumber.length) + 1;
    }
    return temp;
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.find<GeneralController>().boxStorage.remove('session');
    Get.find<GeneralController>().boxStorage.remove('uid');
    Get.offAllNamed(PageRoutes.login);
    Get.find<GeneralController>().updateFormLoader(false);
  }
}
