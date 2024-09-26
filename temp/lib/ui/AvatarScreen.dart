
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/src/multipart_file.dart' as MultipartFile;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../VO/Internet_msg.dart';
import '../common/LoginPrefs.dart';
import '../method/crop/crop_editor_helper.dart';

class AvatarScreen extends StatefulWidget {
  final String header;
  const AvatarScreen({required this.header});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {

  final GlobalKey<ExtendedImageEditorState> editorKey =
  GlobalKey<ExtendedImageEditorState>();
  bool _cropping = false;
  //String header  = "https://aptWebApi.langsi.com.cn/upload/userinfo/"+LoginPrefs.getUSERFILDID().toString();;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: ExtendedImage.file(
        File(widget.header),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        enableLoadState: true,
        extendedImageEditorKey: editorKey,
        cacheRawData: true,
        //maxBytes: 1024 * 50,
        initEditorConfigHandler: (ExtendedImageState? state) {
          return EditorConfig(
              maxScale: 4.0,
              cropRectPadding: const EdgeInsets.all(20.0),
              hitTestSize: 40.0,
              initCropRectType: InitCropRectType.imageRect,
              cropAspectRatio: CropAspectRatios.ratio1_1,
              editActionDetailsIsChanged: (EditActionDetails? details) {
                //print(details?.totalScale);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.task_alt),
          onPressed: () {
            cropImage();
          }),
    );
  }

  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }
    print(_cropping);
    _cropping = true;
    try {
      final Uint8List fileData = Uint8List.fromList((await cropImageDataWithNativeLibrary(
          state: editorKey.currentState!))!);

      saveImage(fileData);
      //return;
      // 图片保存到本地
      //print(fileData);

      // final String? fileFath =
      // await ImageSaver.save('extended_image_cropped_image.jpg', fileData);
      // print('save image : $fileFath');
    } finally {
      _cropping = false;
    }
  }
  void saveImage(Uint8List imageByte) async {
    print(imageByte.length);
    var tmpDir = await getTemporaryDirectory();
    var file = await File("${tmpDir.path}/image_${DateTime.now().microsecond}.jpg").create();
    file.writeAsBytesSync(imageByte);
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"file": await MultipartFile.MultipartFile.fromFile(file.path)});
    String url = "${urlModel.url}/file/upload";
    Response response = await dio.post(url, data: formData);
    var result = response.data;
    updateuserHader(result["data"]);
    setState(() {
      LoginPrefs.saveUSERFILDID(result["data"]);
    });
  }
  Future<void> updateuserHader(String image) async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"empNo":LoginPrefs.getToken().toString(),"fileid":image});
    String url = "${urlModel.url}/user/update";
    Response response = await dio.post(url, data: formData);
    var result = response.data;
    LoginPrefs.saveUSERFILDID(image);
    Navigator.pop(context,true);
  }
}

