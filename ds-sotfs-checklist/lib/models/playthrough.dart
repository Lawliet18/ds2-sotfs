class ChecklistItem {
  final String name;
  final int taskAmount;
  final int completed;
  final bool isSelected;

  ChecklistItem(this.name, this.taskAmount, this.completed,
      {required this.isSelected});

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      map['name'] as String,
      map['count(task)'] as int,
      map['sum(is_completed)'] as int,
      isSelected: map['is_selected'] == 0 ? false : true,
    );
  }
}
