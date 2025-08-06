import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Task Management',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        primaryColor: const Color(0xFF6366F1),
        fontFamily: 'SF Pro Display',
      ),
      home: const TodoHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({Key? key}) : super(key: key);

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage>
    with SingleTickerProviderStateMixin {
  String selectedFilter = 'Today';
  final TextEditingController searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  List<Task> get filteredTasks {
    List<Task> filtered;
    switch (selectedFilter) {
      case 'All':
        filtered = tasks;
        break;
      case 'Today':
        filtered = tasks;
        break;
      case 'Completed':
        filtered = tasks.where((task) => task.isCompleted).toList();
        break;
      case 'Pending':
        filtered = tasks.where((task) => !task.isCompleted).toList();
        break;
      default:
        filtered = tasks;
    }

    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where((task) =>
              task.title
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              task.description
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;
  double get progressPercentage =>
      tasks.isEmpty ? 0 : completedTasksCount / tasks.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1117),
              Color(0xFF161B22),
              Color(0xFF21262D),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        const SizedBox(height: 24),
                        _buildProgressSection(),
                        const SizedBox(height: 32),
                        _buildFilterTabs(),
                        const SizedBox(height: 24),
                        _buildTasksList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'You have ${tasks.where((t) => !t.isCompleted).length} tasks pending',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF21262D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[500]),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: Colors.grey[500]),
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF21262D), Color(0xFF30363D)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Progress",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF6366F1).withOpacity(0.2)),
                ),
                child: Text(
                  '$completedTasksCount/${tasks.length}',
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progressPercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progressPercentage * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF21262D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Row(
        children: ['All', 'Today', 'Completed', 'Pending'].map((filter) {
          final isSelected = selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTasksList() {
    final filtered = filteredTasks;

    if (filtered.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF21262D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  color: Colors.grey[600],
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No tasks found',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add a new task to get started',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final task = filtered[index];
          return TaskCard(
            task: task,
            onToggle: () {
              setState(() {
                task.isCompleted = !task.isCompleted;
              });
            },
            onDelete: () {
              setState(() {
                tasks.remove(task);
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showAddTaskDialog,
      backgroundColor: const Color(0xFF6366F1),
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'Add Task',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.low;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF21262D),
          title:
              const Text('Add New Task', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(titleController, 'Title'),
                _buildTextField(descriptionController, 'Description'),
                _buildTextField(timeController, 'Time (e.g., 14:00)'),
                _buildTextField(categoryController, 'Category'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Priority:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 12),
                    DropdownButton<TaskPriority>(
                      value: selectedPriority,
                      dropdownColor: const Color(0xFF21262D),
                      onChanged: (newValue) {
                        setState(() {
                          selectedPriority = newValue!;
                        });
                      },
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(
                            priority.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  setState(() {
                    tasks.add(
                      Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        description: descriptionController.text,
                        priority: selectedPriority,
                        time: timeController.text.isNotEmpty
                            ? timeController.text
                            : '00:00',
                        category: categoryController.text.isNotEmpty
                            ? categoryController.text
                            : 'General',
                        dueDate: DateTime.now(),
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child:
                  const Text('Add', style: TextStyle(color: Color(0xFF6366F1))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF21262D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted
              ? const Color(0xFF22C55E).withOpacity(0.3)
              : const Color(0xFF30363D),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? const Color(0xFF22C55E)
                        : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? const Color(0xFF22C55E)
                          : Colors.grey[600]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: task.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color:
                            task.isCompleted ? Colors.grey[500] : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: TextStyle(
                        color: task.isCompleted
                            ? Colors.grey[600]
                            : Colors.grey[400],
                        fontSize: 14,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: Colors.grey[500]),
                color: const Color(0xFF30363D),
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Task',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey[500], size: 16),
                  const SizedBox(width: 4),
                  Text(
                    task.time,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.category_rounded,
                      color: Colors.grey[500], size: 16),
                  const SizedBox(width: 4),
                  Text(
                    task.category,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final String time;
  final String category;
  final DateTime dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.time,
    required this.category,
    required this.dueDate,
    this.isCompleted = false,
  });
}