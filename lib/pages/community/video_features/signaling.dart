import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// Define the callback type
typedef StreamStateCallback = Function(MediaStream stream);

class Signaling {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      },
      {
        'urls': 'turn:your-turn-server.com',
        'username': 'user',
        'credential': 'password'
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomID;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;

  Future<String?> createRoom(RTCVideoRenderer remoteRenderer) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection("ROOMS").doc();

    print('Create PeerConnection with configuration: $configuration');

    try {
      peerConnection = await createPeerConnection(configuration);
      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Collect ICE candidates
      var callerCandidatesCollection = roomRef.collection("callerCandidates");

      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        print("Got candidate: ${candidate.toMap()}");
        callerCandidatesCollection.add(candidate.toMap());
      };

      // Create offer and set it as local description
      RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
      await roomRef.set(roomWithOffer);
      roomID = roomRef.id;

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print("Got remote track: ${event.streams[0]}");
        event.streams[0].getTracks().forEach((track) {
          remoteStream?.addTrack(track);
        });
      };

      // Listen for remote session description
      roomRef.snapshots().listen((snapshot) async {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
              data['answer']['sdp'], data['answer']['type']);
          await peerConnection?.setRemoteDescription(answer);
        }
      });

      // Listen for remote ice candidates
      roomRef.collection("callerCandidates").snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data =
                change.doc.data() as Map<String, dynamic>;
            print("Got new remote ICE candidates: ${jsonEncode(data)}");
            peerConnection!.addCandidate(
              RTCIceCandidate(
                  data['candidate'], data['sdpMid'], data['sdpMLineIndex']),
            );
          }
        });
      });

      return roomID;
    } catch (e) {
      print("Error creating room: $e");
      return null;
    }
  }

  Future<void> joinRoom(String roomID) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection("ROOMS").doc(roomID);

    try {
      var roomSnapshot = await roomRef.get();
      print("Got room: ${roomSnapshot.exists}");

      if (roomSnapshot.exists) {
        print("Create peerConnection with configuration: $configuration");

        peerConnection = await createPeerConnection(configuration);
        registerPeerConnectionListeners();

        localStream?.getTracks().forEach((track) {
          peerConnection?.addTrack(track, localStream!);
        });

        var calleeCandidatesCollection = roomRef.collection("calleeCandidates");

        peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
          print("Got candidate: ${candidate.toMap()}");
          calleeCandidatesCollection.add(candidate.toMap());
        };

        peerConnection?.onTrack = (RTCTrackEvent event) {
          print("Got remote track: ${event.streams[0]}");
          event.streams[0].getTracks().forEach((track) {
            remoteStream?.addTrack(track);
          });
        };

        var data = roomSnapshot.data() as Map<String, dynamic>;
        var offer = data['offer'];
        await peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']),
        );

        var answer = await peerConnection!.createAnswer();
        await peerConnection!.setLocalDescription(answer);

        Map<String, dynamic> roomWithAnswer = {
          'answer': {'type': answer.type, 'sdp': answer.sdp}
        };

        await roomRef.update(roomWithAnswer);

        // Listen for remote ICE candidates
        roomRef.collection("callerCandidates").snapshots().listen((snapshot) {
          snapshot.docChanges.forEach((change) {
            if (change.type == DocumentChangeType.added) {
              Map<String, dynamic> data =
                  change.doc.data() as Map<String, dynamic>;
              print("Got new remote ICE candidates: ${jsonEncode(data)}");
              peerConnection!.addCandidate(
                RTCIceCandidate(
                    data['candidate'], data['sdpMid'], data['sdpMLineIndex']),
              );
            }
          });
        });
      }
    } catch (e) {
      print("Error joining room: $e");
    }
  }

  Future<void> openUserMedia(
      RTCVideoRenderer localVideo, RTCVideoRenderer remoteVideo) async {
    try {
      var stream = await navigator.mediaDevices
          .getUserMedia({'video': true, 'audio': true});
      localVideo.srcObject = stream;
      localStream = stream;
      remoteVideo.srcObject = await createLocalMediaStream("key");
    } catch (e) {
      print("Error opening user media: $e");
    }
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    try {
      List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
      tracks.forEach((track) {
        track.stop();
      });

      remoteStream?.getTracks().forEach((track) => track.stop());

      peerConnection?.close();

      if (roomID != null) {
        var db = FirebaseFirestore.instance;
        var roomRef = db.collection("ROOMS").doc(roomID);
        var calleeCandidates =
            await roomRef.collection("calleeCandidates").get();
        calleeCandidates.docs
            .forEach((document) => document.reference.delete());

        var callerCandidates =
            await roomRef.collection("callerCandidates").get();
        callerCandidates.docs
            .forEach((document) => document.reference.delete());

        await roomRef.delete();
      }

      localStream?.dispose();
      remoteStream?.dispose();
    } catch (e) {
      print("Error hanging up: $e");
    }
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print("ICE gathering state changed: $state");
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print("Connection State Change: $state");
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print("Signaling state change: $state");
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}
