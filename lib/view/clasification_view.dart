import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/widgets/toggle_buttons.dart';
import 'package:flutter/material.dart';

class ClasificationScreen extends StatelessWidget {
  const ClasificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: ToggleButtonsClasification(),
              ),
              StreamBuilder<List<UserModel>>(
                  stream: DataServices().userList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<UserModel>> snapshot) {
                       if(snapshot.hasError){
                        print(snapshot.error);
                        return Text(snapshot.error.toString());
                       }
                    if (snapshot.hasData) {
                      var users = snapshot.data!;
                       print(snapshot.data);
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (BuildContext context, int index) {
                            final user = users[index];
                            print(user);
                            return ListTile(
                              
                              leading: user.avatar == ""
                                  ? Stack(children: [ const Padding(
                                    padding: EdgeInsets.only(left:32.0),
                                    child: CircleAvatar(
                                        child: Icon(Icons.sports_bar)),
                                  ), Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text("${index+1}.", style: TextStyle(fontSize: 25),),
                                  ),])
                                  : Container(),
                              title: Text(user.name),
                              trailing: Text(
                                "${user.points}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
