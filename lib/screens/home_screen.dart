import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';
import '../themes/app_theme.dart'; // Theme import for reference

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      Provider.of<TaskProvider>(context, listen: false).setFilter(
        _tabController.index == 0 ? 'all' : _tabController.index == 1 ? 'pending' : 'completed',
      );
    });
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).loadTasks();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskTrack'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Tasks',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                Provider.of<TaskProvider>(context, listen: false).setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text(
                'No tasks found. Add one!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ) // Empty state
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskTile(task: tasks[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.rgbTheme.primaryColor, // Explicitly use theme color
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}