// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// class VideoCallPageState extends State<VideCallPage> {
//   Signaling signaling = Signaling();

//   RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

//   String? roomID;
//   TextEditingController textEditingController = TextEditingController(text: "");

//   @override
//   void initState(){
//     _localRenderer.initialize();
//     _remoteRenderer.initialize();

//     signaling.onAddRemoteStream = ((stream)){
//       _remoteRenderer.srcObject = stream;
//       setState(() {
        
//       });

//       super.initState();
    
//     }

//     @override
//     void dispose(){
//       _localRenderer.dispose();
//       _remoteRenderer.dispose();
//       super.dispose();
//     }

//     @override
//     Widget build(BuildContext context){
//       return Scaffold(
//         body: Column(),
//       )
//     }
//     }

// }