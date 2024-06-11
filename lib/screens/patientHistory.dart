import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/PhysicalExam_model.dart';
import 'package:vetplanet/models/dental_model.dart';
import 'package:vetplanet/models/dermato_model.dart';
import 'package:vetplanet/models/lamenesss_model.dart';
import 'package:vetplanet/models/neuroPosture_model.dart';
import 'package:vetplanet/models/neuroSpinal_model.dart';
import 'package:vetplanet/models/operative_model.dart';
import 'package:vetplanet/models/ophto_model.dart';
import 'package:vetplanet/models/soapNote_model.dart';
import 'dash.dart';
import 'drawer.dart';

class PatientHistoryPage extends StatefulWidget {
  final String vetId;
  final String petId;
  final String fromDate;
  final String toDate;

  PatientHistoryPage({ this.vetId, this.petId, this.fromDate, this.toDate});
  @override
  _PatientHistoryPageState createState() => _PatientHistoryPageState();
}

class _PatientHistoryPageState extends State<PatientHistoryPage> {


  void rebuildPage() {
    setState(() {});
  }

  var splitSOAPNote1;
  var splitSOAPNote2;
  Future<List> _futurSOAPNote;
  String _soapLenght = "";
  Future<List<SOAPNoteModel>> getSOAPNote() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetSoapNote/GetSoapNote";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<SOAPNoteModel> _saop = _response
          .map<SOAPNoteModel>(
              (_json) => SOAPNoteModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_saop}');
      setState(() {
        _soapLenght = _saop.length.toString();
        debugPrint('Check _soapLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_soapLenght}');

      });
      return _saop;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurPhysicalExam;
  String _physicalExamLenght = "";
  Future<List<PhysicalExamModel>> getPhysicalExam() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetPhysicalExam/GetPhysicalExam";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<PhysicalExamModel> _physicalExam= _response
          .map<PhysicalExamModel>(
              (_json) => PhysicalExamModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_physicalExam}');
      setState(() {
        _physicalExamLenght = _physicalExam.length.toString();
        debugPrint('Check _physicalExamLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_physicalExamLenght}');

      });
      return _physicalExam;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futuroptho;
  String _ophtoLenght = "";
  Future<List<OPHTOModel>> getOphto() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetOptho/GetOptho";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate,
            "Operation":"Date"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<OPHTOModel> _optho= _response
          .map<OPHTOModel>(
              (_json) => OPHTOModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_optho}');
      setState(() {
        _ophtoLenght = _optho.length.toString();
        debugPrint('Check _ophtoLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_ophtoLenght}');

      });
      return _optho;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futuropthoDATA;
  String _ophtoLenghtDATA = "";
  Future<List<OPHTOModel>> getOphtoDATA(String Date) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted date ${Date}');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetOptho/GetOptho";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":Date,
            "ToDate":Date,
            "Operation":"Data"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<OPHTOModel> _optho= _response
          .map<OPHTOModel>(
              (_json) => OPHTOModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_optho}');
      setState(() {
        _ophtoLenghtDATA = _optho.length.toString();
        debugPrint('Check _ophtoLenghtDATA &&&&&&&&&&&&&&&&&&&&&&&&&: $_ophtoLenghtDATA}');

      });
      return _optho;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurLameness;
  String _lamenessLenght = "";
  Future<List<LamenesssModel>> getLameness() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetLameness/GetLameness";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate,
            "Operation":"Date"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<LamenesssModel> _lamenesss= _response
          .map<LamenesssModel>(
              (_json) => LamenesssModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_lamenesss}');
      setState(() {
        _lamenessLenght = _lamenesss.length.toString();
        debugPrint('Check _lamenessLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_lamenessLenght}');

      });
      return _lamenesss;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurLamenessDATA;
  String _lamenessLenghtDATA = "";
  Future<List<LamenesssModel>> getLamenessDATA(String Date) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetLameness/GetLameness";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":Date,
            "ToDate":Date,
            "Operation":"Data"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<LamenesssModel> _lamenesss= _response
          .map<LamenesssModel>(
              (_json) => LamenesssModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_lamenesss}');
      setState(() {
        _lamenessLenghtDATA = _lamenesss.length.toString();
        debugPrint('Check _lamenessLenghtDATA &&&&&&&&&&&&&&&&&&&&&&&&&: $_lamenessLenghtDATA}');

      });
      return _lamenesss;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurNeuroSpinal;
  String _neuroSpinalLenght = "";
  Future<List<NeuroSpinalModel>> getNeuroSpinal() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetNeuroSpinal/GetNeuroSpinal";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate,
            "Operation":"Date"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<NeuroSpinalModel> _neuroSpinal= _response
          .map<NeuroSpinalModel>(
              (_json) => NeuroSpinalModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_neuroSpinal}');
      setState(() {
        _neuroSpinalLenght = _neuroSpinal.length.toString();
        debugPrint('Check _neuroSpinalLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_neuroSpinalLenght}');

      });
      return _neuroSpinal;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurNeuroSpinalDATA;
  String _neuroSpinalLenghtDATA = "";
  Future<List<NeuroSpinalModel>> getNeuroSpinalDATA(String Date) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetNeuroSpinal/GetNeuroSpinal";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":Date,
            "ToDate":Date,
            "Operation":"Data"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<NeuroSpinalModel> _neuroSpinal= _response
          .map<NeuroSpinalModel>(
              (_json) => NeuroSpinalModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_neuroSpinal}');
      setState(() {
        _neuroSpinalLenghtDATA = _neuroSpinal.length.toString();
        debugPrint('Check _neuroSpinalLenghtDATA &&&&&&&&&&&&&&&&&&&&&&&&&: $_neuroSpinalLenghtDATA}');

      });
      return _neuroSpinal;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurOperative;
  String _operativeLenght = "";
  Future<List<OperativeModel>> getOperative() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetOperative/GetOperative";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate,
            "Operation":"Date"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<OperativeModel> _operative= _response
          .map<OperativeModel>(
              (_json) => OperativeModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_operative}');
      setState(() {
        _operativeLenght = _operative.length.toString();
        debugPrint('Check _operativeLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_operativeLenght}');
      });
      return _operative;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurOperativeDATA;
  String _operativeLenghtDATA = "";
  Future<List<OperativeModel>> getOperativeDATA(String Date) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetOperative/GetOperative";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":Date,
            "ToDate":Date,
            "Operation":"Data"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<OperativeModel> _operative= _response
          .map<OperativeModel>(
              (_json) => OperativeModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_operative}');
      setState(() {
        _operativeLenghtDATA = _operative.length.toString();
        debugPrint('Check _operativeLenghtDATA &&&&&&&&&&&&&&&&&&&&&&&&&: $_operativeLenghtDATA}');
      });
      return _operative;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  Future<List> _futurDermato;
  String _dermatoLenght = "";
  Future<List<DermatoModel>> getDermato() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetDermato/GetDermato";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate,
            "Operation":"Date"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<DermatoModel> _dermato= _response
          .map<DermatoModel>(
              (_json) => DermatoModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_dermato}');
      setState(() {
        _dermatoLenght = _dermato.length.toString();
        debugPrint('Check _dermatoLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_dermatoLenght}');
      });
      return _dermato;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurDermatoDATA;
  String _dermatoLenghtDATA = "";
  Future<List<DermatoModel>> getDermatoDATA(String Date) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetDermato/GetDermato";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":Date,
            "ToDate":Date,
            "Operation":"Data"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<DermatoModel> _dermato= _response
          .map<DermatoModel>(
              (_json) => DermatoModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_dermato}');
      setState(() {
        _dermatoLenghtDATA = _dermato.length.toString();
        debugPrint('Check _dermatoLenghtDATA &&&&&&&&&&&&&&&&&&&&&&&&&: $_dermatoLenghtDATA}');
      });
      return _dermato;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  Future<List> _futurNeuroPosture;
  String _neuroPostureLenght = "";
  Future<List<NeuroPostureModel>> getNeuroPosture() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetNeuroPosture/GetNeuroPosture";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate,
            "Operation":"Date"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<NeuroPostureModel> _neuroPosture= _response
          .map<NeuroPostureModel>(
              (_json) => NeuroPostureModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_neuroPosture}');
      setState(() {
        _neuroPostureLenght = _neuroPosture.length.toString();
        debugPrint('Check _neuroPostureLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_neuroPostureLenght}');
      });
      return _neuroPosture;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future<List> _futurNeuroPostureDATA;
  String _neuroPostureLenghtDATA = "";
  Future<List<NeuroPostureModel>> getNeuroPostureDATA(String Date) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetNeuroPosture/GetNeuroPosture";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":Date,
            "ToDate":Date,
            "Operation":"Data"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<NeuroPostureModel> _neuroPosture= _response
          .map<NeuroPostureModel>(
              (_json) => NeuroPostureModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_neuroPosture}');
      setState(() {
        _neuroPostureLenghtDATA = _neuroPosture.length.toString();
        debugPrint('Check _neuroPostureLenghtDATA &&&&&&&&&&&&&&&&&&&&&&&&&: $_neuroPostureLenghtDATA}');
      });
      return _neuroPosture;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  Future<List> _futurDental;
  String _dentalLenght = "";
  Future<List<DentalModel>> getDental() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetDental/GetDental";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":widget.fromDate,
            "ToDate":widget.toDate,
            "Operation":"Date"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<DentalModel> _dental= _response
          .map<DentalModel>(
              (_json) => DentalModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_dental}');
      setState(() {
        _dentalLenght = _dental.length.toString();
        debugPrint('Check _dentalLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_dentalLenght}');
      });
      return _dental;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  Future<List> _futurDentalDATA;
  String _dentalLenghtDATA = "";
  Future<List<DentalModel>> getDentalDATA(String Date) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted _from ${widget.fromDate} ');
    debugPrint('Check Inserted _to ${widget.toDate} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted _RegistrationId ${_RegistrationId} ');
    final String url = "$apiUrl/GetDental/GetDental";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":Date,
            "ToDate":Date,
            "Operation":"Data"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<DentalModel> _dental= _response
          .map<DentalModel>(
              (_json) => DentalModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_dental}');
      setState(() {
        _dentalLenghtDATA = _dental.length.toString();
        debugPrint('Check _dentalLenghtDATA &&&&&&&&&&&&&&&&&&&&&&&&&: $_dentalLenghtDATA}');
      });
      return _dental;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  var dio = Dio();

  void getPermission() async {
    print("getPermission");
    Map<Permission, PermissionStatus> permissions =
    await [Permission.storage].request();
  }



  @override
  void initState() {
    getPermission();
    _futurSOAPNote = getSOAPNote();
    _futurPhysicalExam = getPhysicalExam();
    _futuroptho = getOphto();
    _futurLameness = getLameness();
    _futurNeuroSpinal = getNeuroSpinal();
    _futurOperative = getOperative();
    _futurDermato = getDermato();
    _futurNeuroPosture = getNeuroPosture();
    _futurDental = getDental();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: (Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            gradient: LinearGradient(
              colors: [appColor, appColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        )),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title:
        Text("", style: TextStyle(fontSize:22, fontFamily: "Camphor",
            fontWeight: FontWeight.w900,color: Colors.white),),
        actions: <Widget>[

          new IconButton(
            icon: new Icon(Icons.home, color: Colors.white,),
            tooltip: 'Home',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
            },
          ),
        ],
      ),

      drawer: DrawerPage(),
      body:

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:15, right: 15),
          child: Column(
            children: <Widget>[

              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/soap.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "SOAP Notes",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futurSOAPNote,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<SOAPNoteModel> _soap = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _soap == null ? 0 : _soap.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:  ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${_soap[index].Date}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),
                                        ),
                                        children: <Widget>[
                                          if("${_soap[index].SOAPUpload}" != "-")
                                            ClipRRect(
                                              // borderRadius: BorderRadius.circular(100),
                                              child: Image.network(
                                                "${_soap[index].SOAPUpload}",
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("Subjective : ${_soap[index].Subjective}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("Objective : ${_soap[index].Objective}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("Assessment : ${_soap[index].Assessment}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("Plans : ${_soap[index].Plans}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          if ("${_soap[index].SOAPUpload}" != "-")
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton.icon(
                                                  onPressed: () async {
                                                    String imgUrl = "${_soap[index].SOAPUpload}";
                                                    var splitString = imgUrl.split(".");
                                                    splitSOAPNote1 = splitString[1];
                                                    splitSOAPNote2 = splitString[2];

                                                    print("splitSOAPNote1 : $splitSOAPNote1");
                                                    print("splitSOAPNote2 : $splitSOAPNote2");
                                                    // String path =
                                                    // await ExtStorage.getExternalStoragePublicDirectory(
                                                    //     ExtStorage.DIRECTORY_DOWNLOADS);
                                                    // //String fullPath = tempDir.path + "/boo2.pdf'";
                                                    // String fullPath = "$path/SOAPNote.$splitSOAPNote2";
                                                    // //String fullPath = "$path";
                                                    // print('full path ${fullPath}');

                                                    // download(dio, imgUrl, fullPath);
                                                  },
                                                  icon: Icon(
                                                    Icons.file_download,
                                                    color: Colors.white,
                                                  ),
                                                  // color: Colors.green,
                                                  // textColor: Colors.white,
                                                  label: Text('Download',style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                      fontWeight: FontWeight.w700,color: Colors.white),)),
                                            ),
                                          SizedBox(height: 5,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black,),
              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/physicalExam.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "Physical Exam Details",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futurPhysicalExam,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<PhysicalExamModel> __physicalExam = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: __physicalExam == null ? 0 : __physicalExam.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${__physicalExam[index].Date}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),
                                        ),
                                        children: <Widget>[
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("Weight : ${__physicalExam[index].Weight}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("Temperature : ${__physicalExam[index].TemperatureC} - ${__physicalExam[index].Temperature}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("Heart Rate : ${__physicalExam[index].HeartRate}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("RespirationRate : ${__physicalExam[index].RespirationRate}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("BP Systolic : ${__physicalExam[index].BPSystolic}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("BP Diastolic : ${__physicalExam[index].BPDiastolic}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("CapillaryRefillTime : ${__physicalExam[index].CapillaryRefillTime}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                            title: Text("MucousMembrane : ${__physicalExam[index].MucousMembrane}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black,),
              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/optho.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "Ophthalmologic Exam Details",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futuroptho,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<OPHTOModel> _optho = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _optho == null ? 0 : _optho.length,
                              itemBuilder: (BuildContext context, int index) {

                                 String Date = "${_optho[index].Date}";
                                 _futuropthoDATA =  getOphtoDATA(Date);

                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${_optho[index].Comments}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        children: <Widget>[
                                          FutureBuilder(
                                            future: _futuropthoDATA,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(child: Text(''));
                                              }
                                              if (snapshot.hasData) {
                                                List<OPHTOModel> _opthoDATA = snapshot.data;
                                                return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _opthoDATA == null ? 0 : _opthoDATA.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_opthoDATA[index].Name}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w900,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_opthoDATA[index].Options}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("Comment on ${_opthoDATA[index].Name}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_opthoDATA[index].Comments}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return Center(child: SpinKitRotatingCircle(
                                                color: appColor,
                                                size: 50.0,
                                              ));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black,),
              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/lameness.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "Lameness Details",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futurLameness,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<LamenesssModel> _lameness = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _lameness == null ? 0 : _lameness.length,
                              itemBuilder: (BuildContext context, int index) {

                                String Date = "${_lameness[index].Date}";
                                _futurLamenessDATA =  getLamenessDATA(Date);

                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${_lameness[index].Comments}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        children: <Widget>[
                                          FutureBuilder(
                                            future: _futurLamenessDATA,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(child: Text(''));
                                              }
                                              if (snapshot.hasData) {
                                                List<LamenesssModel> _lamenessDATA = snapshot.data;
                                                return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _lamenessDATA == null ? 0 : _lamenessDATA.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_lamenessDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w900,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_lamenessDATA[index].Options}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("Comment on ${_lamenessDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_lamenessDATA[index].Comments}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return Center(child: SpinKitRotatingCircle(
                                                color: appColor,
                                                size: 50.0,
                                              ));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),

                  ],
                ),
              ),
              Divider(color: Colors.black,),
              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/neuroSpinal.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "Neuro - Spinal Reflexes Details",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futurNeuroSpinal,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<NeuroSpinalModel> _neuroSpinal = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _neuroSpinal == null ? 0 : _neuroSpinal.length,
                              itemBuilder: (BuildContext context, int index) {

                                String Date = "${_neuroSpinal[index].Date}";
                                _futurNeuroSpinalDATA =  getNeuroSpinalDATA(Date);

                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${_neuroSpinal[index].Comments}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        children: <Widget>[
                                          FutureBuilder(
                                            future: _futurNeuroSpinalDATA,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(child: Text(''));
                                              }
                                              if (snapshot.hasData) {
                                                List<NeuroSpinalModel> _neuroSpinalDATA = snapshot.data;
                                                return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _neuroSpinalDATA == null ? 0 : _neuroSpinalDATA.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_neuroSpinalDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w900,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_neuroSpinalDATA[index].Options}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("Comment on ${_neuroSpinalDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_neuroSpinalDATA[index].Comments}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return Center(child: SpinKitRotatingCircle(
                                                color: appColor,
                                                size: 50.0,
                                              ));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),

                  ],
                ),
              ),
              Divider(color: Colors.black,),
              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/operativeReport.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "Operative Report",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futurOperative,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<OperativeModel> _operative = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _operative == null ? 0 : _operative.length,
                              itemBuilder: (BuildContext context, int index) {

                                String Date = "${_operative[index].Date}";
                                _futurOperativeDATA =  getOperativeDATA(Date);

                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${_operative[index].Comments}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        children: <Widget>[
                                          FutureBuilder(
                                            future: _futurOperativeDATA,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(child: Text(''));
                                              }
                                              if (snapshot.hasData) {
                                                List<OperativeModel> _operativeDATA = snapshot.data;
                                                return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _operativeDATA == null ? 0 : _operativeDATA.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_operativeDATA[index].Question}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w900,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_operativeDATA[index].Options}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("Comment on ${_operativeDATA[index].Question}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_operativeDATA[index].Comments}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return Center(child: SpinKitRotatingCircle(
                                                color: appColor,
                                                size: 50.0,
                                              ));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),

                  ],
                ),
              ),
              Divider(color: Colors.black,),
              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/dermato.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "Dermatology Exam Details",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futurDermato,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<DermatoModel> _dermato = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _dermato == null ? 0 : _dermato.length,
                              itemBuilder: (BuildContext context, int index) {

                                String Date = "${_dermato[index].Date}";
                                _futurDermatoDATA =  getDermatoDATA(Date);

                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${_dermato[index].Comments}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        children: <Widget>[
                                          FutureBuilder(
                                            future: _futurDermatoDATA,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(child: Text(''));
                                              }
                                              if (snapshot.hasData) {
                                                List<DermatoModel> _dermatoDATA = snapshot.data;
                                                return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _dermatoDATA == null ? 0 : _dermatoDATA.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_dermatoDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w900,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_dermatoDATA[index].Options}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("Comment on ${_dermatoDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_dermatoDATA[index].Comments}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return Center(child: SpinKitRotatingCircle(
                                                color: appColor,
                                                size: 50.0,
                                              ));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black,),
              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/neuroPosture.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "Neuro - Posture Locomotion And Gait Details",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futurNeuroPosture,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<NeuroPostureModel> _neuroPosture = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _neuroPosture == null ? 0 : _neuroPosture.length,
                              itemBuilder: (BuildContext context, int index) {

                                String Date = "${_neuroPosture[index].Date}";
                                _futurNeuroPostureDATA =  getNeuroPostureDATA(Date);

                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${_neuroPosture[index].Comments}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        children: <Widget>[
                                          FutureBuilder(
                                            future: _futurNeuroPostureDATA,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(child: Text(''));
                                              }
                                              if (snapshot.hasData) {
                                                List<NeuroPostureModel> _neuroPostureDATA = snapshot.data;
                                                return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _neuroPostureDATA == null ? 0 : _neuroPostureDATA.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_neuroPostureDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w900,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_neuroPostureDATA[index].Options}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("Comment on ${_neuroPostureDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_neuroPostureDATA[index].Comments}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return Center(child: SpinKitRotatingCircle(
                                                color: appColor,
                                                size: 50.0,
                                              ));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black,),
              ListTileTheme(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                child: ExpansionTile(
                  leading:Image.asset(
                    "assets/dental.png",width: 50,height: 40,
                  ),
                  title: Text(
                    "Dental Exam Details",
                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: _futurDental,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(''));
                          }
                          if (snapshot.hasData) {
                            List<DentalModel> _Dental = snapshot.data;
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _Dental == null ? 0 : _Dental.length,
                              itemBuilder: (BuildContext context, int index) {

                                String Date = "${_Dental[index].Date}";
                                _futurDentalDATA =  getDentalDATA(Date);

                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTileTheme(
                                      dense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                      child: ExpansionTile(
                                        title: Text(
                                          "${_Dental[index].Comments}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        children: <Widget>[
                                          FutureBuilder(
                                            future: _futurDentalDATA,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(child: Text(''));
                                              }
                                              if (snapshot.hasData) {
                                                List<DentalModel> _DentalDATA = snapshot.data;
                                                return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _DentalDATA == null ? 0 : _DentalDATA.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_DentalDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w900,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_DentalDATA[index].Options}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("Comment on ${_DentalDATA[index].Questions}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, -100, 0, -100),
                                                              title: Text("${_DentalDATA[index].Comments}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                  fontWeight: FontWeight.w500,color: Colors.black),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return Center(child: SpinKitRotatingCircle(
                                                color: appColor,
                                                size: 50.0,
                                              ));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: SpinKitRotatingCircle(
                            color: appColor,
                            size: 50.0,
                          ));
                        },
                      ),
                    ),

                  ],
                ),
              ),
              Divider(color: Colors.black,),
            ],
          ),
        ),
      ),
    );
  }
}



