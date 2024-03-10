import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_contacts_app/screens/contacts/bloc/contact_cubit.dart';
import 'package:ivy_contacts_app/screens/contacts/views/add_contact.dart';
import 'package:ivy_contacts_app/screens/contacts/views/edit_contact.dart';
import 'package:ivy_contacts_app/screens/contacts/views/view_contact.dart';
import 'package:ivy_contacts_app/utils/app_functions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/contact_model.dart';
import '../../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<ContactCubit>().initialiseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.loadState == LoadState.initial ||
            state.loadState == LoadState.loading) {
          return _loadingwidget(size);
        } else if (state.loadState == LoadState.errorLoading) {
          return _erroWidget(size);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              'My Contacts',
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigatePush(context, AddContact());
            },
            backgroundColor: const Color(0xFF29AB87),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 34,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () {
              return context.read<ContactCubit>().initialiseList();
            },
            color: tropicalRainforestGreen,
            child: Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 60),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: state.listContactModel.length,
                      itemBuilder: (ctx, index) {
                        ContactModel cm = state.listContactModel[index];
                        return ListTile(
                          onTap: () {
                            navigatePush(context,
                                EditContact(contactModel: cm, index: index));
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              height: 45,
                              width: 45,
                              child: Icon(
                                Icons.ac_unit,
                                size: 35,
                                color: jungleGreen,
                              ),
                            ),
                          ),
                          title: Text(
                            cm.name,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '+91 ${cm.contactNo}',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              /// MAKE THE CALL
                              final call = Uri.parse('tel:+91 ${cm.contactNo}');
                              if (await canLaunchUrl(call)) {
                                launchUrl(call);
                              } else {
                                throw 'Could not launch $call';
                              }
                            },
                            icon: const Icon(
                              Icons.phone,
                              color: Color(0xFF00755E),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loadingwidget(Size size) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'My Contacts',
          style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (ctx) => const EventsListSearchPage()),
              // );
            },
            icon: const Icon(
              Icons.search,
              size: 28,
              color: CupertinoColors.black,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (ctx, index) {
          double blurRadius = 2.5;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CupertinoColors.white,
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.white,
                  blurRadius: blurRadius,
                  spreadRadius: 0.5,
                  offset: Offset(blurRadius, blurRadius),
                ),
                BoxShadow(
                  color: CupertinoColors.systemGrey6,
                  blurRadius: blurRadius,
                  spreadRadius: 2.5,
                  offset: Offset(blurRadius, blurRadius),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 100,
                  width: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CupertinoColors.systemGrey4,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 16,
                          width: (size.width - 140),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemGrey3,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 18,
                          width: (size.width - 140) * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemGrey2,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemGrey4,
                          ),
                          height: 18,
                          width: (size.width - 140),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemGrey4,
                          ),
                          height: 18,
                          width: (size.width - 140) * 0.4,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _erroWidget(Size size) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'My Contacts',
          style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return context.read<ContactCubit>().initialiseList();
        },
        color: tropicalRainforestGreen,
        child: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            shrinkWrap: false,
            children: [
              SizedBox(height: size.height * 0.3),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: CupertinoColors.systemRed,
                    size: 48,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Error Loading Events, ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: CupertinoColors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Check Your Internet Connection and Try Again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: CupertinoColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
