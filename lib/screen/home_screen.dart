import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netflixclone/model/movie_model.dart';
import 'package:netflixclone/widget/box_slider.dart';
import 'package:netflixclone/widget/carousel_slider.dart';
import 'package:netflixclone/widget/circle_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Firestore firestore = Firestore.instance;
  late Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();
    streamData = firestore.collection('movie').snapshots();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        //+++ flutter 2 Change
        return _buildBody(context, snapshot.data!.documents);
        //[Original] 정확히 맞는지 모르겠음
        // return _buildBody(context, snapshot.data!.documents);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<Movie> movies = snapshot.map((d) => Movie.fromSnapshot(d)).toList();
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              CarouslImage(movies: movies),
              Topbar(),
            ],
          ),
          CircleSlider(movies: movies),
          BoxSlider(movies: movies)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  //   @override
  // Widget build(BuildContext context) {
  //   return ListView(
  //     children: <Widget>[
  //       Stack(
  //         children: <Widget>[
  //           CarouslImage(movies: movies),
  //           Topbar(),
  //         ],
  //       ),
  //       CircleSlider(movies: movies),
  //       BoxSlider(movies: movies)
  //     ],
  //   );
  // }
}

class Topbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'images/Logo.png',
            fit: BoxFit.contain,
            height: 25,
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              'TV 프로그램',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              '영화',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              '내가 찜한 콘텐츠',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
