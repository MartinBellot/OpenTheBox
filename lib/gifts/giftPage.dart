import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:particles_flutter/particles_flutter.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({Key? key}) : super(key: key);

  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  bool _giftReceived = false;
  bool _giftOpened = false;
  late AudioPlayer _audioPlayer;
  late IO.Socket socket;
  late Map<String, dynamic> giftData;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.onConnect((_) {
      print('Connected to socket server');
    });
    socket.on('open_gift', (_) => _openGift());
    socket.on('receive_gift', (data) => _receiveGift(data));
    socket.connect();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    socket.disconnect();
    super.dispose();
  }

  void _receiveGift(data) {
    if (data != null && mounted) {
      setState(() {
        _giftReceived = true;
        giftData = data;
      });
    }
  }

  void _openGift() async {
    if (!_giftReceived) return;  // Add this
    setState(() {
      _giftOpened = true;
    });
    await _playMusic();
  }

  Future<void> _playMusic() async {
    var audioSource = AudioSource.uri(
      Uri.parse('asset:///music.mp3'),
    );
    await _audioPlayer.setAudioSource(audioSource);
    _audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadeau App'),
      ),
      body: Center(
        child: _giftReceived ? Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (!_giftOpened) {
                  _openGift();
                }
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: _giftOpened
                    ? CardWidget(giftData: giftData)
                    : const Image(
                        image: AssetImage('gift.png'),
                        height: 200,
                        width: 200,
                      ),
              ),
            ),
            IgnorePointer( 
              child: CircularParticle(
                key: UniqueKey(),
                awayRadius: 80,
                numberOfParticles: 100,
                speedOfParticles: 2,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                onTapAnimation: true,
                particleColor: Colors.white.withAlpha(150),
                awayAnimationDuration: const Duration(milliseconds: 10),
                maxParticleSize: 8,
                isRandSize: true,
                isRandomColor: true,
                randColorList: [
                  Colors.red.withAlpha(210),
                  Colors.white.withAlpha(210),
                  Colors.yellow.withAlpha(210),
                  Colors.green.withAlpha(210)
                ],
                awayAnimationCurve: Curves.easeInOutBack,
                enableHover: true,
                hoverColor: Colors.white,
                hoverRadius: 90,
                connectDots: false,
              ),
            ),
          ],
        ) : Container(),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final Map<String, dynamic> giftData;

  const CardWidget({Key? key, required this.giftData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              giftData['titre'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              giftData['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            for (var image in giftData['images'])
              Image.asset(image, height: 100, width: 100),
            const SizedBox(height: 8),
            // Ajoutez d'autres images ou vidéos ici
          ],
        ),
      ),
    );
  }
}