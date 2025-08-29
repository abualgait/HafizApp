import "package:flutter/material.dart";

import "../../core/app_export.dart";
import "../../core/quran_index/quran_surah.dart";
import "../../core/scroll/scroll_position_cubit.dart";
import "../../data/model/surah_response.dart";
import "../../injection_container.dart";
import "bloc/surah_bloc.dart";

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen>
    with AutomaticKeepAliveClientMixin {
  final surahBloc = sl<SurahBloc>();
  Surah? surah;
  double? initialOffset;
  final scrollCubit = sl<ScrollPositionCubit>();
  final ScrollController _scrollController = ScrollController();
  bool _scrollRestored = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Retrieve the data from the arguments (supports Surah or {surah, offset})
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Surah) {
        surah = args;
      } else if (args is Map) {
        surah = args['surah'] as Surah?;
        final off = args['offset'];
        if (off is num) initialOffset = off.toDouble();
      }

      if (surah != null) {
        surahBloc.add(LoadSurahEvent(surahId: surah?.id.toString() ?? ""));
        if (mounted) setState(() {});
        final key = 'surah-${surah!.id}';
        // Attach listener once we have a key
        _scrollController.addListener(() {
          scrollCubit.saveOffset(key, _scrollController.offset);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (surah != null) {
            scrollCubit.saveOffset('surah-${surah!.id}', _scrollController.offset);
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Color(
              PrefUtils().getIsDarkMode() == true ? 0xFF000000 : 0xFFFFFFFF),
          body: BlocProvider<SurahBloc>(
              create: (context) => surahBloc,
              child:
                  BlocBuilder<SurahBloc, SurahState>(builder: (context, state) {
                if (state is LoadingSurahState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FailureSurahState) {
                  return Center(child: Text(state.errorMessage));
                } else {
                  // Restore scroll position once after content is available
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!_scrollRestored && surah != null) {
                      final saved = initialOffset ??
                          scrollCubit.getOffset('surah-${surah!.id}');
                      if (saved != null && _scrollController.hasClients) {
                        try {
                          _scrollController.jumpTo(saved);
                        } catch (_) {}
                      }
                      _scrollRestored = true;
                    }
                  });
                  return SizedBox(
                      width: double.maxFinite,
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          key: PageStorageKey(
                              'surah-scroll-${surah?.id ?? 'unknown'}'),
                          child: Column(children: [
                        _buildAppBar(surah),
                        SizedBox(height: 20.v),
                        ListView.builder(
                          key: PageStorageKey(
                              'surah-list-${surah?.id ?? 'unknown'}'),
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
              }))),
      ),
    );
  }
}

class AyaListItem extends StatelessWidget {
  final Chapter aya;

  const AyaListItem({super.key, required this.aya});

  @override
  Widget build(BuildContext context) {
    final bool isDark = PrefUtils().getIsDarkMode();
    // Keep a single source of truth for font size
    const double ayahFontSize = 20;
    const double badgeGap = 12; // visual space between last char and badge
    final double badgeDiameter = ayahFontSize * 1.25; // scale badge with text

    final Color textColor =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF004B40);
    final List<Color> badgeGradient = isDark
        ? [const Color(0xFF113C35), const Color(0xFF0B2D28)]
        : [const Color(0xFFFAF6EB), const Color(0xFFEDE6D6)];
    final Color badgeBorder =
        isDark ? const Color(0xFF87D1A4) : const Color(0xFF006754);
    final Color badgeText =
        isDark ? const Color(0xFFFAF6EB) : const Color(0xFF004B40);

    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
      child: RichText(
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: aya.text,
              style: TextStyle(
                fontSize: ayahFontSize,
                fontWeight: FontWeight.w700,
                color: textColor,
                fontFamily: "Amiri",
              ),
            ),
            // Add a textual space for better semantics/copying in addition to visual gap
            const TextSpan(text: ' '),
            const WidgetSpan(child: SizedBox(width: badgeGap)),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Container(
                width: badgeDiameter,
                height: badgeDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: badgeGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: badgeBorder, width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${aya.verse}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ayahFontSize * 0.7,
                    fontWeight: FontWeight.w700,
                    color: badgeText,
                  ),
                ),
              ),
            ),
          ],
        ),
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
              colors: [Color(0xFF006754),
                Color(0xDB87D1A4)],
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
                    Hero(
                      tag: 'surah-title-${surah?.id ?? 'unknown'}',
                      child: Text(
                        surah?.nameArabic ?? "",
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: "Amiri"),
                      ),
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
