import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflixclone/model/movie_model.dart';
import 'package:netflixclone/screen/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  // SearchScreen({Key? key}) : super(key: key);

  // @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  //검색위젯을 컨트롤하는 _filter가 변화를 감지하여 _searchText의 상태를 변화시키는 코드
  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('movie').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data!.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      if (d.data.toString().contains(_searchText)) searchResults.add(d);
    }
    return Expanded(
        child: GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1 / 1.5,
      padding: EdgeInsets.all(3),
      children:
          searchResults.map((data) => _buildListItem(context, data)).toList(),
    ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final movie = Movie.fromSnapshot(data);

    return InkWell(
      child: Image.network(movie.poster),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<Null>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return DetailScreen(movie: movie);
            }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            // Padding(padding: EdgeInsets.all(30)),
            Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: TextField(
                      focusNode: focusNode,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                      autofocus: true,
                      controller: _filter,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white60,
                          size: 20,
                        ),

                        /*
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                              });
                            },
                            icon: Icon(
                              Icons.cancel,
                              size: 20,
                              color: Colors.white38,
                            )),
                            */

                        suffixIcon: focusNode.hasFocus
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _filter.clear();
                                    _searchText = "";
                                  });
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  size: 20,
                                  color: Colors.white38,
                                ))
                            : SizedBox(
                                width: 1,
                                height: 1,
                              ),
                        hintText: '검색',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  focusNode.hasFocus
                      ? Expanded(
                          child: FlatButton(
                            child: Text('취소'),
                            onPressed: () {
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                                focusNode.unfocus();
                              });
                            },
                          ),
                        )
                      : Expanded(
                          child: Container(),
                          flex: 0,
                        ),
                ],
              ),
            ),
            _buildBody(context),
          ],
        ),
      ),
    );
  }
}
