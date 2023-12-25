import "package:flutter/material.dart";

import "../../core/app_export.dart";
import "../../core/quran_index/quran_surah.dart";
import "../../data/model/surah_response.dart";
import "../../injection_container.dart";
import "bloc/surah_bloc.dart";

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  final surahBloc = sl<SurahBloc>();
  Surah? surah;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Retrieve the data from the arguments
      surah = ModalRoute.of(context)!.settings.arguments as Surah?;

      if (surah != null) {
        surahBloc.add(LoadSurahEvent(surahId: surah?.id.toString() ?? ""));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(
            PrefUtils().getIsDarkMode() == true ? 0xFF000000 : 0x0800FFD0),
        body: BlocProvider<SurahBloc>(
            create: (context) => surahBloc,
            child:
                BlocBuilder<SurahBloc, SurahState>(builder: (context, state) {
              if (state is LoadingSurahState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FailureSurahState) {
                return Center(child: Text(state.errorMessage));
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
                        itemCount: (state as SuccessSurahState).chapters.length,
                        itemBuilder: (context, index) {
                          final aya = (state).chapters[index];
                          return AyaListItem(
                            aya: aya,
                          );
                        },
                      ),
                    ])));
              }
            })));
  }
}

class AyaListItem extends StatelessWidget {
  final Chapter aya;

  const AyaListItem({super.key, required this.aya});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
      child: Text(
        aya.text,
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
          height: 165.v,
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
