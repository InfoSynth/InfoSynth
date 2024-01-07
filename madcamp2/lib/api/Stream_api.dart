import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamApi {
  static Future initUser(
      StreamChatClient client, {
        @required String? username,
        @required String? urlImage,
        @required String? id,
        @required String? token,
      }) async {
    final user = User(
      id: id.toString(),
      extraData: {
        'name': username,
        'image': urlImage,
      },
    );

    await client.setUser(user, token);
  }

  static Future<Channel> createChannel(
      StreamChatClient client, {
        @required String? type,
        @required String? name,
        @required String? id,
        @required String? image,
        List<String> idMembers = const [],
      }) async {
    final channel = client.channel(type.toString(), id: id, extraData: {
      'name': name,
      'image': image,
      'members': idMembers,
    });

    await channel.create();

    channel.watch();
    return channel;
  }

  static Future<Channel> watchChannel(
      StreamChatClient client, {
        @required String? type,
        @required String? id,
      }) async {
    final channel = client.channel(type.toString(), id: id);

    channel.watch();
    return channel;
  }
}