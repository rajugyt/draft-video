import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

part 'draftvideo_model.g.dart';

@HiveType(typeId: 0)
class DraftVideoModel extends HiveObject {
  @HiveField(0)
  String? description;

  @HiveField(1)
  String? videoFilePath;

  @HiveField(2)
  Uint8List? videoThumbnail;

  DraftVideoModel({this.description, this.videoFilePath, this.videoThumbnail});
}
