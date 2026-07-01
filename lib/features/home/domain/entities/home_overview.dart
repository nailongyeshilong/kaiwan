class HomeOverview {
  const HomeOverview({
    required this.featuredTitle,
    required this.featuredDescription,
    required this.featuredCoverImagePath,
    required this.remainingDraws,
    required this.maxDraws,
    required this.gamePoolCount,
    required this.isLocked,
    required this.hasResult,
    required this.footerHint,
  });

  final String featuredTitle;
  final String featuredDescription;
  final String? featuredCoverImagePath;
  final int remainingDraws;
  final int maxDraws;
  final int gamePoolCount;
  final bool isLocked;
  final bool hasResult;
  final String footerHint;
}
