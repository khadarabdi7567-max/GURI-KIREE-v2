import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const GuriKireeApp());

class GuriKireeApp extends StatelessWidget {
  const GuriKireeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GURI-KIREE v2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class House {
  final String title, location, price;
  final IconData icon;
  const House(this.title, this.location, this.price, this.icon);
}

const houses = [
  House('Guri 2 qol ah', 'Mogadishu', '\$250 / bishii', Icons.home),
  House('Guri 3 qol ah', 'Hargeisa', '\$300 / bishii', Icons.house),
  House('Apartment casri ah', 'Jigjiga', '\$220 / bishii', Icons.apartment),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '';

  Future<void> callOwner() async {
    final uri = Uri(scheme: 'tel', path: '+252610000000');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> whatsapp() async {
    final uri = Uri.parse('https://wa.me/252610000000?text=Salaan%20GURI-KIREE');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final list = houses.where((h) =>
      h.title.toLowerCase().contains(query.toLowerCase()) ||
      h.location.toLowerCase().contains(query.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GURI-KIREE v2', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications ayaa dhawaan imanaya.'))),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('GURI-KIREE'),
              accountEmail: Text('Raadi guri aad kireysato'),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.home)),
            ),
            ListTile(leading: const Icon(Icons.login), title: const Text('Login / Register'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login/Register ayaa qaybta xigta lagu dari doonaa.')))),
            ListTile(leading: const Icon(Icons.map), title: const Text('Map'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage()))),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Guri aad raadinayso?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: InputDecoration(
              hintText: 'Raadi magaalada ama nooca guriga...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 105,
            child: Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage())),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(children: [
                    Icon(Icons.map, size: 52),
                    SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Khariidadda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Ka eeg guryaha iyo goobahooda')]))
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Guryaha la heli karo', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...list.map((h) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: 120, width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.indigo.withOpacity(.08)),
                  child: Icon(h.icon, size: 70)),
                const SizedBox(height: 10),
                Text(h.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('📍 ${h.location}'),
                Text(h.price, style: const TextStyle(fontWeight: FontWeight.w600)),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(onPressed: callOwner, icon: const Icon(Icons.call), label: const Text('Call'))),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton.icon(onPressed: whatsapp, icon: const Icon(Icons.chat), label: const Text('WhatsApp'))),
                ])
              ]),
            ),
          )),
        ],
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Map / Location')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.location_on, size: 90),
          const SizedBox(height: 16),
          const Text('Map-ka ayaa qaybta xigta lagu xiri doonaa.',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('App-ka koowaad hadda wuxuu leeyahay Home, Search, guryo, Call iyo WhatsApp.'),
        ]),
      ),
    ),
  );
}
