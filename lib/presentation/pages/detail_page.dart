// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/data/source/api/api_service.dart';
import 'package:flutter_api/domain/models/detail/detail_movie.dart';
import 'package:flutter_api/presentation/helpers/keys.dart';

class DetailPage extends StatefulWidget {
  final String imdbID;
  const DetailPage({Key? key, required this.imdbID}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailMovie? detailMovie;

  Future<void> _fetchMovieDetail() async {
    try {
      final api = ApiService(Dio(BaseOptions(contentType: 'application/json')));
      final result = await api.getMovieDetail(Helper.apiKey, widget.imdbID);
      setState(() {
        detailMovie = result;
      });
    } catch (error) {
      debugPrint('Error on Detail: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovieDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: detailMovie == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : NestedScrollView(
              headerSliverBuilder: (context, isScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 360,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        placeholder: (context, url) {
                          return Container(
                            margin: const EdgeInsets.all(32),
                            child: const CircularProgressIndicator(),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return const Icon(
                            Icons.error,
                            color: Colors.redAccent,
                            size: 48,
                          );
                        },
                        imageUrl: detailMovie?.Poster ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0), child: _buildUiInfo()),
              ),
            ),
      floatingActionButton: _fabAddToBookmark(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _fabAddToBookmark() {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(
        Icons.bookmark_add,
      ),
    );
  }

  Widget _buildUiInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detailMovie?.Title ?? '',
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Type: ${detailMovie?.Type ?? ''}',
                style: category,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Total Season: ${detailMovie?.totalSeasons ?? ''}',
                style: category,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          detailMovie?.Plot ?? '',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        _buildSingleInfo(
          Icons.calendar_today,
          'Released: ${detailMovie?.Released ?? ''}',
        ),
        const SizedBox(
          height: 16.0,
        ),
        _buildTwoInfos(
          Icons.history,
          Icons.movie,
          'Runtime: ${detailMovie?.Runtime ?? ''}',
          'Type: ${detailMovie?.Type ?? ''}',
        ),
        const SizedBox(
          height: 16.0,
        ),
        _buildSingleInfo(
          Icons.theater_comedy,
          'Genre: ${detailMovie?.Genre ?? ''}',
        ),
        const SizedBox(
          height: 16.0,
        ),
        _buildTwoInfos(
          Icons.record_voice_over,
          Icons.movie_edit,
          'Director: ${detailMovie?.Director ?? ''}',
          'Writer: ${detailMovie?.Writer ?? ''}',
        ),
        const SizedBox(
          height: 16.0,
        ),
        _buildSingleInfo(
          Icons.groups,
          'Actors: ${detailMovie?.Actors ?? ''}',
        ),
        const SizedBox(
          height: 16.0,
        ),
        _buildTwoInfos(
          Icons.public,
          Icons.language,
          'Country: ${detailMovie?.Country ?? ''}',
          'Language: ${detailMovie?.Language ?? ''}',
        ),
        const SizedBox(
          height: 16.0,
        ),
        _buildSingleInfo(
          Icons.military_tech,
          'Awards: ${detailMovie?.Awards ?? ''}',
        ),
      ],
    );
  }

  Widget _buildSingleInfo(IconData? icon, String text) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              icon,
              size: 24.0,
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          const WidgetSpan(child: SizedBox(width: 16.0)),
          TextSpan(
            text: text,
            style: category,
          )
        ],
      ),
    );
  }

  Widget _buildTwoInfos(IconData? firstIcon, IconData? secondIcon,
      String firstText, String secondText) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(firstIcon, size: 24.0),
                  alignment: PlaceholderAlignment.middle,
                ),
                const WidgetSpan(
                    child: SizedBox(
                  width: 16.0,
                )),
                TextSpan(
                  text: firstText,
                  style: category,
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 24.0,
        ),
        Expanded(
          flex: 1,
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(secondIcon, size: 24.0),
                  alignment: PlaceholderAlignment.middle,
                ),
                const WidgetSpan(
                    child: SizedBox(
                  width: 16.0,
                )),
                TextSpan(
                  text: secondText,
                  style: category,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  var category = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );
}
