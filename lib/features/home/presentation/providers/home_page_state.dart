import '../../domain/entities/home_overview.dart';

class HomePageState {
  const HomePageState({
    required this.featuredTitle,
    required this.featuredDescription,
    required this.remainingDraws,
    required this.maxDraws,
    required this.gamePoolCount,
    required this.isLocked,
    required this.footerHint,
  });

  factory HomePageState.fromOverview(HomeOverview overview) {
    return HomePageState(
      featuredTitle: overview.featuredTitle,
      featuredDescription: overview.featuredDescription,
      remainingDraws: overview.remainingDraws,
      maxDraws: overview.maxDraws,
      gamePoolCount: overview.gamePoolCount,
      isLocked: overview.isLocked,
      footerHint: overview.footerHint,
    );
  }

  final String featuredTitle;
  final String featuredDescription;
  final int remainingDraws;
  final int maxDraws;
  final int gamePoolCount;
  final bool isLocked;
  final String footerHint;
}
