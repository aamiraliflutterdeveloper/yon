import 'package:app/common/logger/log.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_by_brands.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_by_budget.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_by_fuel.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_by_km_driven.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_by_transmission.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_by_year.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/searchs/searchScreen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filtered_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutomotiveFiltersScreen extends StatefulWidget {
  const AutomotiveFiltersScreen({Key? key}) : super(key: key);

  @override
  State<AutomotiveFiltersScreen> createState() =>
      _AutomotiveFiltersScreenState();
}

class _AutomotiveFiltersScreenState extends State<AutomotiveFiltersScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'By Brand/Model'),
    const Tab(text: 'By Budget'),
    const Tab(text: 'By Year'),
    const Tab(text: 'By KM Driven'),
    const Tab(text: 'By Fuel'),
    const Tab(text: 'By Transmission')
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    List<String> list =
        automotiveViewModel.automotiveFilterMap!.values.toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomAppTheme().backgroundColor,
        elevation: 0.0,
        title: Text(
          'Filters',
          style: CustomAppTheme()
              .headingText
              .copyWith(fontSize: 20, color: CustomAppTheme().blackColor),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: CustomAppTheme().backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.3,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_rounded,
                  size: 15, color: CustomAppTheme().blackColor),
            ),
          ),
        ),
        bottom: PreferredSize(
          child: SizedBox(
            height: med.height * 0.12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                list.isEmpty
                    ? Container()
                    // const Text('No selected filter', style: TextStyle(color: Colors.black))
                    : SizedBox(
                        height: med.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                            itemCount: list.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: FilterChipWidget(
                                  onDeleteTap: () {
                                    if (list[index] ==
                                        automotiveViewModel
                                            .automotiveFilterMap!['Brand']) {
                                      d('Brand : ${list[index]} == ${automotiveViewModel.automotiveFilterMap!['Brand']}');
                                      automotiveViewModel
                                          .automotiveFilterData!.brandId = null;
                                    } else if (list[index] ==
                                        automotiveViewModel
                                            .automotiveFilterMap!['Currency']) {
                                      d('Currency : ${list[index]} == ${automotiveViewModel.automotiveFilterMap!['Currency']}');
                                      automotiveViewModel.automotiveFilterData!
                                          .currency = null;
                                    } else if (list[index] ==
                                        automotiveViewModel
                                            .automotiveFilterMap!['Budget']) {
                                      d('Budget : ${list[index]} == ${automotiveViewModel.automotiveFilterMap!['Budget']}');
                                      automotiveViewModel.automotiveFilterData!
                                          .minPrice = null;
                                      automotiveViewModel.automotiveFilterData!
                                          .maxPrice = null;
                                    } else if (list[index] ==
                                        automotiveViewModel
                                            .automotiveFilterMap!['Year']) {
                                      d('Year : ${list[index]} == ${automotiveViewModel.automotiveFilterMap!['Year']}');
                                      automotiveViewModel.automotiveFilterData!
                                          .yearLimit = null;
                                    } else if (list[index] ==
                                        automotiveViewModel
                                            .automotiveFilterMap!['Driven']) {
                                      d('Driven : ${list[index]} == ${automotiveViewModel.automotiveFilterMap!['Driven']}');
                                      automotiveViewModel
                                          .automotiveFilterData!.maxKm = null;
                                      automotiveViewModel
                                          .automotiveFilterData!.minKm = null;
                                    } else if (list[index] ==
                                        automotiveViewModel
                                            .automotiveFilterMap!['Fuel']) {
                                      d('Fuel : ${list[index]} == ${automotiveViewModel.automotiveFilterMap!['Fuel']}');
                                      automotiveViewModel.automotiveFilterData!
                                          .fuelType = null;
                                    } else if (list[index] ==
                                        automotiveViewModel
                                                .automotiveFilterMap![
                                            'Transmission']) {
                                      d('Transmission : ${list[index]} == ${automotiveViewModel.automotiveFilterMap!['Transmission']}');
                                      automotiveViewModel.automotiveFilterData!
                                          .transmissionType = null;
                                    }
                                    automotiveViewModel.automotiveFilterMap!
                                        .removeWhere((key, value) =>
                                            value == list[index]);
                                    automotiveViewModel.changeAutoFilterMap(
                                        automotiveViewModel
                                            .automotiveFilterMap!);
                                  },
                                  filteredText: list[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                TabBar(
                  controller: _tabController,
                  tabs: myTabs,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 2,
                  isScrollable: true,
                  indicatorColor: CustomAppTheme().primaryColor,
                  labelColor: CustomAppTheme().blackColor,
                  unselectedLabelColor: CustomAppTheme().greyColor,
                  labelStyle: CustomAppTheme()
                      .normalText
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                  automaticIndicatorColorAdjustment: true,
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(med.height * 0.1),
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const <Widget>[
          AutomotiveByBrands(),
          AutomotiveByBudget(),
          PropertiesByYear(),
          PropertiesByKMDriven(),
          AutomotiveByFuel(),
          AutomotiveByTransmission(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: med.height * 0.07,
        width: med.width,
        decoration: BoxDecoration(
          color: CustomAppTheme().backgroundColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: const Offset(3, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                automotiveViewModel.automotiveFilterData =
                    AutomotiveFilterModel();
                automotiveViewModel.automotiveFilterMap = {};
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(
                      isFilter: true,
                      module: 'Automotive',
                    ),
                  ),
                );
              },
              child: Container(
                height: med.height * 0.045,
                width: med.width * 0.4,
                decoration: BoxDecoration(
                  color: CustomAppTheme().backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: CustomAppTheme().primaryColor, width: 1.5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      'Clear Filters',
                      style: CustomAppTheme().normalText.copyWith(
                          color: CustomAppTheme().primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                automotiveViewModel
                    .automotiveFilterData!.page = 1;
                setState(() {

                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(
                      isFilter: true,
                      module: 'Automotive',
                    ),
                  ),
                );
              },
              child: Container(
                height: med.height * 0.045,
                width: med.width * 0.4,
                decoration: BoxDecoration(
                  color: CustomAppTheme().primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: CustomAppTheme().primaryColor, width: 1.5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      'Apply Filters',
                      style: CustomAppTheme().normalText.copyWith(
                          color: CustomAppTheme().backgroundColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
