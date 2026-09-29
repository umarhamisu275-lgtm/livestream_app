import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class LiveStreamScreen extends StatefulWidget {
  final String channelName;
  final bool isBroadcaster; // true idan Celebrity ne, false idan Mai Kallo ne

  const LiveStreamScreen({
    super.key,
    required this.channelName,
    required this.isBroadcaster,
  });

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  // Sanya Agora App ID Dinka a Nan
  final String appId = "YOUR_AGORA_APP_ID";

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // 1. Qirqirar Agora Engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));

    // 2. Sauraron Al'amuran Live (Events)
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          setState(() => _remoteUid = null);
        },
      ),
    );

    await _engine.enableVideo();

    // 3. Zaɓar matsayi (Broadcaster ko Audience)
    if (widget.isBroadcaster) {
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine.startPreview();
    } else {
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    }

    // 4. Shiga Live Stream Channel
    await _engine.joinChannel(
      token: '', // Yi amfani da Token idan ka kunna Agora Security
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // View din Bidiyo
          Center(child: _renderVideo()),

          // Maballin Fita Daga Live (End/Leave Stream)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderVideo() {
    if (widget.isBroadcaster) {
      return _localUserJoined
          ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            )
          : const CircularProgressIndicator();
    } else {
      return _remoteUid != null
          ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine,
                canvas: VideoCanvas(uid: _remoteUid),
                connection: RtcConnection(channelId: widget.channelName),
              ),
            )
          : const Text(
              'Ana Jiran Celebrity Ya Fara Live...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            );
    }
  }
}
