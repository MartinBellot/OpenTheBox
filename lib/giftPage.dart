import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({Key? key}) : super(key: key);

  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  bool _giftOpened = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _openGift() async {
    setState(() {
      _giftOpened = true;
    });
    await _playMusic();
  }


  Future<void> _playMusic() async {
  var audioSource = AudioSource.uri(
    Uri.parse('asset:///assets/music.mp3'),
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
        child: GestureDetector(
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
                ? const CardWidget()
                : const Image(
                    image: AssetImage('assets/gift.png'),
                    height: 200,
                    width: 200,
                  ),
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({Key? key}) : super(key: key);

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
            const Text(
              'Cadeau Ouvert!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Félicitations! Vous avez ouvert votre cadeau.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Image.asset('assets/image1.jpg', height: 100, width: 100),
            const SizedBox(height: 8),
            Image.asset('assets/image2.jpg', height: 100, width: 100),
            const SizedBox(height: 8),
            // Ajoutez d'autres images ou vidéos ici
          ],
        ),
      ),
    );
  }
}