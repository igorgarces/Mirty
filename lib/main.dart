import 'package:flutter/material.dart';

void main() {
  runApp(const MirtyApp());
}

class MirtyApp extends StatelessWidget {
  const MirtyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mirty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MirtyHome(),
    );
  }
}

class MirtyHome extends StatefulWidget {
  const MirtyHome({super.key});

  @override
  State<MirtyHome> createState() => _MirtyHomeState();
}

class _MirtyHomeState extends State<MirtyHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BreathAnimationPage(),
    MemoryGamePage(),
    InfoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mirty'),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.air),
            label: 'Respiração',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_satisfied),
            label: 'Atividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informações',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// -------------------- Respiração Animada --------------------
class BreathAnimationPage extends StatefulWidget {
  const BreathAnimationPage({super.key});

  @override
  State<BreathAnimationPage> createState() => _BreathAnimationPageState();
}

class _BreathAnimationPageState extends State<BreathAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String instruction = "Inspire...";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _breatheIn();
  }

  void _breatheIn() async {
    setState(() => instruction = "Inspire...");
    await _controller.forward();
    await Future.delayed(const Duration(seconds: 1));
    setState(() => instruction = "Segure...");
    await Future.delayed(const Duration(seconds: 4));
    _breatheOut();
  }

  void _breatheOut() async {
    setState(() => instruction = "Expire...");
    await _controller.reverse();
    await Future.delayed(const Duration(seconds: 1));
    _breatheIn();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: _animation.value,
                height: _animation.value,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            instruction,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// -------------------- Mini Jogo da Memória --------------------
class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  List<String> emojis = ["🌸", "🌸", "🌞", "🌞", "🌊", "🌊"];
  List<bool> revealed = [];
  int? firstSelected;
  bool lock = false;

  @override
  void initState() {
    super.initState();
    emojis.shuffle();
    revealed = List.filled(emojis.length, false);
  }

  void _onCardTap(int index) {
    if (lock || revealed[index]) return;

    setState(() {
      revealed[index] = true;
    });

    if (firstSelected == null) {
      firstSelected = index;
    } else {
      if (emojis[firstSelected!] != emojis[index]) {
        lock = true;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            revealed[firstSelected!] = false;
            revealed[index] = false;
            lock = false;
            firstSelected = null;
          });
        });
      } else {
        firstSelected = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _onCardTap(index),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                revealed[index] ? emojis[index] : "❓",
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        );
      },
    );
  }
}

// -------------------- Página de Informações --------------------
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard(
            title: "Ansiedade",
            content: """
A ansiedade é uma resposta natural aos sinais de que uma situação ameaçadora se aproxima. Semelhante ao medo, que prepara uma pessoa para enfrentar ou fugir de uma ameaça, a ansiedade desempenha um importante papel em nossas vidas diárias. Preocupar-se com uma tarefa pode melhorar nosso foco e desempenho. 

Em alguns casos, a ansiedade é funcional – útil e necessária. No entanto, quando se torna intensa, pode prejudicar o funcionamento ou causar sofrimento significativo, caracterizando um transtorno de ansiedade.
""",
            icon: Icons.psychology,
            color: Colors.blue[100],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: "Crises de Ansiedade",
            content: """
De acordo com o DSM-5 (Manual Diagnóstico e Estatístico de Transtornos Mentais), os transtornos de ansiedade incluem sintomas de medo e ansiedade excessiva. Eles podem se manifestar de forma subjetiva (preocupações, medo, terror) e física (palpitações, falta de ar, sudorese, tontura, tremores).
""",
            icon: Icons.warning,
            color: Colors.red[100],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: "Como Lidar",
            content: """
Algumas técnicas ajudam a controlar a ansiedade:
- Exercícios de respiração profunda
- Meditação e atenção plena (mindfulness)
- Atividades físicas
- Conversar com alguém de confiança
""",
            icon: Icons.self_improvement,
            color: Colors.green[100],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Função de emergência em desenvolvimento"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            icon: const Icon(Icons.phone_in_talk, size: 24),
            label: const Text(
              "Preciso de ajuda",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    Color? color,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: Colors.blueGrey[800]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
