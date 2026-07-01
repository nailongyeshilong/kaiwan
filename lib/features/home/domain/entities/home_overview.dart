class HomeOverview {
  const HomeOverview({
    required this.featuredTitle,
    required this.featuredDescription,
    required this.remainingDraws,
    required this.maxDraws,
    required this.gamePoolCount,
    required this.isLocked,
    required this.footerHint,
  });

  final String featuredTitle;
  final String featuredDescription;
  final int remainingDraws;
  final int maxDraws;
  final int gamePoolCount;
  final bool isLocked;
  final String footerHint;
}
