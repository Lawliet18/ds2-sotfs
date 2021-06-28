part of 'home_cubit.dart';

enum HomeStates { initial, loading, loaded }

@immutable
abstract class HomeState extends Equatable {
  final List<Task> currentPlaythrough;
  final List<Task> currentAchievement;
  final HomeStates homeStates;

  const HomeState(
    this.currentPlaythrough,
    this.currentAchievement,
    this.homeStates,
  );

  HomeState copyWith({
    final List<Task> currentPlaythrough,
    final List<Task> currentAchievement,
    final HomeStates homeStates,
  });

  @override
  List<Object> get props =>
      [currentPlaythrough, currentAchievement, homeStates];
}

class HomeInitial extends HomeState {
  const HomeInitial(List<Task> currentPlaythrough,
      List<Task> currentAchievement, HomeStates homeStates)
      : super(currentPlaythrough, currentAchievement, homeStates);

  @override
  HomeState copyWith({
    List<Task>? currentPlaythrough,
    List<Task>? currentAchievement,
    HomeStates? homeStates,
  }) {
    return HomeInitial(
      currentPlaythrough ?? this.currentPlaythrough,
      currentAchievement ?? this.currentAchievement,
      homeStates ?? this.homeStates,
    );
  }
}
