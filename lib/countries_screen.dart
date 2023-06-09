// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:covid_tracker_app/details_screen.dart';
import 'package:covid_tracker_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ApiServices countryApiServices = ApiServices();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Country',
                  hintStyle: const TextStyle(
                    letterSpacing: 1.8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: countryApiServices.getCountryApi(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade700,
                      highlightColor: Colors.grey.shade100,
                      child: Column(
                        children: [
                          ListTile(
                            title: Container(
                              height: 10,
                              width: 90,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              height: 10,
                              width: 90,
                              color: Colors.white,
                            ),
                            leading: Container(
                              height: 20,
                              width: 90,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    String name = snapshot.data![index]['country'];

                    if (searchController.text.isEmpty) {
                      return Card(
                        elevation: 15.0,
                        margin: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                        name: snapshot.data![index]['country'],
                                        continent: snapshot.data![index]
                                            ['continent'],
                                        // oneCasePerPeople: snapshot.data![index]
                                        //     ['oneCasePerPeople'],
                                        // oneTestPerPeople: snapshot.data![index]
                                        //     ['oneTestPerPeople'],
                                        // oneDeathPerPeople: snapshot.data![index]
                                        //     ['oneDeathPerPeople'],
                                        // activePerOneMillion:
                                        //     snapshot.data![index]
                                        //         ['activePerOneMillion'],
                                      ),
                                    ));
                              },
                              child: ListTile(
                                title: Text(snapshot.data![index]['country']),
                                subtitle: Row(
                                  children: [
                                    const Text('Cases : '),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(snapshot.data![index]['cases']
                                        .toString()),
                                  ],
                                ),
                                leading: Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage(snapshot.data![index]
                                        ['countryInfo']['flag'])),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return Card(
                        elevation: 15.0,
                        margin: const EdgeInsets.all(15.0),
                        child: ListTile(
                          title: Text(snapshot.data![index]['country']),
                          subtitle: Row(
                            children: [
                              const Text('Cases : '),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(snapshot.data![index]['cases'].toString()),
                            ],
                          ),
                          leading: Image(
                              height: 50,
                              width: 50,
                              image: NetworkImage(snapshot.data![index]
                                  ['countryInfo']['flag'])),
                        ),
                      );
                    } else {
                      Container();
                    }
                  },
                );
              }
            },
          ))
        ],
      )),
    );
  }
}
