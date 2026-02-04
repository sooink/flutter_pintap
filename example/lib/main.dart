import 'package:flutter/material.dart';
import 'package:flutter_pintap/flutter_pintap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pintap Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const FlutterPintap(
        // verbose: true,  // Enable debug logs
        child: DemoPage(),
      ),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Rotation animation (infinite repeat)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Pulse animation (scale change)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pintap Demo Kitchen'),
        backgroundColor: Colors.teal.shade100,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== Animations Section ====================
          _buildHeader('🎬 Animations (Test Freeze)'),
          const Text(
            'Use Freeze button to pause these animations',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. Loading spinner
                Column(
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                    const SizedBox(height: 8),
                    Text('Spinner', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),

                // 2. Rotating icon
                Column(
                  children: [
                    RotationTransition(
                      turns: _rotationController,
                      child: const Icon(Icons.settings, size: 40, color: Colors.teal),
                    ),
                    const SizedBox(height: 8),
                    Text('Rotation', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),

                // 3. Pulse effect
                Column(
                  children: [
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite, color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Pulse', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),

                // 4. Fade in/out
                Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) => Opacity(
                        opacity: _pulseController.value,
                        child: child,
                      ),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.star, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Fade', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // AnimatedContainer (tap to change)
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: _isExpanded ? 200 : 120,
              height: 50,
              decoration: BoxDecoration(
                color: _isExpanded ? Colors.orange : Colors.teal,
                borderRadius: BorderRadius.circular(_isExpanded ? 25 : 8),
              ),
              alignment: Alignment.center,
              child: Text(
                _isExpanded ? 'Tap to shrink' : 'Tap to expand',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ==================== Basic Widgets ====================
          _buildHeader('Basic Widgets'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('This is a simple Text widget'),
                  SizedBox(height: 10),
                  Divider(),
                  Text(
                    'Another text below divider',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          _buildHeader('Interactive Buttons'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              FilledButton(onPressed: () {}, child: const Text('Filled')),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star),
                tooltip: 'Star Icon',
              ),
              FloatingActionButton.small(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildHeader('Input Fields'),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter some text',
              prefixIcon: Icon(Icons.text_fields),
            ),
          ),
          const SizedBox(height: 10),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),

          const SizedBox(height: 20),

          _buildHeader('Complex Layout (Grid)'),
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(8),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(6, (index) {
                return Container(
                  color: Colors.teal.withAlpha(50 * (index + 1)),
                  alignment: Alignment.center,
                  child: Text('Grid $index'),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          _buildHeader('List Items'),
          ...List.generate(
            3,
            (index) => ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('List Tile Item ${index + 1}'),
              subtitle: const Text('Subtitle description goes here'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }
}
