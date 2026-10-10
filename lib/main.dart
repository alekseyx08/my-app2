import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабараторная работа №3',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const FirstScreen(),
    );
  }
}

// ---------- ЭКРАН-1 форма ввода ----------

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _agreement = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!_agreement) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Необходимо согласие на обработку данных'),
          ),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(
            weight: double.parse(_weightController.text.replaceAll(',', '.')),
            height: double.parse(_heightController.text.replaceAll(',', '.')),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Холхонов Алексей Викторович')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Вес (кг)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите вес';
                  }
                  final w = double.tryParse(value.replaceAll(',', '.'));
                  if (w == null) return 'Введите число';
                  if (w <= 0) return 'Вес должен быть больше нуля';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Рост (см)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите рост';
                  }
                  final h = double.tryParse(value.replaceAll(',', '.'));
                  if (h == null) return 'Введите число';
                  if (h <= 0) return 'Рост должен быть больше нуля';
                  return null;
                },
              ),
              CheckboxListTile(
                title: const Text('Согласие на обработку данных'),
                value: _agreement,
                onChanged: (v) => setState(() => _agreement = v ?? false),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Рассчитать Индекс масса тела'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- ЭКРАН-2 расчёт и результат ----------

class SecondScreen extends StatelessWidget {
  final double weight;
  final double height;

  const SecondScreen({super.key, required this.weight, required this.height});

  double get bmi {
    final h = height / 100; // сантиметры -> метры
    return weight / (h * h);
  }

  String get interpretation {
    if (bmi < 18.5) return 'Недостаточный вес';
    if (bmi < 25) return 'Норма';
    if (bmi < 30) return 'Избыточный вес';
    return 'Ожирение';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Результат')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ваш Индекс массы тела: ${bmi.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(interpretation, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
