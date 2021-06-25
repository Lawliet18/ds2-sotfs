class Playthrough {
  final String name;
  final int taskAmount;
  final int completed;

  Playthrough(this.name, this.taskAmount, this.completed);

  factory Playthrough.fromMap(Map<String, dynamic> map) {
    print(map);
    return Playthrough(
      map['name'],
      map['count(task)'],
      map['sum(is_completed)'],
    );
  }
}
