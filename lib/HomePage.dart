import 'dart:io';
import 'dart:math';

import 'package:draft_video_app/BoxRepo.dart';
import 'package:draft_video_app/buildVideoThumbnail.dart';
import 'package:draft_video_app/draftvideo_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String basePath = '';

  Future<Uint8List> getVideoThumbnail(File videofile) async {
    final Uint8List? uint8list = await VideoThumbnail.thumbnailData(
      video: videofile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return uint8list!;
  }

  void pickVideo() async {
    print("Pick started");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      // allowedExtensions: ['mp4', 'jpg'],
    );

    print(result);
    print(result?.files.first.path);

    File videofile = File(result?.files.first.path ?? "");
    Uint8List videoThumbnail = await getVideoThumbnail(videofile);
    String fileName = result?.files.first.name ?? "";
    String description = "${Random().nextDouble() * 1000}Hello World";
    // saveDraft(selectedFile, fileName, description);
    saveFile(videofile, videoThumbnail, fileName, description);
  }

  void saveDraft(File file, Uint8List videoThumbnail, String fileName,
      String desctiotion) async {
    final boxRepo = BoxRepo();
    final draftObject = DraftVideoModel(
        videoFilePath: file.path,
        description: desctiotion,
        videoThumbnail: videoThumbnail);
    await boxRepo.addSingleDraft(draftObject);
    print("Draft saved succesfully");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    print(directory.path);

    Directory? appDir = await getExternalStorageDirectory();
    final String filePath = appDir!.path;
    final String fileOgPath =
        '${filePath.replaceAll("Android/data/com.example.draft_video_app/files", '')}Download/';
    print(filePath);
    print(fileOgPath);
    return directory.path;
  }

  // /Declare Globaly
  String directory = '';

  // List<FileSystemEntity> fileListStream = [];
  List<DraftVideoModel> alldraftedVideosList = [];
  List<DraftVideoModel> draftedVideosList = [];
  bool loading = true;

  // Make New Function
  void refreshDrafts() async {
    // directory = await _localPath;
    draftedVideosList.clear();
    alldraftedVideosList = BoxRepo().getDraftList;

    setState(() {
      loading = true;
    });
    for (var draftModel in alldraftedVideosList) {
      if (await File(draftModel.videoFilePath!).exists()) {
        draftedVideosList.add(draftModel);
      } else {
        deleteDraft(draftModel);
      }
    }

    setState(() {
      loading = false;
    });
  }

  void saveFile(File selectedFile, Uint8List videoThumbnail, String fileName,
      String description) async {
    try {
      Directory? appDir;
      //working with file
      if (Platform.isAndroid) {
        appDir = await getExternalStorageDirectory();
      } else {
        appDir = await getTemporaryDirectory();
      }

      final String filePath = appDir!.path;
      // final String fileOgPath =
      //     '${filePath.replaceAll("Android/data/com.example.draft_video_app/files", '')}Proj64/drafts';
      basePath = filePath;
      String fileName1 = fileName;
      final path = "$basePath/$fileName1";
      // final file = File("$fileOgPath/$fileName.pdf");
      // final file = File(path);

      File copiedFIle = await selectedFile.copy(path);
      // Future<Uint8List> unit8List = copiedFIle.readAsBytes();
      saveDraft(copiedFIle, videoThumbnail, fileName, description);
    } catch (e) {
      print("Error in copying file: $e");
    }
  }

  checkPermission() async {
    if (await Permission.storage.isGranted) {
      return;
    } else {
      Permission.storage.request().then((value) => print(value.toString()));
    }
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  void deleteDraft(DraftVideoModel draftVideoModel) async {
    print(draftVideoModel.description);
    await BoxRepo().deleteSingleDraft(draftVideoModel.description!);
    await File(draftVideoModel.videoFilePath!).delete();
    print("Draft Deleted");

    refreshDrafts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Pick File and save"),
        actions: [TextButton(onPressed: () {}, child: const Text("Drafts"))],
      ),
      body: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => _localPath,
                child: const Text("Print app local path")),
            ElevatedButton(
                onPressed: () => pickVideo(), child: const Text("Pick Video")),
            ElevatedButton(
                onPressed: () => refreshDrafts(),
                child: const Text("Refresh Drafts")),
            Expanded(
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: draftedVideosList.length,
                        itemBuilder: (context, index) {
                          print(draftedVideosList[index].description);
                          // return ListTile(
                          //   title: Text(fileListStream[index].toString()),

                          // );
                          return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BuildVideoThumbnail(
                                      fileParameter: File(
                                          draftedVideosList[index]
                                              .videoFilePath!)),
                                ));
                              },
                              child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.memory(
                                          draftedVideosList[index]
                                              .videoThumbnail!,
                                          height: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "PATH: ${draftedVideosList[index].videoFilePath!}",
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.visible),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "Description: ${draftedVideosList[index].description!}",
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.visible),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () => deleteDraft(
                                              draftedVideosList[index]),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
                                  )));
                        }))
          ],
        ),
      ),
    );
  }
}
