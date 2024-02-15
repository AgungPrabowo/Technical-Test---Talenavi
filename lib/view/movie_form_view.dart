import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/movie_form_view_model.dart';

class MovieFormView extends StatelessWidget {
  final int? id;
  const MovieFormView({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Movie Form",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<MovieFormViewModel>(
        create: (ctx) => MovieFormViewModel(context, id),
        builder: (context, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<MovieFormViewModel>(
                builder: (context, provider, _) {
                  return Form(
                    key: provider.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: provider.ctrlTitle,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                            filled: true,
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? "Title must be filled"
                                : null;
                          },
                          onChanged: (value) =>
                              provider.onChanged(title: value),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: provider.ctrlThumbnail,
                          decoration: const InputDecoration(
                            label: Text("Thumbnail (url)"),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return Uri.parse(value).isAbsolute
                                  ? null
                                  : "Thumbnail must be URL";
                            }
                            return null;
                          },
                          onChanged: (value) =>
                              provider.onChanged(thumbnail: value),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: provider.ctrlDirector,
                          decoration: const InputDecoration(
                            label: Text("Director"),
                            filled: true,
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? "Director must be filled"
                                : null;
                          },
                          onChanged: (value) =>
                              provider.onChanged(director: value),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: provider.ctrlSummary,
                          minLines: 8,
                          maxLines: 8,
                          maxLength: 100,
                          decoration: const InputDecoration(
                            label: Text("Summary"),
                            filled: true,
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? "Summary must be filled"
                                : null;
                          },
                          onChanged: (value) =>
                              provider.onChanged(summary: value),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            children: provider.genres
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: InputChip(
                                        label: Text(e.trim()),
                                        onSelected: (value) {
                                          provider.onSelectGenre(value, e);
                                        },
                                        selected: provider.selectedGenre
                                            .any((x) => x.trim() == e.trim()),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 7,
                          child: ElevatedButton(
                            onPressed: () => provider.save(),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (id != null) ...[
                          const SizedBox(height: 24),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 7,
                            child: ElevatedButton(
                              onPressed: () => provider.delete(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
