import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../db_config.dart';
import '../model/movie_model.dart';
import '../view/movie_list_view.dart';

class MovieFormViewModel extends ChangeNotifier {
  final BuildContext _context;
  final int? _id;
  final formKey = GlobalKey<FormState>();
  final ctrlTitle = TextEditingController();
  final ctrlDirector = TextEditingController();
  final ctrlSummary = TextEditingController();
  final ctrlThumbnail = TextEditingController();
  final genres = ["Drama", "Action", "Animation", "Sci-Fi", "Horror"];
  var selectedGenre = <String>[];
  var payload = MovieModel.initial();

  MovieFormViewModel(this._context, this._id) {
    _initData();
  }

  void _initData() async {
    if (_id != null) {
      final db = await DBConfig().init();
      final data = await db.query(DBConfig.tableName,
          orderBy: "id DESC", where: "id = ?", whereArgs: [_id]);
      if (data.isNotEmpty) {
        payload = MovieModel.fromJson(data[0]);
        ctrlTitle.text = payload.title;
        ctrlDirector.text = payload.director;
        ctrlSummary.text = payload.summary;
        selectedGenre = payload.genres.split(",");
        notifyListeners();
      }
    }
  }

  void onChanged({
    String? title,
    String? director,
    String? summary,
    String? thumbnail,
  }) {
    payload = payload.copyWith(
      title: title,
      director: director,
      summary: summary,
      thumbnail: thumbnail,
    );
  }

  void onSelectGenre(bool onSelect, String value) {
    if (onSelect) {
      selectedGenre.add(value.trim());
    } else {
      selectedGenre.removeWhere((e) => e.trim() == value.trim());
    }
    payload = payload.copyWith(genres: selectedGenre.join(", "));
    notifyListeners();
  }

  void delete() async {
    final db = await DBConfig().init();
    if (_id != null) {
      await db.delete(
        DBConfig.tableName,
        where: "id = ?",
        whereArgs: [_id],
      );
    }

    if (_context.mounted) {
      ScaffoldMessenger.of(_context).showSnackBar(const SnackBar(
        content: Text("Success Delete Movie"),
        backgroundColor: Colors.green,
      ));
      Navigator.pushAndRemoveUntil(
        _context,
        MaterialPageRoute(
          builder: (context) => const MovieListView(),
        ),
        (route) => false,
      );
    }
  }

  void save() async {
    if (formKey.currentState!.validate()) {
      final db = await DBConfig().init();
      if (_id != null) {
        await db.update(
          DBConfig.tableName,
          payload.toJson(),
          where: "id = ?",
          whereArgs: [_id],
        );
      } else {
        await db.insert(
          DBConfig.tableName,
          payload.toJson(withId: false),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      if (_context.mounted) {
        ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
          content: Text("Success ${_id != null ? "Update" : "Create"}  Movie"),
          backgroundColor: Colors.green,
        ));
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (context) => const MovieListView(),
          ),
          (route) => false,
        );
      }
    }
  }
}
