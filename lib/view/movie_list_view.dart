import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/movie_list_view_model.dart';
import 'movie_form_view.dart';

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Movies Collection",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<MovieListViewModel>(
          create: (context) => MovieListViewModel(),
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<MovieListViewModel>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      Form(
                        child: TextFormField(
                          controller: provider.ctrlSearch,
                          decoration: const InputDecoration(
                            label: Text("Search"),
                            filled: true,
                          ),
                          onChanged: (value) => provider.searchMovie(value),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.movieList.length,
                        itemBuilder: (context, index) {
                          final item = provider.movieList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieFormView(
                                    id: item.id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(14),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 0),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    color: Colors.grey.withOpacity(.15),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl: item.thumbnail,
                                        height: 96,
                                        width: 96,
                                        fit: BoxFit.contain,
                                        errorWidget: (context, url, error) {
                                          return const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: Colors.grey,
                                            size: 96,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.director,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Divider(),
                                        Text(
                                          item.summary,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                        Text(
                                          item.genres,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MovieFormView(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
