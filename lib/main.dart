import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const ArtSpaceApp());
}

class ArtSpaceApp extends StatelessWidget {
  const ArtSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ArtSpaceScreen(),
    );
  }
}

class Artwork {
  final String imagePath;
  final String title;
  final String artist;
  final int year;

  const Artwork({
    required this.imagePath,
    required this.title,
    required this.artist,
    required this.year,
  });
}

class ArtSpaceScreen extends StatefulWidget {
  const ArtSpaceScreen({super.key});

  @override
  State<ArtSpaceScreen> createState() => _ArtSpaceScreenState();
}

class _ArtSpaceScreenState extends State<ArtSpaceScreen> {
  final List<Artwork> _artworks = const [
    Artwork(
      imagePath: 'assets/images/catart.jpg',
      title: 'The Calm Before The Mrow',
      artist: 'Meow Meow',
      year: 2024,
    ),
    Artwork(
      imagePath: 'assets/images/jellyart.jpg',
      title: 'Electric Blue',
      artist: 'Sushi Wushi',
      year: 2026,
    ),
    Artwork(
      imagePath: 'assets/images/seahorseart.jpg',
      title: 'Sha La La',
      artist: 'Water Neigh',
      year: 2025,
    ),
  ];

  int _currentIndex = 0;

  void _showPrevious() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _artworks.length) % _artworks.length;
    });
  }

  void _showNext() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _artworks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final artwork = _artworks[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred backdrop
          _BlurredBackdrop(imagePath: artwork.imagePath),

          // Foreground content.
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      // Section 1: Artwork
                      _ArtworkWall(imagePath: artwork.imagePath),

                      const SizedBox(height: 32),

                      // Section 2: Artwork description
                      _ArtworkDescriptor(
                        title: artwork.title,
                        artist: artwork.artist,
                        year: artwork.year,
                      ),

                      const SizedBox(height: 16),

                      // Section 3: Display controller
                      _DisplayController(
                        onPrevious: _showPrevious,
                        onNext: _showNext,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Section 1: displays the artwork image inside a frame-like container with a blurred copy of artwork as the background
class _BlurredBackdrop extends StatelessWidget {
  final String imagePath;

  const _BlurredBackdrop({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        // Keep the backdrop plain gray if the asset hasn't loaded yet.
        errorBuilder: (context, error, stackTrace) =>
            Container(color: const Color(0xFFEDEDED)),
        color: Colors.black.withOpacity(0.15),
        colorBlendMode: BlendMode.darken,
      ),
    );
  }
}

class _ArtworkWall extends StatelessWidget {
  final String imagePath;

  const _ArtworkWall({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          // Fallback so the app still runs before you add real images.
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Icon(Icons.image, size: 64, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

// Section 2: shows title, artist, and year
class _ArtworkDescriptor extends StatelessWidget {
  final String title;
  final String artist;
  final int year;

  const _ArtworkDescriptor({
    required this.title,
    required this.artist,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: artist,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' ($year)'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Section 3: Previous & Next buttons
class _DisplayController extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _DisplayController({required this.onPrevious, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onPrevious,
          style: ElevatedButton.styleFrom(minimumSize: const Size(120, 44)),
          child: const Text('Previous'),
        ),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(minimumSize: const Size(120, 44)),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
