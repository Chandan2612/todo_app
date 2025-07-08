class Task {
  final String id;
  final String title;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Task copyWith({String? title, bool? isCompleted}) {
    return Task(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json, String id) {
    return Task(
      id: id,
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
      };
}
