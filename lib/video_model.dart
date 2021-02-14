import 'package:flutter/material.dart';

class Video {
  final String thumbnail;
  final String src;
  final String title;
  final String views;
  final String published;
  final String duration;
  final int id;

  const Video({
    @required this.id,
    @required this.thumbnail,
    @required this.src,
    @required this.title,
    @required this.views,
    @required this.published,
    @required this.duration,
  });
}
