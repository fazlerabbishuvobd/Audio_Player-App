import 'package:audioplayer_app/screens/selectedsong.dart';
import 'package:flutter/material.dart';

class FavSongPage extends StatefulWidget {
  final List<Map<String,dynamic>>? favSong;
  const FavSongPage({super.key,required this.favSong});

  @override
  State<FavSongPage> createState() => _FavSongPageState();
}

class _FavSongPageState extends State<FavSongPage> {
  final List<Map<String,dynamic>> favSongLists =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourite Song',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.white,
            )),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: widget.favSong!.length,
        itemBuilder:(context, index) {
          Map<String, dynamic> song = widget.favSong![index];

          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: (){
                //Song Will Be played
              },
              child: Card(
                elevation: 10,
                child: Container(
                  alignment: Alignment.center,
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), color: Colors.amber),
                  child: ListTile(
                    leading: const Icon(
                      Icons.play_circle,
                      size: 36,
                    ),
                    title: Text(song['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: InkWell(
                      onTap: (){
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 36,
                        color: song['fav']==false?Colors.white:Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

