part of 'video_page.dart';

class _RegularPlayer extends StatelessWidget {
  const _RegularPlayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    final video = controller.nowPlaying;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 1.0) {
                context.readVideoController.minimize();
              }
              // print(details.delta);
            },
            child: Container(
              constraints: BoxConstraints(maxHeight: context.screenSize.height * 0.65),
              width: double.infinity,
              child: VideoPlayer(),
            ),
          ),
        ),
        _InfoBox(video),
        _ActionBar(video),
        Divider(),
        Row(
          children: [
            Text('Up next'),
            Spacer(),
            Text('Autoplay'),
            Switch(value: true, onChanged: (_) {}),
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              ...sampleVideos.map((v) => VideoCard(video: v)).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
