import '../../domain/entities/home_overview.dart';

class HomePageState {
  const HomePageState({
    required this.featuredTitle,
    required this.featuredDescription,
    required this.featuredCoverImagePath,
    required this.remainingDraws,
    required this.maxDraws,
    required this.gamePoolCount,
    required this.isLocked,
    required this.hasResult,
    required this.isDrawing,
    required this.resultVersion,
    required this.footerHint,
  });

  factory HomePageState.fromOverview(HomeOverview overview) {
    return HomePageState(
      featuredTitle: overview.featuredTitle,
      featuredDescription: overview.featuredDescription,
      featuredCoverImagePath: overview.featuredCoverImagePath,
      remainingDraws: overview.remainingDraws,
      maxDraws: overview.maxDraws,
      gamePoolCount: overview.gamePoolCount,
      isLocked: overview.isLocked,
      hasResult: overview.hasResult,
      isDrawing: false,
      resultVersion: 0,
      footerHint: overview.footerHint,
    );
  }

  final String featuredTitle;
  final String featuredDescription;
  final String? featuredCoverImagePath;
  final int remainingDraws;
  final int maxDraws;
  final int gamePoolCount;
  final bool isLocked;
  final bool hasResult;
  final bool isDrawing;
  final int resultVersion;
  final String footerHint;

  HomePageState copyWith({
    String? featuredTitle,
    String? featuredDescription,
    String? featuredCoverImagePath,
    int? remainingDraws,
    int? maxDraws,
    int? gamePoolCount,
    bool? isLocked,
    bool? hasResult,
    bool? isDrawing,
    int? resultVersion,
    String? footerHint,
    bool clearFeaturedCoverImagePath = false,
  }) {
    return HomePageState(
      featuredTitle: featuredTitle ?? this.featuredTitle,
      featuredDescription: featuredDescription ?? this.featuredDescription,
      featuredCoverImagePath: clearFeaturedCoverImagePath
          ? null
          : featuredCoverImagePath ?? this.featuredCoverImagePath,
      remainingDraws: remainingDraws ?? this.remainingDraws,
      maxDraws: maxDraws ?? this.maxDraws,
      gamePoolCount: gamePoolCount ?? this.gamePoolCount,
      isLocked: isLocked ?? this.isLocked,
      hasResult: hasResult ?? this.hasResult,
      isDrawing: isDrawing ?? this.isDrawing,
      resultVersion: resultVersion ?? this.resultVersion,
      footerHint: footerHint ?? this.footerHint,
    );
  }
}
