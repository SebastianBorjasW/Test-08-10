// author: Renato García Morán
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'add_patient_screen.dart';
import '../services/api_service.dart';
import '../models/patient_model.dart';
import 'patient_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();
  List<Patient> patients = [];
  bool isLoading = true;
  Map<int, String> doctorNames = {}; // almacenar los nombres de los doctores
  String selectedFilter = 'Todos'; // filtro inicial de diagnósticos

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final response = await apiService.getPatients();
      setState(() {
        patients = response;
        isLoading = false;
      });
      await fetchDoctorNames(); // Obtener los nombres de los doctores
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al obtener la lista de pacientes: $e'),
      ));
    }
  }

  Future<void> fetchDoctorNames() async {
    for (var patient in patients) {
      if (!doctorNames.containsKey(patient.doctor_id)) {
        // si el ID del doctor no está en el map, se obtiene con la api
        try {
          final doctor = await apiService.getDoctor(patient.doctor_id);
          if (doctor != null) {
            setState(() {
              doctorNames[patient.doctor_id] = doctor.first_name;
            });
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error al obtener el doctor con ID ${patient.doctor_id}: $e'),
          ));
        }
      }
    }
  }

  List<Patient> getFilteredPatients() {
    if (selectedFilter == 'Todos') {
      return patients;
    } else {
      return patients
          .where((patient) => patient.diagnosis == selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[900],
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'Pacientes',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AddPatientScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: const Text(
                'Registrar Paciente',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Text(
                          'Filtrar pacientes',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedFilter,
                          items: <String>[
                            'Todos',
                            'Covid',
                            'Viral Pneumonia',
                            'Normal'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFilter = newValue!;
                            });
                          },
                          dropdownColor: Colors.grey[800],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Nombre',
                                            style: TextStyle(
                                                color: Colors.white))))),
                            DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Apellido',
                                            style: TextStyle(
                                                color: Colors.white))))),
                            DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Sexo',
                                            style: TextStyle(
                                                color: Colors.white))))),
                            DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Fecha Nac.',
                                            style: TextStyle(
                                                color: Colors.white))))),
                            DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Doctor',
                                            style: TextStyle(
                                                color: Colors.white))))),
                            DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Diagnóstico',
                                            style: TextStyle(
                                                color: Colors.white))))),
                          ],
                          rows: getFilteredPatients().map((patient) {
                            final doctorName =
                                doctorNames[patient.doctor_id] ?? 'Desconocido';
                            return DataRow(
                              cells: [
                                DataCell(Center(
                                    child: Text(patient.first_name,
                                        style: const TextStyle(
                                            color: Colors.white)))),
                                DataCell(Center(
                                    child: Text(patient.last_name,
                                        style: const TextStyle(
                                            color: Colors.white)))),
                                DataCell(Center(
                                    child: Text(patient.sex,
                                        style: const TextStyle(
                                            color: Colors.white)))),
                                DataCell(Center(
                                    child: Text(
                                        patient.dob
                                            .toIso8601String()
                                            .substring(0, 10),
                                        style: const TextStyle(
                                            color: Colors.white)))),
                                DataCell(Center(
                                    child: Text(doctorName,
                                        style: const TextStyle(
                                            color: Colors.white)))),
                                DataCell(Center(
                                    child: Text(patient.diagnosis,
                                        style: const TextStyle(
                                            color: Colors.white)))),
                              ],
                              onSelectChanged: (selected) {
                                if (selected ?? false) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PatientDetailScreen(patient: patient),
                                    ),
                                  );
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
