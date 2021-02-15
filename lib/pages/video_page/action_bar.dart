part of 'video_page.dart';

class _ActionBar extends StatelessWidget {
  final Video video;

  const _ActionBar(this.video, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Icons.thumb_up),
              SizedBox(height: 8),
              Text('2.8k'),
            ],
          ),
          Column(
            children: [
              Icon(Icons.thumb_down),
              SizedBox(height: 8),
              Text('311'),
            ],
          ),
          GestureDetector(
            onTap: () => context.readVideoController.minimize(),
            child: Column(
              children: [
                Icon(Icons.share),
                SizedBox(height: 8),
                Text('Share'),
              ],
            ),
          ),
          Column(
            children: [
              Icon(Icons.add_to_photos),
              SizedBox(height: 8),
              Text('Save'),
            ],
          ),
        ],
      ),
    );
  }
}
