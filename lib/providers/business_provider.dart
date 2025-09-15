import 'package:businessapicall/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/business.dart';
import 'dart:convert';
enum DataState { idle,loading, loaded, empty, error}

class BusinessProvider extends ChangeNotifier {

  final Dio dio = DioClient().dio;

  List<Business> _items = [];

  List<Business> get items => _items;
  DataState state = DataState.idle;
  String? errorMessage;
  String query = '';


  Future<void> load({bool forceLoad = false}) async{
      state = DataState.loading;
      errorMessage = null;
      notifyListeners();
      try{
        final response = await dio.get('https://api.local/loca/businesses');

        final data = response.data;
        final List<dynamic> arr = data is String ? jsonDecode(data) : data;
        _items = Business.listFromJson(arr);

        state = _items.isEmpty ? DataState.empty :  DataState.loaded;

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('cached_businesses',jsonEncode(arr));
        notifyListeners();
      }catch(e){
        final prefs = await SharedPreferences.getInstance();
        final cached = prefs.getString('cached_businesses');
        if (cached != null) {
          try {
            final arr = jsonDecode(cached) as List<dynamic>;
            _items = Business.listFromJson(arr);
            state = _items.isEmpty ? DataState.empty : DataState.loaded;
            notifyListeners();
            return;
          } catch (_) {}
        }
        state = DataState.error;
        errorMessage = e.toString();
        notifyListeners();
      }
   }

List<Business> get filtered{
  if (query.isEmpty) return items;
  final q = query.toLowerCase();
  return items.where((b) =>
      b.name.toLowerCase().contains(q) ||
      b.location.toLowerCase().contains(q)
  ).toList();
}

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

}