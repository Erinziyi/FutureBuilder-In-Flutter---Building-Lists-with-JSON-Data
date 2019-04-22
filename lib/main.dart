import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/painting.dart';
import 'dart:convert';
import 'dart:async';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll View',
      debugShowCheckedModeBanner: false,


      theme: ThemeData(

        primarySwatch: Colors.orange,

      ),
      home: MyHomePage(title: 'Scroll View'),

    );
  }
}

class Contact{
  Contact({this.name, this.email});
  final String name;
  final String email;
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//api
class _MyHomePageState extends State<MyHomePage> {
  Future <List<User>> _getUsers()async{
    var data = await http.get("http://www.json-generator.com/api/json/get/cfwZmvEBbC?indent=2");
    var jsonData = json.decode(data.body);
    List<User> users = [];
    for (var u in jsonData){
      User user = User(u["index"],u["about"],u["name"],u["email"],u["picture"]);

      users.add(user);

    }

    print(users.length);

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getUsers(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              print(snapshot.data);
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext content, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data[index].picture
                        ),
                      ),
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].email),
                      onTap: (){
                        Navigator.push(context,
                          new MaterialPageRoute(builder: (context)=> DetailPage(snapshot.data[index]))
                        );
                      },
                    );
                  },
                );
              }
            }
        ),
      ),

    );
  }

}

class DetailPage extends StatelessWidget {

  final User user;
  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),


      ),

    );
  }
}


//object
class User {
  final int index;
  final String about;
  final String name;
  final String email;
  final String picture;
  User (this.index,this.about, this.name, this.email, this.picture);


}





