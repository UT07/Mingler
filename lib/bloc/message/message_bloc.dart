import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test2/repositories/messageRepository.dart';
import 'package:meta/meta.dart';
part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageRepository _messageRepository;

  MessageBloc({@required MessageRepository messageRepository})
      : assert(messageRepository != null),
        _messageRepository = messageRepository, super(MessageInitialState());

  @override
  MessageState get initialState => MessageInitialState();

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {

    if(event is ChatStreamEvent){
      yield* _mapStreamToState(currentUserId: event.currentUserId);
    }
  }

 Stream<MessageState> _mapStreamToState({String currentUserId}) async*{
    yield ChatLoadedState();

    Stream<QuerySnapshot> chatStream = _messageRepository.getChats(userId:
    currentUserId);
    yield ChatLoadedState(chatStream: chatStream);
 }
}
