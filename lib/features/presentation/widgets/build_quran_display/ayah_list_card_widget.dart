import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/enums/message_type.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
import 'package:quran_life_muslim/features/presentation/manage/bookmark/bookmark_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_display/build_quran_card_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_snack_bar/snackbar_widget.dart';

class AyahListCardWidget extends StatefulWidget {
  final SurahModel surah;

  const AyahListCardWidget({super.key, required this.surah});

  @override
  State<AyahListCardWidget> createState() => _AyahListCardWidgetState();
}

class _AyahListCardWidgetState extends State<AyahListCardWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    context.read<BookmarkBloc>().add(GetBookmarks());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookmarkBloc, BookmarkState>(
      listener: (context, state) {
        if (state is BookmarkError) {
          showCustomSnackBar(
            context: context,
            title: "توجد مشكلة, حاول في وقت لاحق",
            duration: 300,
            type: MessageType.error,
          );
        } else if (state is BookmarkSaved) {
          showCustomSnackBar(
            context: context,
            title: "تم حفظ الآية بنجاح",
            duration: 300,
            type: MessageType.success,
          );
          context.read<BookmarkBloc>().add(GetBookmarks());
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              widget.surah.name == "سُورَةُ التَّوۡبَةِ" ||
                      widget.surah.name == "سُورَةُ ٱلْفَاتِحَةِ"
                  ? const SizedBox()
                  : Center(
                      child: Text(
                        AppConsts.bismillah,
                        style: TextStyle(
                          fontFamily: AppConsts.uthmanic,
                          fontSize: AppConsts.font22size,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              ListView.builder(
                controller: _scrollController,
                itemCount: widget.surah.ayahs!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final ayah = widget.surah.ayahs![index];
                  final isBookmarked = state is BookmarksLoaded
                      ? state.bookmarks.any((bookmark) =>
                          bookmark["ayahNumber"] == ayah.numberInSurah &&
                          bookmark["surahName"] == widget.surah.name)
                      : false;

                  return buildQuranCardWidget(
                    context,
                    ayah.text ?? "No Text",
                    ayah.numberInSurah.toString(),
                    isBookmarked,
                    onTapped: () {
                      if (!isBookmarked) {
                        context.read<BookmarkBloc>().add(
                              SaveBookmark(
                                quranModel: widget.surah,
                                surahName: widget.surah.name!,
                                ayahs: widget.surah.ayahs!,
                                selectedAyah: ayah,
                              ),
                            );
                      } else {
                        showCustomSnackBar(
                          context: context,
                          title: "الآية محفوظة بالفعل",
                          duration: 3,
                          type: MessageType.info,
                        );
                      }
                    },
                  );
                },
              ),
              Center(
                child: Text(
                  AppConsts.endSurah,
                  style: TextStyle(
                    fontFamily: AppConsts.uthmanic,
                    fontSize: AppConsts.font22size,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}