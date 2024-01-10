/// [Message] is a class that represents a message [class] sent by the user.
class Message {
  Message({
    this.name,
    this.email,
    this.message,
    this.dateTime,
  });

  final String? name;
  final String? email;
  final String? message;
  final String? dateTime;

  /// toJson is a method that converts the [Message] object to a [Map] object.
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'message': message,
        'date_time': dateTime,
      };

  /// fromJson is a method that converts a [Map] object to a [Message] object.
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        name: json['name']?.toString(),
        email: json['email']?.toString(),
        message: json['message']?.toString(),
        dateTime: json['date_time']?.toString(),
      );
}
