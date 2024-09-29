import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

class ChatPromptView extends StatefulWidget {
  const ChatPromptView({super.key});

  @override
  State<ChatPromptView> createState() => _ChatPromptViewState();
}

class _ChatPromptViewState extends State<ChatPromptView> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _user2 = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3asas');
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Chat(
          bubbleBuilder: _bubbleBuilder,
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
        Visibility(
          visible: isLoading,
          child: const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        )
      ],
    ),
  );

  void _handleLoading(bool loadingState) {
    setState(() {
      isLoading = loadingState;
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v8(),
      text: message.text,
    );

    _addMessage(textMessage);

    _handleLoading(true);

    getHttp(message.text).then((value) {
      _handleLoading(false);
      final responseTextMessage = types.TextMessage(
        author: _user2,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v8(),
        text: value,
      );
      _addMessage(responseTextMessage);
      print("Done");
    }).catchError((_){
      _handleLoading(false);
    });

  }

  Future<String> getHttp(String prompt) async {
    final dio = Dio();

    final locationPosition = await _determinePosition();
    final longitude = locationPosition.longitude;
    final latitude = locationPosition.latitude;

    print("LON IS $longitude and LAT IS $latitude");

    final response = await dio.post('http://10.0.2.2:8000/', data: {
      "prompt": prompt,
      "lat": latitude.toString(),
      "lon": longitude.toString(),
    });

    final responseModel = MessageResponseModel.fromJson(response.data);
    print(responseModel.message);
    return responseModel.message;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Widget _bubbleBuilder(
      Widget child, {
        required message,
        required nextMessageInGroup,
      }) {
    const bgColorCode = 0xffA0522D;
    return Bubble(
      color: _user.id != message.author.id ||
          message.type == types.MessageType.image
          ? const Color(0xfff5f5f7)
          : const Color(bgColorCode),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : _user.id != message.author.id
          ? BubbleNip.leftBottom
          : BubbleNip.rightBottom,
      child: child,
    );
  }

}

class MessageResponseModel {
  String message;

  MessageResponseModel({
    required this.message,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) => MessageResponseModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
