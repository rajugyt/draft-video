import 'package:draft_video_app/draftvideo_model.dart';
import 'package:hive/hive.dart';

class BoxRepo {
  static final BoxRepo boxRepo = BoxRepo._internal();
  factory BoxRepo() {
    return boxRepo;
  }
  BoxRepo._internal();

  Future<void> initBoxes() async {
    await openDraftBox();
  }

  List<DraftVideoModel> localDraftList = [];

  Future<Box<DraftVideoModel>> openDraftBox() =>
      Hive.openBox<DraftVideoModel>('drafts');

  Box<DraftVideoModel> getDraftBox() => Hive.box<DraftVideoModel>('drafts');

  Future addSingleDraft(DraftVideoModel draftObject) async {
    final draftBox = boxRepo.getDraftBox();
    await draftBox.put(draftObject.description, draftObject);
    print("Draft saved succesfully");
    return true;
  }

  Future<void> deleteSingleDraft(String id) async {
    final draftBox = boxRepo.getDraftBox();
    await draftBox.delete(id);
  }

  List<DraftVideoModel> get getDraftList {
    final draftBox = boxRepo.getDraftBox();
    boxRepo.localDraftList = draftBox.values.toList();
    return boxRepo.localDraftList;
  }
}
