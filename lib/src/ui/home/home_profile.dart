import 'package:flutter/material.dart';
import 'package:ta_ppb_flutter/src/api/profile_api.dart';
import 'package:ta_ppb_flutter/src/model/profile.dart';
import 'package:ta_ppb_flutter/src/ui/auth/home.dart';
import 'package:ta_ppb_flutter/src/ui/formadd/form_add_profile.dart';

class HomeProfile extends StatefulWidget {
  @override
  _HomeProfileState createState() => _HomeProfileState();
}

class _HomeProfileState extends State<HomeProfile> {
  BuildContext context;
  ProfileApi apiService;
  @override

  void initState() {
    super.initState();
    apiService = ProfileApi();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
        backgroundColor: Color(0xff151515),
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            ),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: apiService.getProfiles(),
            builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something wrong with message: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Profile> profiles = snapshot.data;
                return _buildListView(profiles);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )
    );
  }

  Widget _buildListView(List<Profile> profiles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Profile profile = profiles[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment : MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child:
                            Image.network(
                              "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
                              height: 300,
                              width: 350,
                              fit: BoxFit.fill,
                            ),
                          )
                        ]),
                    SizedBox(height: 10),
                    Text(
                      "Nama : "+profile.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 10),
                    Text("Email : "+profile.email),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: profiles.length,
      ),
    );
  }
}
