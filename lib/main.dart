import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yt_downloader/core/utils/extractors/youtube_extractor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }
  var recieved = 0;
  var progress = 0.0;

  Future<String> downloadYTAudio(String url) async {
    var videoId = url.split("v=")[1].split("&")[0];
    var audioStream = await downloadYTVideoAudio(url);
    // audioStream = audioStream.asBroadcastStream();

    var downloadsFolderPath =
        await getApplicationDocumentsDirectory().then((value) => value.path);

    downloadsFolderPath = "$downloadsFolderPath/Omni_YT_Downloader";

    if (!Directory(downloadsFolderPath).existsSync()) {
      Directory(downloadsFolderPath).createSync();
    }

    debugPrint(downloadsFolderPath);

    var audioFile = File('$downloadsFolderPath/$videoId.mp3');
    var audioFileStream = audioFile.openWrite();
    // var length = await audioStream.length;
    // Future.doWhile(() async {
    //   recieved = await audioFile.length();

    //   if (recieved == 0) {
    //     return true;
    //   }
    //   progress = ((length / recieved) * 100).toDouble();
    //   setState(() {});
    //   return recieved != length;
    // });
    await audioStream.pipe(audioFileStream);
    await audioFileStream.flush();
    await audioFileStream.close();
    return audioFile.path;
  }

  Future<String> downloadYTVideo(String url) async {
    var videoId = url.split("v=")[1].split("&")[0];
    var videoStream = await downloadYTVideoVideo(url);
    // videoStream = videoStream.asBroadcastStream();
    var downloadsFolderPath =
        await getApplicationDocumentsDirectory().then((value) => value.path);

    downloadsFolderPath = "$downloadsFolderPath/Omni_YT_Downloader";

    if (!Directory(downloadsFolderPath).existsSync()) {
      Directory(downloadsFolderPath).createSync();
    }

    debugPrint(downloadsFolderPath);

    var videoFile = File('$downloadsFolderPath/$videoId.mp4');
    var videoFileStream = videoFile.openWrite();
    // var length = await videoStream.length;
    // Future.doWhile(() async {
    //   recieved = await videoFile.length();

    //   if (recieved == 0) {
    //     return true;
    //   }
    //   progress = ((length / recieved) * 100).toDouble();
    //   setState(() {});

    //   return recieved != length;
    // });
    await videoStream.pipe(videoFileStream);
    await videoFileStream.flush();
    await videoFileStream.close();
    recieved = 0;
    progress = 0.0;
    return videoFile.path;
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 73, 31, 121),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Input video URL:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 92, 151, 94),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter video URL',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final url = _controller.text;
                      final videoPath = await downloadYTVideo(url);
                      debugPrint("Video: $videoPath");
                    },
                    child: const Text('Download Video',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final url = _controller.text;
                      final audioPath = await downloadYTAudio(url);
                      debugPrint("Audio: $audioPath");
                    },
                    child: const Text('Download Audio',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Text(
              //   'Progress: $progress',
              //   style: const TextStyle(
              //     color: Colors.white,
              //   ),
              // ),
              // progress == 0
              //     ? Container()
              //     : LinearProgressIndicator(
              //         value: progress / 100,
              //         color: Theme.of(context).colorScheme.primary,
              //         minHeight: 5,
              //         backgroundColor: Colors.grey[500],
              //       ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
