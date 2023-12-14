import 'package:flutter/material.dart';
import 'package:podivy/service/auth/podcaster/podcasterData.dart';
import 'package:text_scroll/text_scroll.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late Map<String, dynamic> _getData;
  late String title;
  late PodcasterData podcasterData;

  bool isPlaying = false;
  double progress = 0.3; // 示例进度值
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData = Get.arguments;
    title = _getData['title'];
    podcasterData = _getData['podcasterData'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 歌曲封面
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(podcasterData.imagePath)), // 可以替换成实际的封面图片
            ),
            // 歌曲封面图片可以放在这里
          ),
          const SizedBox(height: 20),
          // 歌曲信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextScroll(
              title,
              fadedBorder: true,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              intervalSpaces: 12,
              velocity: const Velocity(pixelsPerSecond: Offset(80, 0)),
              delayBefore: const Duration(seconds: 1),
              pauseBetween: const Duration(seconds: 2),
            ),
          ),
          Text(
            podcasterData.name,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // 进度条
          Slider(
            value: progress,
            onChanged: (value) {
              setState(() {
                progress = value;
              });
            },
          ),
          const SizedBox(height: 20),
          // 控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 快退按钮
              IconButton(
                icon: Icon(Icons.replay_10),
                onPressed: () {
                  // 处理快退逻辑
                },
              ),
              const SizedBox(width: 20),
              // 播放/暂停按钮
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
              ),
              const SizedBox(width: 20),
              // 快进按钮
              IconButton(
                icon: Icon(Icons.forward_10),
                onPressed: () {
                  // 处理快进逻辑
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 上一曲按钮
          IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: () {
              // 处理上一曲逻辑
            },
          ),
          const SizedBox(height: 20),
          // 下一曲按钮
          IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: () {
              // 处理下一曲逻辑
            },
          ),
        ],
      ),
    );
  }
}
