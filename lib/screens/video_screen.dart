import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  VideoScreen({this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controller;
  VideoPlayerController _controllerBlob;
  Future<void> _initializeVideoPlayerFuture;

  bool _isBlobVideo = false;
  bool _playVideo = true;
  bool _muteVideo = false;

  @override
  void initState() {
    super.initState();
    if (widget.id == '000') {
      _isBlobVideo = true;
    }

    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  void initializeBlobController() async {
    String url='https://rolladevclientimages.blob.core.windows.net/client1/SampleVideo_1280x720_5mb.mp4?sp=rl&st=2020-04-27T19:11:21Z&se=2020-05-07T19:11:00Z&sv=2019-10-10&sr=b&sig=D7VD2fkk2%2FXAZdM6yzel9v7OqbolDCcoSa5RQPLXLIg%3D';

    _controllerBlob = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture = _controllerBlob.initialize().then((value) => {
    _controllerBlob.play()
    });
     }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _controllerBlob.dispose();
    super.dispose();
  }

  Widget _controllerPannel(dummyController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
           icon: _isBlobVideo ? Icon(Icons.pause):Icon(_muteVideo ? Icons.volume_off : Icons.volume_up),
            onPressed: () {
              _isBlobVideo?dummyController.pause():_muteVideo ? dummyController.unMute() : dummyController.mute();
            _isBlobVideo?"":setState(() {
                _muteVideo = !_muteVideo;
              });
            }),
        IconButton(
            icon: Icon(_playVideo && !_isBlobVideo ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              print("PlayVideo is  $_playVideo");
              // dummyController.pause();
            _isBlobVideo?dummyController.play() : _playVideo ? dummyController.pause() : dummyController.play();
             _isBlobVideo? "": setState(() {
                _playVideo = !_playVideo;
              });
            }),
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              dummyController.seekTo(Duration(seconds: 00));
            }),
      ],
    );
  }

  Widget _playYouTubeVideo() {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }

  Widget _playBlobVideo() {
    initializeBlobController();
   return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
          return  AspectRatio(
                                aspectRatio: _controllerBlob.value.aspectRatio,
                                child: VideoPlayer(_controllerBlob),
                              );
          }else{
            return Container(
                              child: AspectRatio(
                                aspectRatio: 16/9,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          _isBlobVideo ? _playBlobVideo() : _playYouTubeVideo(),
          SizedBox(
            height: 30,
          ),
         _isBlobVideo? _controllerPannel(_controllerBlob):_controllerPannel(_controller)
        ],
      ),
    );
  }
}
