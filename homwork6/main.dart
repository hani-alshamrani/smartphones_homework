import 'package:flutter/material.dart';
import 'loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD - Hani',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const LoginPage(),
    );
  }
}

--------------------------------------
  editdata.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class EditData extends StatefulWidget {
  final List list;
  final int index;
  const EditData({Key? key, required this.list, required this.index}) : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  late TextEditingController nisn;
  late TextEditingController nama;
  late TextEditingController alamat;

  Future _editData() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.3/flutterapi/crudflutter/edit.php"),
      body: {
        "id": widget.list[widget.index]['id'],
        "nisn": nisn.text,
        "nama": nama.text,
        "alamat": alamat.text,
      },
    );
    if (response.statusCode == 200) return true;
    return false;
  }

  @override
  void initState() {
    nisn = TextEditingController(text: widget.list[widget.index]['nisn']);
    nama = TextEditingController(text: widget.list[widget.index]['nama']);
    alamat = TextEditingController(text: widget.list[widget.index]['alamat']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل البيانات")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nisn, decoration: const InputDecoration(labelText: "NISN")),
            TextField(controller: nama, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: alamat, decoration: const InputDecoration(labelText: "Alamat")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _editData().then((value) {
                  if (value) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                  }
                });
              },
              child: const Text("تحديث"),
            ),
          ],
        ),
      ),
    );
  }
}

------------------------------------
  homepage.dart

  import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tambahdata.dart';
import 'editdata.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final respone = await http.get(
          Uri.parse("http://194.168.1.3/flutterapi/crudflutter/read.php"));
      if (respone.statusCode == 200) {
        final data = jsonDecode(respone.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _hapus(String id) async {
    try {
      final respone = await http.post(
          Uri.parse("http://192.168.1.3/flutterapi/crudflutter/delete.php"),
          body: {"id": id});
      if (respone.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("بيانات الطلاب - هاني"),
          backgroundColor: Colors.blueGrey,
        ),
        body: _isloading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _listdata.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_listdata[index]['nama']),
                      subtitle: Text(_listdata[index]['alamat']),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditData(
                                      list: _listdata,
                                      index: index,
                                    )));
                      },
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                    content: const Text("هل أنت متأكد من الحذف؟"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            _hapus(_listdata[index]['id'])
                                                .then((value) {
                                              if (value) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomePage()),
                                                    (route) => false);
                                              }
                                            });
                                          },
                                          child: const Text("نعم")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("لا")),
                                    ]);
                              }));
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  );}),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TambahData()));
          },
          child: const Icon(Icons.add),
        ));
  }
}

-------------------
  RegistrationPage.dart

  import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loginpage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; 

  Future<void> registerUser(String email, String password) async {
    
    print("إرسال طلب التسجيل في تاريخ: ${DateTime.now()}");
    
    setState(() { _isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.3/flutterapi/crudflutter/register.php'),
        body: {'email': email, 'password': password},
      ).timeout(const Duration(seconds: 10)); 

      print("استجابة السيرفر في وقت: ${DateTime.now()} - Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data == 'Success') {
          _showDialog("تم التسجيل بنجاح!");
        } else {
          _showDialog("خطأ: الإيميل قد يكون مسجل مسبقاً");
        }
      }
    } catch (e) {
      print("خطأ في الاتصال: $e");
      _showDialog("فشل الاتصال بالسيرفر، تأكد من الـ IP وشغال XAMPP");
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التسجيل - مشروع هاني')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'الإيميل', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'كلمة السر', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 25),
            _isLoading 
              ? const CircularProgressIndicator() // تطلع لما تضغط الزر
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => registerUser(_emailController.text, _passwordController.text),
                    child: const Text('تسجيل حساب جديد'),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

---------------------
  TambahData.dart

  import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  State<TambahData> createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nisn = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();

  Future _simpan() async {
    final respone = await http.post(
        Uri.parse("http://192.168.1.3/flutterapi/crudflutter/post.php"),
        body: {
          "nisn": nisn.text,
          "nama": nama.text,
          "alamat": alamat.text,
        });
    if (respone.statusCode == 200) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة بيانات")),
      body: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              TextFormField(controller: nisn, decoration: const InputDecoration(labelText: "NISN", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(controller: nama, decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(controller: alamat, decoration: const InputDecoration(labelText: "Address", border: OutlineInputBorder())),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    _simpan().then((value) {
                      if (value) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                      }
                    });
                  }
                },
                child: const Text("Simpan"),
              )
            ]),
          )),
    );
  }
}
  
-------------------------------------
  LoginPage.dart

  import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'registrationpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://194.168.1.3/flutterapi/crudflutter/login.php'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == 'Success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطأ في البريد أو كلمة المرور')),
        );
      }
    } else {
      throw Exception('Failed to connect to server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => loginUser(_emailController.text, _passwordController.text),
                child: const Text('Login'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrationPage()),
                );
              },
              child: const Text('ليس لديك حساب؟ سجل الآن'),
            ),
          ],
        ),
      ),
    );
  }
}

  
