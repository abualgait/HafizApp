import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hafiz_app/presentation/surah_screen/provider/surah_provider.dart";

import "../../core/app_export.dart";
import "../../core/quran_index/quran_surah.dart";
import "../../data/model/surah_response.dart";
import "../../injection_container.dart";

class SurahScreen extends ConsumerStatefulWidget {
  const SurahScreen({super.key});

  @override
  ConsumerState<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends ConsumerState<SurahScreen> {
  Surah? surah;
  final surahProvider = sl<SurahStateNotifier>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Retrieve the data from the arguments
      surah = ModalRoute.of(context)!.settings.arguments as Surah?;
      if (surah != null) {
        ref.read(surahStateProvider.notifier).loadSurah(surah?.id.toString() ?? "");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(
              PrefUtils().getIsDarkMode() == true ? 0xFF000000 : 0xFFFFFFFF),
          body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              var value = ref.watch(surahStateProvider);
              if (value.isLoading == true && value.chapters.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else if (value.error != "") {
                return Center(child: Text(value.error ?? ""));
              } else {
                return SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      _buildAppBar(surah),
                      SizedBox(height: 20.v),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.chapters.length,
                        itemBuilder: (context, index) {
                          final aya = value.chapters[index];
                          return AyaListItem(
                            aya: aya,
                          );
                        },
                      ),
                    ])));
              }
            },
          )),
    );
  }
}

class AyaListItem extends StatelessWidget {
  final Chapter? aya;

  const AyaListItem({super.key, required this.aya});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
      child: Text(
        aya?.text ?? "",
        textDirection: TextDirection.rtl,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(
                PrefUtils().getIsDarkMode() == true ? 0xFFFFFFFF : 0xFF004B40),
            fontFamily: "Amiri"),
      ),
    );
  }
}

Widget _buildAppBar(Surah? surah) {
  return Stack(
    children: [
      Positioned(
        right: -55,
        bottom: -10,
        child: CustomImageView(
            fit: BoxFit.cover,
            imagePath: ImageConstant.imgQuranOnboarding,
            height: 150.v,
            width: 150.h),
      ),
      Container(
          height: 180.v,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF006754), Color(0xDB87D1A4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    NavigatorService.goBack();
                  },
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      surah?.nameArabic ?? "",
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: "Amiri"),
                    ),
                    surah?.id == 9
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 1.adaptSize,
                              width: 144.h,
                              color: const Color(0xFFD9D8D8),
                            ),
                          ),
                    surah?.id == 9
                        ? const SizedBox.shrink()
                        : CustomImageView(
                            imagePath: ImageConstant.imgBismillah,
                          )
                  ],
                ),
                const SizedBox.shrink()
              ],
            ),
          )),
    ],
  );
}
