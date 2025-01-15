// import 'dart:io';

// import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<AudioOnlyStreamInfo> getYTVideoAudioData(String url) async {
  var videoId = url.split("v=")[1].split("&")[0];
  var yt = YoutubeExplode();
  var manifest = await yt.videos.streamsClient.getManifest(videoId);
  var streamInfo = manifest.audioOnly.withHighestBitrate();
  debugPrint("Audio: ${streamInfo.toString()}");
  return streamInfo;
}

Future<Stream<List<int>>> downloadYTVideoAudio(String url) async {
  var videoId = url.split("v=")[1].split("&")[0];
  var yt = YoutubeExplode();
  var manifest = await yt.videos.streamsClient.getManifest(videoId);
  var streamInfo = manifest.audioOnly.withHighestBitrate();
  debugPrint("Audio: ${streamInfo.toString()}");

  var audioStream = yt.videos.streamsClient.get(streamInfo);

  return audioStream;
}

Future<VideoStreamInfo> getYTVideoVideoData(String url) async {
  var videoId = url.split("v=")[1].split("&")[0];
  var yt = YoutubeExplode();
  var manifest = await yt.videos.streamsClient.getManifest(videoId);
  var streamInfo = manifest.videoOnly.withHighestBitrate();
  debugPrint("Video: ${streamInfo.toString()}");
  return streamInfo;
}

Future<Stream<List<int>>> downloadYTVideoVideo(String url) async {
  var videoId = url.split("v=")[1].split("&")[0];
  var yt = YoutubeExplode();
  var manifest = await yt.videos.streamsClient.getManifest(videoId);
  VideoOnlyStreamInfo? highestQualityMp4;
  try {
    highestQualityMp4 = manifest.videoOnly
        .where((e) => e.container == StreamContainer.mp4)
        .withHighestBitrate();
  } catch (e) {
    debugPrint(e.toString());
  }
  VideoOnlyStreamInfo? highestQualityWebm;

  try {
    highestQualityWebm = manifest.videoOnly
        .where((e) => e.container == StreamContainer.webM)
        .withHighestBitrate();
  } catch (e) {
    debugPrint(e.toString());
  }

  var highestQuality = highestQualityMp4;
  highestQuality ??= highestQualityWebm;

  if ((highestQualityWebm?.bitrate.bitsPerSecond ?? 0) >
      highestQuality!.bitrate.bitsPerSecond) {
    highestQuality = highestQualityWebm;
  }

  debugPrint("Video: ${highestQuality.toString()}");
  var streamInfo = highestQuality;

  return yt.videos.streamsClient.get(streamInfo!);
}
