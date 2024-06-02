import 'dart:convert'; // For JSON decoding

import 'package:flutter/material.dart'; // Flutter's material design package
import 'package:http/http.dart' as http; // HTTP package for making requests
import 'package:practical_user_api/model/user_model.dart'; // User model class

// Main class for HomeScreen widget, which is a StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// State class for HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  // List to store user data fetched from the API
  List<UsersModel> userList = [];

  // Function to fetch user data from the API
  Future<List<UsersModel>> getUsers() async {
    // Making a GET request to the API
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the response body into a list of maps
      var data = jsonDecode(response.body.toString());

      // Iterate through the list and add each user to userList
      for (Map i in data) {
        userList.add(UsersModel.fromJson(i));
      }
      // Return the populated userList
      return userList;
    } else {
      // If the request failed, return an empty list
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: const Text("User Api"),
        centerTitle: true,
      ),
      // Padding for the main content
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // Column to center the main content
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // FutureBuilder to handle asynchronous data fetching
          FutureBuilder(
              future: getUsers(),
              builder: (context, snapshot) {
                // Show a loading indicator while fetching data
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // Display the list of users once data is fetched
                  return Expanded(
                    child: ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          // Card to display each user's data
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // ReusableRow widget to display user details
                                  ReusableRow(
                                      title: 'Name',
                                      value: snapshot.data![index].name
                                          .toString()),
                                  ReusableRow(
                                      title: 'UserName',
                                      value: snapshot.data![index].username
                                          .toString()),
                                  ReusableRow(
                                      title: 'Email',
                                      value: snapshot.data![index].email
                                          .toString()),
                                  ReusableRow(
                                      title: 'Address',
                                      value: snapshot.data![index].address!.city
                                              .toString() +
                                          snapshot
                                              .data![index].address!.geo!.lat
                                              .toString()),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
              })
        ]),
      ),
    );
  }
}

// Custom widget to create a reusable row for displaying user details
class ReusableRow extends StatelessWidget {
  const ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  // Title and value for the row
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text widget for the title
          Text(title),
          // Text widget for the value
          Text(
            value,
          ),
        ],
      ),
    );
  }
}
