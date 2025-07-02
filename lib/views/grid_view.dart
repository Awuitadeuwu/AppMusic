import 'package:flutter/material.dart';

class GridViewScreen extends StatefulWidget {
  const GridViewScreen({super.key});

  @override
  _GridViewScreenState createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  // Lista de imágenes locales con sus descripciones
  final List<Map<String, dynamic>> images = [
    {
      'id': 1,
      'title': 'Naturaleza',
      'description': 'Paisaje natural con montañas y río',
      'assetPath': 'assets/images/naturalez.jpg',
    },
    {
      'id': 2,
      'title': 'Ciudad',
      'description': 'Vista panorámica de una ciudad moderna',
      'assetPath': 'assets/images/Ciudad.jpg',
    },
    {
      'id': 3,
      'title': 'Playa',
      'description': 'Hermosa playa tropical al atardecer',
      'assetPath': 'assets/images/Playa.jpg',
    },
    {
      'id': 4,
      'title': 'Bosque',
      'description': 'Sendero en un bosque otoñal',
      'assetPath': 'assets/images/Bosque.jpg',
    },
  ];

  void _showImageDetail(Map<String, dynamic> image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailScreen(image: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de Imágenes'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return GestureDetector(
            onTap: () => _showImageDetail(image),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15)),
                      child: Image.asset(
                        image['assetPath'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      image['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final Map<String, dynamic> image;

  const ImageDetailScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'image-${image['id']}',
              child: Image.asset(
                image['assetPath'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    image['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    image['description'],
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Detalles adicionales:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pronto pondre mas info',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}