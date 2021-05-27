import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class LeaderBoardsScreen extends StatefulWidget {
  @override
  _LeaderBoardsScreenState createState() => _LeaderBoardsScreenState();
}

class _LeaderBoardsScreenState extends State<LeaderBoardsScreen> {
  var topUsers;

  void getTopPlayers() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('score')
        .limit(25)
        .get()
        .then((data) {
        setState(() {
          topUsers = data.docs;
        });
    });
  }

  @override
  void initState() {
    print(topUsers);
    getTopPlayers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(topUsers == null) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff141e30), Color(0xff243b55)]
            )
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        ),
      );
    } else {
      final List fixedList = Iterable<int>.generate(topUsers.length).toList();

      return Container(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff141e30), Color(0xff243b55)]
                )
            ),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all<
                  Color>(Color(0xff141e30)),
              dataRowColor: MaterialStateProperty.all<
                  Color>(Color(0xff243b55)),
              sortColumnIndex: 0,
              sortAscending: true,
              columns: [
                DataColumn(
                  label: Text("#", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: convW(16,context),
                  ),),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("User", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: convW(16,context),
                  ),),
                  numeric: false,
                ),
                DataColumn(
                  label: Text("Score", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: convW(16,context),
                  ),),
                  numeric: true,
                ),
              ],
            rows: fixedList.map(
                  (index) => DataRow(
                  cells: [
                    DataCell(
                      Text("${index + 1}", style: TextStyle(fontSize: convW(16,context), color: Colors.white,),),
                    ),
                    DataCell(
                      Text(topUsers[index]['name'], style: TextStyle(color: Colors.white, fontSize: convW(16,context),)),
                    ),
                    DataCell(
                      Text(topUsers[index]['score'].toString(), style: TextStyle(fontSize: convW(16,context),color: Colors.white,),),
                    ),
                  ]),
            ).toList(),
            ),
          ),
        ),
      );
    }
  }
}
