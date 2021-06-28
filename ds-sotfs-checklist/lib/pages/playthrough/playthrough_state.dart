part of 'playthrough_cubit.dart';

enum PlaythoughFilter { show, hide }
enum ChecklistPages { playthrough, achievement }
enum PlaythroughStates {
  initial,
  loading,
  loaded,
}

@immutable
abstract class PlaythroughState extends Equatable {
  final List<ChecklistItem> list;
  final PlaythroughStates playthroughStates;
  final ChecklistPages checklistPages;
  final PlaythoughFilter playthoughFilter;
  final bool isSelected;

  const PlaythroughState(this.list, this.playthroughStates, this.checklistPages,
      this.playthoughFilter,
      {required this.isSelected});

  PlaythroughState copyWith({
    final List<ChecklistItem> list,
    final PlaythroughStates playthroughStates,
    final ChecklistPages checklistPages,
    final PlaythoughFilter playthoughFilter,
    final bool isSelected,
  });

  @override
  List<Object?> get props =>
      [list, playthroughStates, playthoughFilter, isSelected];
}

class PlaythroughInitial extends PlaythroughState {
  const PlaythroughInitial(
      List<ChecklistItem> list,
      PlaythroughStates playthroughStates,
      ChecklistPages checklistPages,
      PlaythoughFilter playthoughFilter,
      {required bool isSelected})
      : super(list, playthroughStates, checklistPages, playthoughFilter,
            isSelected: isSelected);

  @override
  PlaythroughState copyWith({
    List<ChecklistItem>? list,
    PlaythroughStates? playthroughStates,
    ChecklistPages? checklistPages,
    PlaythoughFilter? playthoughFilter,
    bool? isSelected,
  }) {
    return PlaythroughInitial(
      list ?? this.list,
      playthroughStates ?? this.playthroughStates,
      checklistPages ?? this.checklistPages,
      playthoughFilter ?? this.playthoughFilter,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
