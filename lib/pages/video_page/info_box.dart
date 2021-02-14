part of 'video_page.dart';

class _InfoBox extends StatelessWidget {
  final Video video;

  const _InfoBox(this.video, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kDefaultEdgeInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  video.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Icon(Icons.arrow_drop_down, size: 30),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${video.views} · ${video.published}',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
