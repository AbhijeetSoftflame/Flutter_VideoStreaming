import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_play/models/channel_model.dart';
import 'package:video_play/models/video_model.dart';
import 'package:video_play/screens/video_screen.dart';
import 'package:video_play/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homescreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Channel _channel;
  bool _isLoading = false;
  Video video;
  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCsT0YIqwnpJCM-mx7-gSA4Q');
    setState(() {
      _channel = channel;
    });
    await _loadMoreVideos();
  }

  _navigateToPlayVideo(videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoScreen(id: videoId),
      ),
    );
  }

  Widget _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => {_navigateToPlayVideo(video.id)},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        padding: EdgeInsets.all(10.0),
        height: 300.0,
        width: 400,
        color: Colors.yellow[100],
        child: Column(
          children: <Widget>[
            Image(
              width: 200,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  Widget _displayCoursal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 2),
          scrollDirection: Axis.horizontal,
        ),
        items: _channel.videos.map((item) => _buildVideo(item)).toList(),
      ),
    );
  }


  Widget _displayCoursalforBlob() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 2),
          scrollDirection: Axis.horizontal,
        ),
        items: [
          GestureDetector(
            onTap: () => {_navigateToPlayVideo("000")},
            child: Container(
              width: 250,
              color: Colors.green[200],
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
               Container(
                 height: 200,
                 child: Image.asset('images/blobi.png')),
                   Text("Blob Video Play")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Video Player'),
          automaticallyImplyLeading: false,
        ),
        body: _channel != null
            ? NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollDetails) {
                  if (!_isLoading &&
                      _channel.videos.length != 7 &&
                      scrollDetails.metrics.pixels ==
                          scrollDetails.metrics.maxScrollExtent) {
                    _loadMoreVideos();
                  }
                  return false;
                },
                child: Column(
                  children: <Widget>[
                    _displayCoursal(),
                    SizedBox(
                      height: 40,
                    ),
                    _displayCoursalforBlob(),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ));
  }
}
