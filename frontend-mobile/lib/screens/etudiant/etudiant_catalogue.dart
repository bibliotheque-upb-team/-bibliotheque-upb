import 'package:flutter/material.dart';

class EtudiantCatalogue extends StatefulWidget {
  const EtudiantCatalogue({super.key});

  @override
  State<EtudiantCatalogue> createState() => _EtudiantCatalogueState();
}

class _EtudiantCatalogueState extends State<EtudiantCatalogue> {
  final TextEditingController _searchController = TextEditingController();
  String _recherche = '';

  final List<Map<String, dynamic>> _catalogues = [
    {
      'id': 101,
      'titre': 'Carton Informatique',
      'categorie': 'INFORMATIQUE',
      'description': 'Algorithmique, Programmation, Architecture et Réseaux.',
      'couleur': const Color(0xFF2563EB),
      'icone': Icons.terminal,
    },
    {
      'id': 102,
      'titre': 'Carton Sciences',
      'categorie': 'SCIENCES',
      'description': 'Physique, Chimie, Mathématiques et Biologie.',
      'couleur': const Color(0xFF16A34A),
      'icone': Icons.science,
    },
    {
      'id': 103,
      'titre': 'Carton Littérature',
      'categorie': 'LITTÉRATURE',
      'description': 'Classiques, Romans contemporains et Poésie.',
      'couleur': const Color(0xFFF59E0B),
      'icone': Icons.menu_book,
    },
    {
      'id': 104,
      'titre': 'Carton Histoire',
      'categorie': 'HISTOIRE',
      'description': 'Histoire mondiale, Archéologie et Civilisations.',
      'couleur': const Color(0xFFDC2626),
      'icone': Icons.public,
    },
    {
      'id': 105,
      'titre': 'Carton Économie',
      'categorie': 'ÉCONOMIE',
      'description': 'Microéconomie, Macroéconomie et Finance.',
      'couleur': const Color(0xFF7C3AED),
      'icone': Icons.bar_chart,
    },
    {
      'id': 106,
      'titre': 'Carton Droit',
      'categorie': 'DROIT',
      'description': 'Droit civil, Droit pénal et Droit international.',
      'couleur': const Color(0xFF0891B2),
      'icone': Icons.gavel,
    },
  ];

  List<Map<String, dynamic>> get _cataloguesFiltres {
    if (_recherche.isEmpty) return _catalogues;
    return _catalogues.where((c) =>
    c['titre'].toString().toLowerCase().contains(_recherche.toLowerCase()) ||
        c['categorie'].toString().toLowerCase().contains(_recherche.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            'UPB Biblio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _recherche = v),
        decoration: InputDecoration(
          hintText: 'Rechercher un carton, une catégorie...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _cataloguesFiltres.length,
      itemBuilder: (context, index) {
        return _buildCarton(_cataloguesFiltres[index]);
      },
    );
  }

  Widget _buildCarton(Map<String, dynamic> catalogue) {
    return GestureDetector(
      onTap: () => _ouvrirCatalogue(catalogue),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD4A76A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: catalogue['couleur'],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(catalogue['icone'] as IconData,
                        color: Colors.white, size: 20),
                  ),
                  Text(
                    '# ${catalogue['id']}',
                    style: TextStyle(
                      color: catalogue['couleur'],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                catalogue['titre'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                catalogue['description'],
                style: TextStyle(color: Colors.grey[700], fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.image, color: Colors.grey, size: 20),
                  Text(
                    'OUVRIR LE CARTON →',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: catalogue['couleur'],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ouvrirCatalogue(Map<String, dynamic> catalogue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ouverture de ${catalogue['titre']}...')),
    );
  }
}