import 'package:audioplayer_app/screens/playlist.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  //int selectedIndex;
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  bool isPlaying = false;
  bool fav = false;

  //final List<String> songs = ['Name'];
  final List<Map<String,dynamic>> songList =[
    {
      'name':'name',
      'path':'path\hello\h.mp3',
      'size':'size',
      'fav':false,
    },
  ];

 // final List<String> songName = [];
  int songIndex = 0;
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
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void playAudio() {
    //Future<void> result = player.play(UrlSource(songs[songIndex]));
    Future<void> result = player.play(UrlSource('${songList[songIndex]['path']}'));
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

  void skipToNextSong() {
    if (songIndex < songList.length - 1) {
      songIndex++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Last Song Redirect to 1st Song')));
      songIndex = 0;
    }
    playAudio();
  }

  void skipToPreviousSong() {
    if (songIndex > 0) {
      songIndex--;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('1st Song Redirect to Last Song')));
      songIndex = songList.length - 1;
    }
    playAudio();
  }

  Future<void> loadSong() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        String fileName = file.name;
        String? filePath = file.path;
        String? filesize = file.size.toString();

        
          Map<String,dynamic> newSong =
          {
            'name': fileName,
            'path': '$filePath',
            'size': filesize,
            'fav': false,
          };

          setState(() {
            //songs.removeAt(0);
            //songs.add(filePath!);
            songList.add(newSong);
            songList.removeWhere((element) => element['name']=='name');

          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    //songIndex = widget.selectedIndex.toInt();

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
            Text(songList[songIndex]['name'].toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _buildPlayerImage(context),
            const Spacer(),
            //Play Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPreviousButton(),
                _buildPlayPauseButton(),
                _buildNextButton(),
              ],
            ),

            _buildSlider(),
            // Duration Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(timeFormat(position.inSeconds)),
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
                _buildLoadSongButton(),
                _buildPlayList(context),
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

  Card _buildPlayList(BuildContext context) {
    return Card(
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
                  pauseAudio();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PlayList(
                        songs: songList,
                      ))
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.playlist_add),
                    Text('Play List'),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  Card _buildLoadSongButton() {
    return Card(
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
                  loadSong();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.import_export),
                    Text('Load Song'),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  Slider _buildSlider() {
    return Slider(
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
    );
  }

  Card _buildNextButton() {
    return Card(
      elevation: 10,
      child: IconButton(
        onPressed: () {
          skipToNextSong();
        },
        icon: const Icon(
          Icons.skip_next_rounded,
          size: 64,
        ),
        tooltip: 'Next',
      ),
    );
  }

  Card _buildPlayPauseButton() {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: IconButton(
        onPressed: () {
          setState(() {
            isPlaying = !isPlaying;
          });
          isPlaying == true? playAudio():pauseAudio();
        },
        icon: Icon(isPlaying == false ? Icons.play_circle : Icons.pause_circle_filled_rounded,
          size: 64,
        ),
        tooltip: isPlaying == true ? 'Play' : 'Pause',
      ),
    );
  }

  Card _buildPreviousButton() {
    return Card(
      elevation: 10,
      child: IconButton(
        onPressed: () {
          skipToPreviousSong();
        },
        icon: const Icon(
          Icons.skip_previous_rounded,
          size: 64,
        ),
        tooltip: 'Previous',
      ),
    );
  }

  Center _buildPlayerImage(BuildContext context) {
    return Center(
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
    );
  }
}
