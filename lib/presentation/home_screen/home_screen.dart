import "package:flutter/material.dart";
import "package:hafiz_app/core/quran_index/quran_surah.dart";

import "../../core/app_export.dart";
import "../../injection_container.dart";
import "../../widgets/custom_app_bar.dart";
import "../../widgets/custom_elevated_button.dart";
import "bloc/home_bloc.dart";
import "../../core/scroll/scroll_position_cubit.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

void changeLocale(BuildContext context, Locale newLocale) {
  AppLocalization.of().setLocale(newLocale);
}

Locale getCurrentLocale() {
  return AppLocalization.of().getCurrentLocale();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final homeBloc = sl<HomeBloc>();
  final themeBloc = sl<ThemeBloc>();
  final scrollCubit = sl<ScrollPositionCubit>();
  final ScrollController _scrollController = ScrollController();
  bool isDarkMode = PrefUtils().getIsDarkMode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saved = scrollCubit.getOffset('home');
      if (saved != null && _scrollController.hasClients) {
        try {
          _scrollController.jumpTo(saved);
        } catch (_) {}
      }
    });
    _scrollController.addListener(() {
      scrollCubit.saveOffset('home', _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(
            PrefUtils().getIsDarkMode() == true ? 0xFF000000 : 0xFFFFFFFF),
        appBar: CustomAppBar(
            actions: [
              Row(
                children: [
                  Icon(
                    Icons.wb_sunny,
                    color: isDarkMode ? Colors.grey : Colors.amber,
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                        PrefUtils().setIsDarkMode(value);
                        themeBloc.add(ToggleThemeEvent());
                      });
                      // Add logic to toggle theme here
                    },
                    activeTrackColor: Colors.grey[700],
                    activeThumbColor: Colors.grey,
                  ),
                  Icon(
                    Icons.nightlight_round,
                    color: isDarkMode ? Colors.blue : Colors.grey,
                  ),
                ],
              )
            ],
            title: Center(
              child: Text(
                "app_name".tr,
                style: TextStyle(
                  color: Color(isDarkMode ? 0xFFFFFFFF : 0xFF004B40),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        body: BlocProvider<HomeBloc>(
            create: (context) => homeBloc,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.maxFinite,
                  child: Scaffold(
                    body: SizedBox(
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                            controller: _scrollController,
                            key: const PageStorageKey('home-scroll'),
                            child: Column(children: [
                          (state as UpdateLastReadSurah).surah != null
                              ? _buildCardLastRead((state).surah)
                              : const SizedBox.shrink(),
                          ListView.builder(
                            key: const PageStorageKey('home-list'),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: QuranIndex.quranSurahs.length,
                            itemBuilder: (context, index) {
                              final surah = QuranIndex.quranSurahs[index];
                              return InkWell(
                                onTap: () {
                                  PrefUtils().saveLastReadSurah(surah);
                                  homeBloc.add(HomeShowLastSurahEvent());
                                  NavigatorService.pushNamed(
                                      AppRoutes.surahPage,
                                      arguments: surah);
                                },
                                child: SurahListItem(
                                  surahId: surah.id,
                                  nameEnglish: surah.nameEnglish,
                                  nameArabic: surah.nameArabic,
                                ),
                              );
                            },
                          ),
                        ]))),
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget _buildCardLastRead(Surah? lastReadSurah) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: const LinearGradient(
                colors: [Color(0xFF006754), Color(0xFF87D1A4)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "lbl_last_read".tr,
                                style: const TextStyle(
                                    color: Color(0xFFFAF6EB),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Text(
                                  lastReadSurah?.nameArabic ?? "",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontFamily: "Amiri"),
                                ),
                              ),
                              CustomElevatedButton(
                                  height: 31,
                                  onPressed: () {
                                    NavigatorService.pushNamed(
                                        AppRoutes.surahPage,
                                        arguments: lastReadSurah);
                                  },
                                  rightIcon: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xff004B40),
                                    ),
                                  ),
                                  text: "lbl_continue".tr,
                                  buttonStyle: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            const Color(0xFFFAF6EB)),
                                    shape: WidgetStateProperty.all<
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
                                      fontSize: 14))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomImageView(
                            imagePath: ImageConstant.imgQuranOnboarding,
                            height: 200.adaptSize,
                            width: 200.adaptSize),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SurahListItem extends StatelessWidget {
  final int surahId;
  final String nameEnglish;
  final String nameArabic;

  const SurahListItem({
    super.key,
    required this.surahId,
    required this.nameEnglish,
    required this.nameArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                color: const Color(0xFF87D1A4),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 8.0, bottom: 8.0, right: 16.0),
                  child: Text(
                    '$surahId',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  nameEnglish,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                nameArabic,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(PrefUtils().getIsDarkMode() == true
                        ? 0xFFD9D8D8
                        : 0xFF076C58),
                    fontFamily: "Amiri"),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          surahId < 114
              ? Container(
                  height: 1.adaptSize,
                  width: double.infinity,
                  color: const Color(0xFFD9D8D8),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
