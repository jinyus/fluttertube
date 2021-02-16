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
        GestureDetector(
          onVerticalDragUpdate: (details) {
            context.readVideoController.minimizeDragUpdate(details.globalPosition.dy);
          },
          onVerticalDragEnd: (details) {
            context.readVideoController.minimizeEnded(details.primaryVelocity);
          },
          child: Container(
            constraints: BoxConstraints(maxHeight: context.screenSize.height * 0.65),
            width: double.infinity,
            child: VideoPlayer(),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
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
              ...sampleVideos.map((v) => VideoCard(video: v)).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
