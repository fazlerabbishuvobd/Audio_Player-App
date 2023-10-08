import 'package:audioplayer_app/screens/favSongPage.dart';
import 'package:audioplayer_app/screens/selectedsong.dart';
import 'package:flutter/material.dart';

class PlayList extends StatefulWidget {
  final List<Map<String,dynamic>>? songs;
  PlayList({super.key,required this.songs});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  final List<Map<String,dynamic>> favSongList =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music Play List',
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
        itemCount: widget.songs!.length,
        itemBuilder:(context, index) {
          //var selectedSong = widget.songs![index];
          Map<String, dynamic> song = widget.songs![index];
          String songName = widget.songs![index]['name'];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: (){
                //Song Will Be played
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                SelectedSongPage(selectedIndex: index,songList: widget.songs,)));
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
                    title: Text(songName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: InkWell(
                      onTap: (){
                        setState(() {
                          song['fav'] = !song['fav'];
                        });
                        Map<String,dynamic> favourtite = {
                          'name': song['name'],
                          'path': song['path'],
                          'fav':song['fav']
                        };
                        song['fav'] == true? favSongList.add(favourtite): favSongList.removeWhere((element) => element['fav']==true);
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>FavSongPage(favSong: favSongList,)));
      },child: const Icon(Icons.favorite),),
    );
  }
}
