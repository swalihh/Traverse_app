import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/widgets/Reco.dart';

class SearchPage extends StatefulWidget {
 final Map<String, dynamic> userInfo;

  SearchPage({super.key, required this.userInfo});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
  }

  _performSearch(String query) async {
    // Replace 'userid' with the actual user ID you want to query
    int userid = widget.userInfo['id']; // Replace with the actual user ID
    List<Map<String, dynamic>> results =
        await DatabaseHelper.instance.AlltripDetails(userid);

    setState(() {
      if (query.isEmpty) {
        // If the query is empty, reset the searchResults list
        searchResults.clear();
      } else {
        // Filter results based on the 'ColumnEnding' containing the query
        searchResults = results.where((result) {
          String columnEnding = result['Ending'].toString();
          return columnEnding.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            controller: _searchController,
            onChanged: (query) {
              _performSearch(query);
            },
            decoration: InputDecoration(
              hintText: 'Search here',
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderSide: BorderSide(strokeAlign: 2, color: Colors.lightBlue),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: searchResults.isEmpty
          ? Center(
              child: _searchController.text.isEmpty
                  ? Container(child: Image(image: AssetImage('assets/images/search.png')),)
                  : Lottie.asset('assets/images/ss.json'),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                // Display the data from the search results using ColumnEnding
                final tripData = searchResults[index];
                String columnEnding = tripData['Ending'];
                String tripCover = tripData['_image'];
                String tripdate = tripData['enddate'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Reco(view: tripdate, place: columnEnding, image: tripCover), 
                );
              },
            ),
    );
  }
}
