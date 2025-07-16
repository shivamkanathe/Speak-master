import 'package:communicate/verb_data.dart';
import 'package:flutter/material.dart';

class VerbEntry {
  final String verb;
  final String id;
  final String pastSimple;
  final String pastParticiple;
  final String gerund;
  final String hindi;

  VerbEntry({
    required this.id,
    required this.verb,
    required this.pastSimple,
    required this.pastParticiple,
    required this.gerund,
    required this.hindi,
  });
}

class VerbsTableScreen extends StatelessWidget {
  VerbsTableScreen({Key? key}) : super(key: key);

 final List<VerbEntry> highFrequencyVerbs = my_verbs.map((map){
   return VerbEntry(
    id: map['id'] ?? '',
        verb: map['v2'] ?? '',
        pastSimple: map['v2_past'] ?? '',
        pastParticiple: map['v3_past'] ?? '',
        gerund: map['v4_ing_form'] ?? '',
        hindi: map['hindi'] ?? '',
      ); 
 }).toList();


  Widget buildVerbGroup(String groupTitle, List<VerbEntry> verbs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          groupTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(color: Colors.grey),
            columnWidths: const {
              0: FixedColumnWidth(50),
              1: FixedColumnWidth(100),
              2: FixedColumnWidth(100),
              3: FixedColumnWidth(120),
              4: FixedColumnWidth(100),
              5: FixedColumnWidth(120),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.deepPurple.shade100),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('In.', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Verb', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Past II', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Past III', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ing', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Hindi', style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromRGBO(0, 0, 0, 1))),
                  ),
                ],
              ),
              ...verbs.map((v) {
                  return TableRow( 
                  children: [
                    Padding( 
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${v.id}",  
                        softWrap: false,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        v.verb,
                        softWrap: false,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        v.pastSimple,
                        softWrap: false,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        v.pastParticiple,
                        softWrap: false,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        v.gerund,
                        softWrap: false,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        v.hindi,
                        softWrap: false,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
                }
              ),
            ],
          ),
        ),
      ],
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verbs with Hindi',style: TextTheme.of(context).bodyLarge  ,),
        elevation: 0,
        automaticallyImplyLeading: false,
       leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildVerbGroup('Verbs', highFrequencyVerbs),
            // ✅ Add more groups here...
          ],
        ),
      ),
    );
  }
}
