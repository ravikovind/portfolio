part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageSending extends MessageState {}

class MessageSent extends MessageState {
  final String message;
  const MessageSent({required this.message});
  @override
  List<Object> get props => [message];
  @override
  String toString() => 'MessageSent { message: $message }';
}

class MessageError extends MessageState {
  final String message;
  const MessageError({required this.message});
  @override
  List<Object> get props => [message];
  @override
  String toString() => 'MessageError { message: $message }';
}
