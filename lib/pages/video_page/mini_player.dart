part of 'video_page.dart';

class _MiniPlayer extends StatelessWidget {
  const _MiniPlayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    final video = controller.nowPlaying;
    return Container(
      height: kMiniPlayerHeight,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: .5, color: Colors.red.shade500),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.maximize,
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -0.8) {
                  controller.maximize();
                }
              },
              child: Container(
                color: Colors.grey[850],
                child: Row(
                  children: [
                    VideoPlayer(),
                    SizedBox(width: 4),
                    Flexible(child: Text(video.title, maxLines: 3, overflow: TextOverflow.ellipsis))
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(controller.miniplayerPaused ? Icons.play_arrow : Icons.pause),
                  onPressed: controller.toggleMiniPlayerPause),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: controller.stopPlaying,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
