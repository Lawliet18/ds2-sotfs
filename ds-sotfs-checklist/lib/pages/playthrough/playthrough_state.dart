part of 'playthrough_cubit.dart';

enum PlaythroughStates { initial, loading, loaded, checked }

@immutable
abstract class PlaythroughState extends Equatable {
  final List<Playthrough> list;
  final PlaythroughStates playthroughStates;

  PlaythroughState(this.list, this.playthroughStates);

  PlaythroughState copyWith({
    final List<Playthrough> list,
    final PlaythroughStates playthroughStates,
  });

  @override
  List<Object?> get props => [list, playthroughStates];
}

class PlaythroughInitial extends PlaythroughState {
  PlaythroughInitial(
      List<Playthrough> list, PlaythroughStates playthroughStates)
      : super(list, playthroughStates);

  @override
  PlaythroughState copyWith(
      {List<Playthrough>? list, PlaythroughStates? playthroughStates}) {
    return PlaythroughInitial(
      list ?? this.list,
      playthroughStates ?? this.playthroughStates,
    );
  }
}
