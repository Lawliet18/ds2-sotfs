class ChecklistItem {
  final String name;
  final int taskAmount;
  final int completed;
  final bool isSelected;

  ChecklistItem(this.name, this.taskAmount, this.completed,
      {required this.isSelected});

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      map['name'],
      map['count(task)'],
      map['sum(is_completed)'],
      isSelected: map['is_selected'] == 0 ? false : true,
    );
  }
}
