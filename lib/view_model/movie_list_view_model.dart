import 'dart:convert';

import 'package:flutter/material.dart';

import '../db_config.dart';
import '../model/movie_model.dart';

class MovieListViewModel extends ChangeNotifier {
  final ctrlSearch = TextEditingController();
  var movieList = <MovieModel>[];

  MovieListViewModel() {
    _getMovie();
  }

  void _getMovie() async {
    final db = await DBConfig().init();
    final data = await db.query(DBConfig.tableName, orderBy: "id DESC");
    if (data.isNotEmpty) {
      movieList = listMovieModelFromJson(jsonEncode(data));
      notifyListeners();
    }
  }

  void searchMovie(String value) async {
    final db = await DBConfig().init();
    final data = await db.query(
      DBConfig.tableName,
      orderBy: "id DESC",
      where: "title LIKE ?",
      whereArgs: ["%$value%"],
    );
    if (data.isNotEmpty) {
      movieList = listMovieModelFromJson(jsonEncode(data));
    } else {
      movieList = [];
    }
    notifyListeners();
  }
}
