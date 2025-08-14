import 'package:flutter/material.dart';
import 'package:my_first_app/utils/shared_pref_util.dart';
import '../models/task_model.dart';
import '../widgets/add_task_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback toggleTheme;

  const HomeScreen({super.key, required this.isDarkTheme, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await SharedPrefsUtil.loadTasks();
    setState(() {
      tasks = loadedTasks;
      filteredTasks = loadedTasks;
    });
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
      _applyFilters();
    });
    SharedPrefsUtil.saveTasks(tasks);
  }

  void _applyFilters() {
    List<Task> temp = tasks;

    if (selectedCategory != 'All') {
      temp = temp.where((task) => task.category.toLowerCase() == selectedCategory.toLowerCase()).toList();
    }

    if (searchQuery.isNotEmpty) {
      temp = temp.where((task) => task.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    setState(() {
      filteredTasks = temp;
    });
  }

  void _onSearchChanged(String val) {
    setState(() {
      searchQuery = val;
      _applyFilters();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  List<String> getCategories() {
    final categories = tasks.map((task) => task.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  @override
  Widget build(BuildContext context) {
    final categories = getCategories();

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Task Manager'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search tasks...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          // Categories horizontal list
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final selected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => _onCategorySelected(cat),
                  ),
                );
              },
            ),
          ),

          // Task list
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(child: Text('No tasks found'))
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text('Category: ${task.category}\nDue: ${task.dueDate}'),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AddTaskBottomSheet(onAddTask: _addTask),
        ),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
