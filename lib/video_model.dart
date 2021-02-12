import 'package:flutter/cupertino.dart';

class Video {
  final String imgSrc;
  final String title;
  final String views;
  final String published;
  final String duration;
  final int id;

  const Video({
    @required this.id,
    @required this.imgSrc,
    @required this.title,
    @required this.views,
    @required this.published,
    @required this.duration,
  });

  Video withId(int id) {
    return Video(
      id: id,
      imgSrc: imgSrc,
      title: title,
      views: views,
      published: published,
      duration: duration,
    );
  }
}
