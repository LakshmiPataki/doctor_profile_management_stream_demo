import 'dart:async';

import 'package:doctor/blocs/DoctorDetailViewBlock.dart';
import 'package:doctor/blocs/HomeScreenBlock.dart';
import 'package:doctor/data/Database.dart';
import 'package:doctor/model/DoctorListResponseModel.dart';
import 'package:doctor/process/ContactProcess.dart';
import 'package:doctor/ui/DoctorDetailEditScreen.dart';
import 'package:doctor/utility/AppUtill.dart';
import 'package:doctor/utility/Loader.dart';
import 'package:flutter/cupertino.dart';

class DoctorDetailEditBLOC{
  String profilePicture="";

  final _fnameStreamController=StreamController<String>();
  StreamSink<String> get fNameSink =>_fnameStreamController.sink;
  Stream<String> get fNameStream =>_fnameStreamController.stream;

  final _lnameStreamController=StreamController<String>();
  StreamSink<String> get lNameSink =>_lnameStreamController.sink;
  Stream<String> get lNameStream =>_lnameStreamController.stream;

  final _dobStreamController=StreamController<String>();
  StreamSink<String> get dobSink =>_dobStreamController.sink;
  Stream<String> get dobStream =>_dobStreamController.stream;

  final _heightStreamController=StreamController<String>();
  StreamSink<String> get heightSink =>_heightStreamController.sink;
  Stream<String> get heightStream =>_heightStreamController.stream;

  final _weightStreamController=StreamController<String>();
  StreamSink<String> get weightSink =>_weightStreamController.sink;
  Stream<String> get weightStream =>_weightStreamController.stream;


  final _bgStreamController=StreamController<String>();
  StreamSink<String> get bgSink =>_bgStreamController.sink;
  Stream<String> get bgStream =>_bgStreamController.stream;

  final _genderStreamController=StreamController<String>();
  StreamSink<String> get genderSink =>_genderStreamController.sink;
  Stream<String> get genderStream =>_genderStreamController.stream;


  final _profileStreamController=StreamController<String>();
  StreamSink<String> get profileSink =>_profileStreamController.sink;
  Stream<String> get profileStream =>_profileStreamController.stream;


  DoctorListResponseModel _doctorListResponseModel;
  DoctorDetailEditBLOC(this._doctorListResponseModel)
  {
    fNameStream.listen((value) {
      this._doctorListResponseModel.first_name=value.toString();
      AppUtill.printAppLog("value::${value.toString()}");
    });

    lNameStream.listen((value) {
      this._doctorListResponseModel.last_name=value.toString();
      AppUtill.printAppLog("value::${value.toString()}");
    });

    dobStream.listen((value) {
      this._doctorListResponseModel.dob=value.toString();
      AppUtill.printAppLog("value::${value.toString()}");
    });

    heightStream.listen((value) {
      this._doctorListResponseModel.height=value.toString();
      AppUtill.printAppLog("value::${value.toString()}");
    });

    weightStream.listen((value) {
      this._doctorListResponseModel.weight=value.toString();
      AppUtill.printAppLog("value::${value.toString()}");
    });

    bgStream.listen((value) {
      this._doctorListResponseModel.blood_group=value.toString();
      AppUtill.printAppLog("value::${value.toString()}");
    });

    genderStream.listen((value) {
      this._doctorListResponseModel.gender=value.toString();
      AppUtill.printAppLog("value::${value.toString()}");
    });

    profileStream.listen((value) {
      this.profilePicture=value;
      AppUtill.printAppLog("value::${value.toString()}");
    });

  }

  updateContactDetails(BuildContext context)
  {
    if(AppUtill.isValid(profilePicture))
      {
        this._doctorListResponseModel.profile_pic=profilePicture;
      }
    this._doctorListResponseModel.isEdited=true;
    DBProvider.db.updateNote(this._doctorListResponseModel);
    DBProvider.db.getNotes().then((value) {
      AppUtill.printAppLog("DBProvider.db.getNotes.length:: ${value?.length}");
      listStreamCOntroller.add(value!);
    });
    viewStreamController.add(this._doctorListResponseModel);
    DBProvider.db.getNoteTopThree().then((value) {
      carouselSliderStreamController.add(value!);
    });
    AppUtill.showToast("Record Updated Successfully", context);
    Navigator.pop(context);
  }


}