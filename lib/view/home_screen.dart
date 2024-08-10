import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_project/view/screen_detail.dart';
import '../provider/movie_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}
class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Movie App'),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const Text('Now Playing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.nowPlayingMovies.length,
                    itemBuilder: (context, index) {
                      var movie = provider.nowPlayingMovies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(movieId: movie['id']),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
                const Text('Popular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.popularMovies.length,
                  itemBuilder: (context, index) {
                    var movie = provider.popularMovies[index];
                    //check if movie added to watch list
                    bool isInWatchlist = provider.isInWatchlist(movie['id']);
                    //check if movie added to favourite
                    bool isFavorite = provider.isFavorite(movie['id']);
                    return ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      title: Text(movie['title']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                                isInWatchlist ? Icons.minimize : Icons.add,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isInWatchlist) {
                                  // Delete from watchlist
                                  provider.removeFromWatchlist(movie['id']);
                                } else {
                                  // Added to watchlist
                                  provider.addToWatchlist(movie['id']);
                                }
                              });

                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              if(isFavorite){
                                // Delete from favorite
                                provider.removeFromFavorites(movie['id']);
                              } else {
                                // Added to favorit
                                provider.addToFavorites(movie['id']);
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(movieId: movie['id']),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
