import 'dart:convert';

MovieModel movieModelFromJson(String str) =>
    MovieModel.fromJson(json.decode(str));

String movieModelToJson(MovieModel data) => json.encode(data.toJson());

List<MovieModel> listMovieModelFromJson(String str) =>
    List<MovieModel>.from(json.decode(str).map((x) => MovieModel.fromJson(x)));

class MovieModel {
  final int id;
  final String title, director, summary, genres, thumbnail;

  MovieModel({
    required this.id,
    required this.title,
    required this.director,
    required this.summary,
    required this.genres,
    required this.thumbnail,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        director: json["director"] ?? "",
        summary: json["summary"] ?? "",
        genres: json["genres"] ?? "",
        thumbnail: json["thumbnail"] ?? "",
      );

  factory MovieModel.initial({
    int? id,
    String? title,
    String? director,
    String? summary,
    String? genres,
    String? thumbnail,
  }) =>
      MovieModel(
        id: id ?? 0,
        title: title ?? "",
        director: director ?? "",
        summary: summary ?? "",
        genres: genres ?? "",
        thumbnail: thumbnail ?? "",
      );

  MovieModel copyWith({
    int? id,
    String? title,
    String? director,
    String? summary,
    String? genres,
    String? thumbnail,
  }) =>
      MovieModel(
        id: id ?? this.id,
        title: title ?? this.title,
        director: director ?? this.director,
        summary: summary ?? this.summary,
        genres: genres ?? this.genres,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  Map<String, dynamic> toJson({bool withId = true}) {
    final Map<String, dynamic> request = {
      "title": title,
      "director": director,
      "summary": summary,
      "genres": genres,
      "thumbnail": thumbnail,
    };

    if (withId) request.addAll({"id": id});

    return request;
  }
}
