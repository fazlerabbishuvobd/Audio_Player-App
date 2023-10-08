import 'package:audioplayer_app/screens/playlist.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SelectedSongPage extends StatefulWidget {
  final List<Map<String,dynamic>>? songList;
  int selectedIndex;
  SelectedSongPage({
    super.key,required this.selectedIndex,required this.songList
  });

  @override
  State<SelectedSongPage> createState() => _SelectedSongPageState();
}

class _SelectedSongPageState extends State<SelectedSongPage> {
  final player = AudioPlayer();
  bool isPlaying = false;
  //int songIndex = 0;
  //final List<String> songs = ['Name'];
  // final List<String> songName = [];

  //double sliderValue = 100;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String timeFormat(int seconds) {
    return '${Duration(seconds: seconds)}'.split('.')[0].padLeft(8, '0');
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    int songIndex = widget.selectedIndex.toInt();
    player.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      } else if (event == PlayerState.paused) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    playAudio(songIndex);
    super.initState();
  }


  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }


  void playAudio(int songIndex) {
    //Future<void> result = player.play(UrlSource(songs[songIndex]));
    Future<void> result = player.play(UrlSource('${widget.songList![songIndex]['path']}'));
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
    }
  }

  void pauseAudio() async {
    int result = await player.pause() as int;
    if (result == 1) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  void skipToNextSong(int songIndex) {
    if (songIndex < widget.songList!.length - 1) {
      songIndex++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Last Song Redirect to 1st Song')));
      songIndex = 0;
    }
    playAudio(songIndex);
  }

  void skipToPreviousSong(int songIndex) {
    if (songIndex > 0) {
      songIndex--;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('1st Song Redirect to Last Song')));
      songIndex = widget.songList!.length - 1;
    }
    playAudio(songIndex);
  }


  @override
  Widget build(BuildContext context) {
    int songIndex = widget.selectedIndex.toInt();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Text('${songs[songIndex].toString()}',
            Text('${widget.songList![songIndex]['name'].toString()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Center(
              child: Card(
                elevation: 20,
                shadowColor: Colors.amber,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white.withBlue(450),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Lottie.asset('assets/player2.json'),
                ),
              ),
            ),
            const Spacer(),
            //Play Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 10,
                  child: IconButton(
                    onPressed: () {
                      skipToPreviousSong(songIndex);
                    },
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      size: 64,
                    ),
                    tooltip: 'Previous',
                  ),
                ),
                Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                      isPlaying == true? playAudio(songIndex):pauseAudio();
                      print('Play/Pause Song');
                    },
                    icon: Icon(
                      isPlaying == false
                          ? Icons.play_circle
                          : Icons.pause_circle_filled_rounded,
                      size: 64,
                    ),
                    tooltip: isPlaying == true ? 'Play' : 'Pause',
                  ),
                ),
                Card(
                  elevation: 10,
                  child: IconButton(
                    onPressed: () {
                      skipToNextSong(songIndex);
                      print('Next Song');
                    },
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      size: 64,
                    ),
                    tooltip: 'Next',
                  ),
                ),
              ],
            ),

            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (newPosition) {
                final position = Duration(seconds: newPosition.toInt());
                setState(() {
                  player.seek(position);
                });
              },
              activeColor: Colors.amber,
              inactiveColor: Colors.amber.withBlue(100),
            ),
            // Duration Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${timeFormat(position.inSeconds)}'),
                  Row(
                    children: [
                      Text('${timeFormat((duration - position).inSeconds)} / ${timeFormat(duration.inSeconds)}'),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 40,
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              //
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.import_export),
                                Text('No Need'),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 40,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              print(widget.selectedIndex);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.playlist_add),
                                Text('No Need'),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      backgroundColor: Colors.white.withGreen(500),
    );
  }
}
