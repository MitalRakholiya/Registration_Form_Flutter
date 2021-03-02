import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.deepOrange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nm = new TextEditingController();
  TextEditingController cnm = new TextEditingController();
  TextEditingController mn = new TextEditingController();
  TextEditingController email = new TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final List<String> categories = [
    "ISO",
    "Subsidy",
    "Project Loan",
    "Training"
  ];

  final List<String> companytypes = [
    "Pvt Ltd.",
    "LLP.",
    "Ltd.",
    "Sole Proprietorship."
  ];

  final List<String> locations = ["India", "UAE", "Africa", "Kuwait", "Qatar"];

  String _currentcomtp;
  String _currentloc;
  String _currentcategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registration Form",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          //Created a form
          child: Form(
            //Autovalidates form
            autovalidateMode: AutovalidateMode.always,
            key: formkey,
            //For multiple widgets use Colume
            child: new SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                      controller: nm,
                      decoration: InputDecoration(
                          labelText: "Name", border: OutlineInputBorder()),
                      validator: RequiredValidator(errorText: "Required !")),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                        controller: cnm,
                        decoration: InputDecoration(
                            labelText: "Company Name",
                            border: OutlineInputBorder()),
                        validator: RequiredValidator(errorText: "Required !")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: DropdownButtonFormField(
                      items: companytypes.map((comtp) {
                        return DropdownMenuItem(
                          value: comtp,
                          child: Text('$comtp'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _currentcomtp = val),
                      hint: Text("Company type"),
                      //validator: RequiredValidator(errorText: "Required !"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: DropdownButtonFormField(
                      items: locations.map((loc) {
                        return DropdownMenuItem(
                          value: loc,
                          child: Text('$loc'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _currentloc = val),
                      hint: Text("Location"),
                      //validator: RequiredValidator(errorText: "Required !")
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                        controller: mn,
                        decoration: InputDecoration(
                            labelText: "Mobile No.",
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: RequiredValidator(errorText: "Required !")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          labelText: "E-Mail", border: OutlineInputBorder()),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required !"),
                        EmailValidator(errorText: "Invalid Email Address !"),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: DropdownButtonFormField(
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text('$category'),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _currentcategory = val),
                      hint: Text("Category"),
                      //validator: RequiredValidator(errorText: "Required !")
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: FlatButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        Map<String, dynamic> data = {
                          "1.Employee Name": nm.text,
                          "2.Company Name": cnm.text,
                          "3.Company Type": _currentcomtp,
                          "4.Location": _currentloc,
                          "5.Mobile No.": mn.text,
                          "6.Email": email.text,
                          "7.Category": _currentcategory
                        };
                        Firestore.instance.collection("records").add(data);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
