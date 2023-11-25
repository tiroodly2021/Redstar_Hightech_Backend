import 'package:flutter/material.dart';

class AppSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Center(
        child: Container(
          child: const Text("Search handle: Not implemented yet"),
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Center(
      child: Container(
        child: const Text("Search handle: Not implemented yet"),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        child: const Text("Search handle: Not implemented yet"),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Container(
        child: const Text("Search handle: Not implemented yet"),
      ),
    );
  }
}
