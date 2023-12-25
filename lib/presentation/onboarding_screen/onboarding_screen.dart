import 'package:flutter/material.dart';
import 'package:hafiz_app/widgets/custom_elevated_button.dart';

import '../../core/app_export.dart';
import '../../injection_container.dart';
import 'bloc/onboarding_bloc.dart';
import 'models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<OnboardingBloc>(
        create: (context) =>
            OnboardingBloc(OnboardingState(onboardingModel: OnboardingModel())),
        child: const OnboardingScreen());
  }

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final networkInfo = sl<NetworkInfo>();
  bool isConnected = true;

  @override
  void initState() {
    networkInfo.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        if (result == ConnectivityResult.none) {
          isConnected = false;
        } else {
          isConnected = true;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFF004B40),
            body: Stack(
              children: [
                !isConnected
                    ? const Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "No Internet",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                    width: double.maxFinite,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: CustomImageView(
                              fit: BoxFit.cover,
                              imagePath: ImageConstant.imgGroupCircles,
                              height: 72.adaptSize,
                              width: 72.adaptSize),
                        ),
                        Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  color: const Color(0xFF186351),
                                  child: CustomImageView(
                                      imagePath:
                                          ImageConstant.imgQuranOnboarding,
                                      height: 391.adaptSize,
                                      width: 341.adaptSize),
                                ),
                                SizedBox(
                                  height: 22.adaptSize,
                                ),
                                Text(
                                  "app_name".tr,
                                  style: const TextStyle(
                                      color: Color(0xFF87D1A4),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35),
                                ),
                                SizedBox(
                                  height: 16.adaptSize,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60, right: 60),
                                  child: Text(
                                    "lbl_learn_quran".tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                  height: 22.adaptSize,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 100.0, right: 100.0),
                                  child: CustomElevatedButton(
                                      key: const ValueKey("get_started_key"),
                                      onPressed: () {
                                        NavigatorService.pushNamed(
                                          AppRoutes.homePage,
                                        );
                                      },
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle),
                                      rightIcon: const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Color(0xff004B40),
                                        ),
                                      ),
                                      text: "lbl_get_started".tr,
                                      buttonStyle: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xFFFAF6EB)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(200.0),
                                            // You can also customize other properties like border, elevation, etc.
                                          ),
                                        ),
                                      ),
                                      buttonTextStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                ),
                              ]),
                        )
                      ],
                    )),
              ],
            )),
      );
    });
  }
}
