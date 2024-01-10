import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:me/data/models/message.dart';
import 'package:me/data/repositories/api_repository.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final APIRepository _apiRepository;
  MessageCubit(this._apiRepository) : super(MessageInitial());
  void sendMessage(Message message) async {
    emit(MessageSending());
    try {
      final result = await _apiRepository.sendThanks(message);
      if (result) {
        emit(const MessageSent(
            message: 'Your message has been sent successfully'));
      } else {
        emit(const MessageError(message: 'There is an error'));
      }
    } catch (e) {
      emit(MessageError(message: 'there is an error due to $e'));
    }
  }
}
