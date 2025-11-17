import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import 'comments_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = .new();
  late final GenUiConversation conversation;
  final _surfaceIds = <String>[];

  @override
  void initState() {
    super.initState();

    final catalog = CoreCatalogItems.asCatalog().copyWith([workoutCard]);
    final generator = FirebaseAiContentGenerator(
      catalog: catalog,
      systemInstruction: '''
      You are an expert in creating workout plans using **only**
      body weight exercies. No cardio, free weights, or other sports.
      Each workout plan should be 3 to 5 different exercises, each with
      a number of sets and repetitions.

      When I send you a message, generate a WrokoutCard that displays the workout plan
      you create in response.
''',
    );

    conversation = GenUiConversation(
      contentGenerator: generator,
      genUiManager: GenUiManager(catalog: catalog),
      onSurfaceAdded: _onSurfaceAdded,
      onSurfaceDeleted: _onSurfaceDeleted,
    );
  }

  void _onSurfaceAdded(SurfaceAdded update) {
    setState(() => _surfaceIds.add(update.surfaceId));
  }

  void _onSurfaceDeleted(SurfaceRemoved update) {
    setState(() => _surfaceIds.remove(update.surfaceId));
  }

  Future<void> _sendMessage(String text) async {
    final msg = text.trim();
    if (msg.isNotEmpty) {
      return conversation.sendRequest(UserMessage.text(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home Screen"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _surfaceIds.length,
              itemBuilder: (context, index) {
                final id = _surfaceIds[index];

                return GenUiSurface(host: conversation.host, surfaceId: id);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hint: Text('Enter a message'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _sendMessage(_textController.text);
                      _textController.clear();
                    },
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final _schema = S.object(
  properties: {
    'title': S.string(description: 'The title of the workout'),
    'exercises': S.list(
      description: 'A lis of 3-5 exercises to perform as part of the workout',
      items: S.string(
        description:
            'The type of exercise to perform, incluiding name and details '
            'like the amount of sets, reps, and time. 50 characters max.',
        minLength: 3,
        maxLength: 5,
      ),
    ),
  },
  required: ['title', 'exercises'],
);

final workoutCard = CatalogItem(
  name: 'WorkoutCard',
  dataSchema: _schema,
  widgetBuilder: (context) {
    final json = context.data as Map<String, Object?>;
    final title = json['title'] as String;
    final exercises = (json['exercises'] as List<dynamic>)
        .map((s) => s.toString())
        .toList();

    return WorkoutCard(
      title: title,
      exercises: exercises,
    );
  },
);

class WorkoutCard extends StatelessWidget {
  final String title;
  final List<String> exercises;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16.0),
            ...exercises.map(
              (exercise) => ListTile(
                leading: Icon(Icons.fitness_center, color: colorScheme.primary),
                title: Text(
                  exercise,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(itemId: title),
                    ),
                  );
                },
                child: const Text('View Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
