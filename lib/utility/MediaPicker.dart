import 'dart:io';

import 'package:doctor/values/AppSetings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';

import 'AppUtill.dart';

enum MediaSource { CAMERA, GALLERY }

class MediaPicker {
  MediaSource _mediaSource;

  MediaPicker(this._mediaSource);

  getImage(context, inner(File imageFile), {isCroping = false}) async {
    try {
      File? imageFile;
      final picker=ImagePicker();

      if (_mediaSource == MediaSource.GALLERY) {
        final pickedFile=await picker.getImage(source: ImageSource.gallery);
        // imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
        if(pickedFile!=null)
        {
          imageFile=File(pickedFile.path);
        }
        else{
          AppUtill.printAppLog("pickedFile==null");
        }
      } else if (_mediaSource == MediaSource.CAMERA) {
        final pickedFile=await picker.getImage(source: ImageSource.camera);
        // imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
        if(pickedFile!=null)
        {
          imageFile=File(pickedFile.path);
        }
        else{
          AppUtill.printAppLog("pickedFile==null");
        }
      }

      if (isCroping) {
        imageFile =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ImageCroping(imageFile!);
        }));

      }

      inner(imageFile!);

    } catch (e) {
      print(e);
    }
  }
}

class ImageCroping extends StatefulWidget {
  File _sample;

  ImageCroping(this._sample);

  @override
  State<StatefulWidget> createState() {
    return ImageCropWidget();
  }
}

class ImageCropWidget extends State<ImageCroping> {
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.black,
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: _buildCroppingImage(),
      ),
    );
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(widget._sample, key: cropKey),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                child: Text(
                  "crop",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.white),
                ),
                onPressed: () => _cropImage(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: widget._sample,
      preferredSize: (2000 / scale).round(),
    );
//
    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    Navigator.of(context).pop(file);
  }
}
