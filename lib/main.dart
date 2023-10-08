import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(
    const MaterialApp(
      home: MyScreen(),
    ),
  );
}

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);
  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  late final player = Player();
  late final controller = VideoController(player);
  String? videoPath;
  String? videoUrl;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> selectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      setState(() {
        videoPath = result.files.single.path;
        videoUrl = null; // 清空视频URL
      });
      player.stop();
      player.open(Media(videoPath!));
      player.play();
    }
  }

  void playVideoFromUrl() {
    if (videoUrl != null) {
      setState(() {
        videoPath = null; // 清空视频路径
      });
      player.stop();
      player.open(Media(videoUrl!));
      player.play();
    }
  }

  Widget buildVideoWidget() {
    if (videoPath != null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        child: Video(
          controller: controller,
        ),
      );
    } else if (videoUrl != null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        child: Video(
          controller: controller,
        ),
      );
    } else {
      return const Text('No video selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            buildVideoWidget(),
            const SizedBox(height: 16.0),
            if (videoPath == null)
              TextField(
                onChanged: (value) {
                  setState(() {
                    videoUrl = value.trim();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter video URL',
                ),
              ),
            const SizedBox(height: 16.0),
            if (videoPath == null && videoUrl == null)
              ElevatedButton(
                onPressed: selectVideo,
                child: const Text('Select Video File'),
              ),
            if (videoPath == null&&videoUrl != null)
              ElevatedButton(
                onPressed: playVideoFromUrl,
                child: const Text('Play Video'),
              ),
          ],
        ),
      ),
    );
  }
}