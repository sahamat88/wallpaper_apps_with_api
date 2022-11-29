import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallpaper_apps/fullscreen_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('HD Wallpaper',
              style: TextStyle(
                  color: Colors.white, fontSize: 25, fontFamily: 'Pacifico')),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
            )
          ],
        ),
        body: Container(
          child: images == null
              ? Center(
                  child: SpinKitRotatingCircle(
                    color: Colors.black,
                  ),
                )
              : Stack(
                  children: [
                    MasonryGridView.builder(
                        itemCount: images.length,
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullScreenImage(
                                            imageUrl: images[index]['src']
                                                ['portrait'],
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  images[index]['src']['medium'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }),
                    Positioned(
                      bottom: 30,
                      left: 50,
                      right: 50,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: CupertinoButton(
                            color: Colors.black87,
                            onPressed: () {
                              _loadmore();
                            },
                            child: Text(
                              'Load More',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _getData() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=50"),
        headers: {
          'Authorization':
              '563492ad6f917000010000015e3485e1b52445a6a392fe5bcd66d70d'
        });

    print(response.body);
    Map result = jsonDecode(response.body);

    setState(() {
      images = result['photos'];

      print(images[0]);
    });
  }

  _loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=50&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f917000010000015e3485e1b52445a6a392fe5bcd66d70d'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }
}
