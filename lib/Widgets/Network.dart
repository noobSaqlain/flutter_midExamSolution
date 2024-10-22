import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Counter with ChangeNotifier {
  List<Launch>? _details;
  List<bool>? _isOpenList;
  bool _isLoading = true;

  List<Launch>? getDetails() => _details;
  List<bool>? getOpenList() => _isOpenList;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res =
          await http.get(Uri.parse('https://api.spacexdata.com/v3/missions'));
      if (res.statusCode == 200) {
        List<dynamic> listJson = jsonDecode(res.body);
        _details = listJson.map((item) => Launch.fromJson(item)).toList();
        _isOpenList = List.generate(_details!.length, (_) => false);
      } else {
        print('Failed to load data: ${res.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleOpen(int index) {
    if (_isOpenList != null) {
      _isOpenList![index] = !_isOpenList![index];
      notifyListeners();
    }
  }
}

class Launch {
  String? missionName;
  String? missionId;
  List<String>? manufacturers;
  List<String>? payloadIds;
  String? wikipedia;
  String? website;
  String? twitter;
  String? description;

  Launch({
    this.missionName,
    this.missionId,
    this.manufacturers,
    this.payloadIds,
    this.wikipedia,
    this.website,
    this.twitter,
    this.description,
  });

  Launch.fromJson(Map<String, dynamic> json) {
    missionName = json['mission_name'];
    missionId = json['mission_id'];
    manufacturers = json['manufacturers']?.cast<String>();
    payloadIds = json['payload_ids']?.cast<String>();
    wikipedia = json['wikipedia'];
    website = json['website'];
    twitter = json['twitter'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mission_name'] = missionName;
    data['mission_id'] = missionId;
    data['manufacturers'] = manufacturers;
    data['payload_ids'] = payloadIds;
    data['wikipedia'] = wikipedia;
    data['website'] = website;
    data['twitter'] = twitter;
    data['description'] = description;
    return data;
  }
}
