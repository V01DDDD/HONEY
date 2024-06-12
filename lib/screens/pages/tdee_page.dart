import 'package:firebase_auth_youtube/blocs/tdee_bloc/tdee_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth_youtube/blocs/tdee_bloc/tdee_bloc.dart';

class TDEE extends StatelessWidget {
  const TDEE({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TdeeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TDEE Calculator'),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<TdeeBloc, TdeeState>(
            builder: (context, state) {
              if (state is TdeeInitial) {
                return const TDEEForm();
              } else if (state is TdeeResult) {
                return TDEEResults(calculator: state.calculator);
              } else {
                return const Center(child: Text('Unexpected state'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class TDEEResults extends StatelessWidget {
  final TdeeCalculator calculator;

  const TDEEResults({Key? key, required this.calculator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tdeeResults = calculator.calculateTDEE();
    final bmi = calculator.calculateBMI();
    final idealWeight = calculator.calculateIdealWeight();
    final String bmiClass = calculator.classifyBMI(bmi);

    return ListView(
      children: [
        _buildSectionTitle('Your Maintenance Calories'),
        _buildMaintenanceCalories(context, tdeeResults),
        const SizedBox(height: 16),
        _buildSectionTitle('Ideal Weight: ${idealWeight['Hamwi']?.toStringAsFixed(0)} kg'),
        const SizedBox(height: 8),
        Text(
          'Your ideal body weight is estimated to be between ${idealWeight['Robinson']?.toStringAsFixed(1)} - ${idealWeight['Miller']?.toStringAsFixed(1)} kg based on the various formulas listed below. These formulas are based on your height and represent averages so don’t take them too seriously, especially if you lift weights.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        _buildResultRow(context, 'G.J. Hamwi Formula (1964)', '${idealWeight['Hamwi']?.toStringAsFixed(1)} kg'),
        _buildResultRow(context, 'B.J. Devine Formula (1974)', '${idealWeight['Devine']?.toStringAsFixed(1)} kg'),
        _buildResultRow(context, 'J.D. Robinson Formula (1983)', '${idealWeight['Robinson']?.toStringAsFixed(1)} kg'),
        _buildResultRow(context, 'D.R. Miller Formula (1983)', '${idealWeight['Miller']?.toStringAsFixed(1)} kg'),
        const SizedBox(height: 16),
        _buildSectionTitle('BMI Classification'),
        _buildBmiClassification(context, bmiClass),
        const SizedBox(height: 16),
        _buildSectionTitle('BMI Score: ${bmi.toStringAsFixed(1)}'),
        Text(
          'Your BMI is ${bmi.toStringAsFixed(1)}, which means you are classified as $bmiClass.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        _buildResultRow(context, '18.5 or less', 'Underweight'),
        _buildResultRow(context, '18.5 – 24.99', 'Normal Weight'),
        _buildResultRow(context, '25 – 29.99', 'Overweight'),
        _buildResultRow(context, '30+', 'Obese'),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          onPressed: () {
            context.read<TdeeBloc>().add(const TdeeReset());
          },
          child: const Text(
            'Recalculate',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceCalories(BuildContext context, Map<String, double?> tdeeResults) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.3), // Opaque teal color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '${tdeeResults['Sedentary']?.toStringAsFixed(2)} calories per day',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 20, thickness: 2),
          Text(
            '${(tdeeResults['Sedentary']! * 7).toStringAsFixed(2)} calories per week',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildResultRow(context, 'Basal Metabolic Rate', '${tdeeResults['Basal Metabolic Rate']?.toStringAsFixed(2)} calories per day'),
          _buildResultRow(context, 'Sedentary', '${tdeeResults['Sedentary']?.toStringAsFixed(2)} calories per day'),
          _buildResultRow(context, 'Light Exercise', '${tdeeResults['Light Exercise']?.toStringAsFixed(2)} calories per day'),
          _buildResultRow(context, 'Moderate Exercise', '${tdeeResults['Moderate Exercise']?.toStringAsFixed(2)} calories per day'),
          _buildResultRow(context, 'Heavy Exercise', '${tdeeResults['Heavy Exercise']?.toStringAsFixed(2)} calories per day'),
          _buildResultRow(context, 'Athlete', '${tdeeResults['Athlete']?.toStringAsFixed(2)} calories per day'),
        ],
      ),
    );
  }

  Widget _buildBmiClassification(BuildContext context, String bmiClass) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _getBmiColor(bmiClass),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'BMI Classification:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            bmiClass,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getBmiColor(String bmiClass) {
    switch (bmiClass) {
      case 'Underweight':
        return Colors.yellow.withOpacity(0.3);
      case 'Normal Weight':
        return Colors.teal.withOpacity(0.3);
      case 'Overweight':
        return Colors.orange.withOpacity(0.3);
      case 'Obese':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  Widget _buildResultRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TDEEForm extends StatefulWidget {
  const TDEEForm({Key? key}) : super(key: key);

  @override
  _TDEEFormState createState() => _TDEEFormState();
}

class _TDEEFormState extends State<TDEEForm> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bodyFatController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String gender = 'Male';

  String? bodyFatValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    final double parsedValue = double.tryParse(value) ?? 0.0;
    if (parsedValue > 40) {
      return 'Body fat percentage should be less than or equal to 40';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildTextField(weightController, 'Weight (kg)'),
          _buildTextField(heightController, 'Height (cm)'),
          _buildTextField(ageController, 'Age'),
          _buildTextField(bodyFatController, 'Body Fat Percentage', validator: bodyFatValidator),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: gender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
            ),
            onChanged: (String? newValue) {
              setState(() {
                gender = newValue!;
              });
            },
            items: <String>['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<TdeeBloc>().add(SubmitTdeeInfo(
                  weight: int.parse(weightController.text),
                  height: int.parse(heightController.text),
                  age: int.parse(ageController.text),
                  gender: gender,
                  bodyFatPercentage: double.parse(bodyFatController.text),
                ));
              }
            },
            child: const Text(
              'Calculate TDEE',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: validator,
      ),
    );
  }
}
