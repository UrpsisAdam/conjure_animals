import 'package:flutter/material.dart';
import 'beast_model.dart';
import 'beast_data.dart';
import 'beast_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Conjure Animals',
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: new BeastList()
    )
  );
}

class BeastListState extends State<BeastList>{

  Widget _buildBeastList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index < kBeasts.length) {
          return _buildRow(kBeasts[index]);
        }

      },

    );

  }

  Widget _buildRow(Beast beast) {
    return ListTile(
      title: Text(beast.bType + "  -  CR: " + beast.cr, style: TextStyle(fontSize: 18.0)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BeastPage(beast: beast))
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conjure Animals')
      ),
      body: _buildBeastList()
    );
  }
}

class BeastList extends StatefulWidget {

  @override
  BeastListState createState() => new BeastListState();
}

