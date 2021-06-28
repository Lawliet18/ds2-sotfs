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
