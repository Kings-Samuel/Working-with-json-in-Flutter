import 'package:flutter/material.dart';
import 'package:local_json/users_api.dart';
import 'user_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Load data from json'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                DropdownSearch<UserModel>(
                  popupProps: PopupProps.modalBottomSheet(
                    fit: FlexFit.tight,
                    title: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(
                          'Select user',
                          style: TextStyle(fontSize: 14),
                        )),
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      showCursor: true,
                      cursorHeight: 25,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        labelText: 'Search',
                        constraints: const BoxConstraints(
                          maxHeight: 40,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black54,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    favoriteItemProps: const FavoriteItemProps(showFavoriteItems: true),
                    modalBottomSheetProps: const ModalBottomSheetProps(clipBehavior: Clip.antiAliasWithSaveLayer),
                    emptyBuilder: (BuildContext context, String searchText) {
                      return const Center(
                        child: Text('No data found'),
                      );
                    },
                    errorBuilder: (BuildContext context, String result, dynamic error) {
                      return Center(child: Text(error.toString()));
                    },
                    loadingBuilder: (BuildContext context, String result) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    itemBuilder: (BuildContext context, UserModel user, bool isSelected) {
                      return Container(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                            left: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(user.imageUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(user.username!),
                            ],
                          ));
                    },
                  ),
                  onChanged: (userModel) {
                    debugPrint('Select user: ${userModel!.username}');
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10),
                      hintText: 'Search',
                      constraints: const BoxConstraints(
                        maxHeight: 40,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black54,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  asyncItems: (String filter) => UsersAPI.getUsersLocally(context),
                  itemAsString: (UserModel data) => data.username!,
                  dropdownButtonProps: const DropdownButtonProps(icon: Icon(Icons.search)),
                  dropdownBuilder: (context, user) {
                    return const Text('Search');
                  },
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: UsersAPI.getUsersLocally(context),
                  builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final users = snapshot.data;
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: users!.length,
                        separatorBuilder: (_, __) => const Divider(
                          color: Colors.black54,
                          thickness: 0.5,
                        ),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            title: Text(user.username!),
                            subtitle: Text(user.email!),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.imageUrl!),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
