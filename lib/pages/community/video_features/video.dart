import 'package:elderly_care/pages/community/video_features/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomID;
  TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = (stream) {
      _remoteRenderer.srcObject = stream;
    };
  }

  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Call"),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await signaling.openUserMedia(
                      _localRenderer, _remoteRenderer);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: Text("Open Camera and Microphone"),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  roomID = await signaling.createRoom(_remoteRenderer);
                  textEditingController.text = roomID!;
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: Text("Create Room"),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await signaling.joinRoom(textEditingController.text);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: Text("Join Room"),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await signaling.hangUp(_localRenderer);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: Text("Hang Up"),
              ),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Join the following room: "),
                  Flexible(
                      child: TextFormField(
                    controller: textEditingController,
                  ))
                ],
              ))
        ],
      ),
    );
  }
}
