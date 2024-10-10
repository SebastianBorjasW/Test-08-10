import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'add_patient_screen.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();
  List<Patient> patients = [];
  bool isLoading = true;

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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al obtener la lista de pacientes: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text(
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
                      AddPatientScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: Text(
              'Registrar Paciente',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: double.infinity,
                child: DataTable(
                  columns: [
                    DataColumn(label: Expanded(child: Center(child: Text('Nombre', style: TextStyle(color: Colors.white))))),
                    DataColumn(label: Expanded(child: Center(child: Text('Apellido', style: TextStyle(color: Colors.white))))),
                    DataColumn(label: Expanded(child: Center(child: Text('Sexo', style: TextStyle(color: Colors.white))))),
                    DataColumn(label: Expanded(child: Center(child: Text('Fecha Nac.', style: TextStyle(color: Colors.white))))),
                    DataColumn(label: Expanded(child: Center(child: Text('ID Doctor', style: TextStyle(color: Colors.white))))),
                    DataColumn(label: Expanded(child: Center(child: Text('Diagnóstico', style: TextStyle(color: Colors.white))))),
                  ],
                  rows: patients
                      .map(
                        (patient) => DataRow(cells: [
                          DataCell(Center(child: Text(patient.first_name, style: TextStyle(color: Colors.white)))),
                          DataCell(Center(child: Text(patient.last_name, style: TextStyle(color: Colors.white)))),
                          DataCell(Center(child: Text(patient.sex, style: TextStyle(color: Colors.white)))),
                          DataCell(Center(child: Text(patient.dob.toIso8601String().substring(0, 10), style: TextStyle(color: Colors.white)))),
                          DataCell(Center(child: Text(patient.doctor_id.toString(), style: TextStyle(color: Colors.white)))),
                          DataCell(Center(child: Text(patient.diagnosis, style: TextStyle(color: Colors.white)))),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
    );
  }
}
