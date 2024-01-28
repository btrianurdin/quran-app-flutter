import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran/modules/surah-detail/components/verse_lists.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/shared/single_scrolling_layout.dart';
import 'package:quran/utils/font_styles.dart';

class SurahDetailPage extends StatelessWidget {
  const SurahDetailPage({
    super.key,
    required this.surahId,
    required this.surahName,
  });

  final int surahId;
  final String surahName;

  @override
  Widget build(BuildContext context) {
    log('surah detail render ${surahName.toString()}');
    return SingleScrollingLayout(
      appBarTitle: 'Surah Detail',
      scrollingAppBarTitle: surahName,
      child: Consumer(
        builder: (context, ref, child) {
          final surah = ref.watch(surahDetailProvider(surahId));

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24, top: 24),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/images/home-quran.svg',
                        width: 280,
                      ),
                    ),
                    Opacity(
                      opacity: 0.9,
                      child: Container(
                        width: double.infinity,
                        height: 270,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 270,
                      padding: const EdgeInsets.all(24),
                      child: surah.when(
                        data: (data) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.latinName,
                                style: FontStyles.title.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(data.meaning, style: FontStyles.regular),
                              const SizedBox(height: 16),
                              const Divider(endIndent: 40, indent: 40),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.relativationType.toUpperCase(),
                                    style: FontStyles.regular
                                        .copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${data.verseCount} Verses'.toUpperCase(),
                                    style: FontStyles.regular
                                        .copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              SvgPicture.asset('assets/images/opening.svg'),
                            ],
                          );
                        },
                        error: (error, stackTrace) {
                          return Center(
                            child: Text('Error: $error'),
                          );
                        },
                        loading: () {
                          return Container();
                        },
                      ),
                    )
                  ],
                ),
              ),
              VerseLists(
                surahName: surah.when(
                  data: (value) => value.latinName,
                  error: (error, stackTrace) => '',
                  loading: () => '',
                ),
                surahId: surahId,
              ),
              const SizedBox(height: 20)
            ],
          );
        },
      ),
    );
  }
}
