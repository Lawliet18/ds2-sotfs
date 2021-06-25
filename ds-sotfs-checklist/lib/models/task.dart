class Task {
  final int id;
  final String task;
  final bool isCompleted;

  Task(this.id, this.task, {this.isCompleted = false});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      map['id'],
      map['task'],
      isCompleted: map['is_completed'] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toMap(Task task) {
    return {
      'id': task.id,
      'task': task.task,
      'is_completed': task.isCompleted == false ? 0 : 1,
    };
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
