import 'package:app/common/logger/log.dart';
import 'package:app/presentation/properties/property_filters/properties_by_area.dart';
import 'package:app/presentation/properties/property_filters/property_by_area_unit.dart';
import 'package:app/presentation/properties/property_filters/property_by_bathroom.dart';
import 'package:app/presentation/properties/property_filters/property_by_bedroom.dart';
import 'package:app/presentation/properties/property_filters/property_by_budget.dart';
import 'package:app/presentation/properties/property_filters/property_by_furnished.dart';
import 'package:app/presentation/properties/property_filters/property_by_type.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/searchs/searchScreen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filtered_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertyFiltersScreen extends StatefulWidget {
  const PropertyFiltersScreen({Key? key}) : super(key: key);

  @override
  State<PropertyFiltersScreen> createState() => _PropertyFiltersScreenState();
}

class _PropertyFiltersScreenState extends State<PropertyFiltersScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'By Type'),
    const Tab(text: 'By Budget'),
    const Tab(text: 'By Area Unit'),
    const Tab(text: 'By Area'),
    const Tab(text: 'By Bedroom'),
    const Tab(text: 'By Bathroom'),
    const Tab(text: 'By Furnished'),
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
    final PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
    List<String> list = propertiesViewModel.propertyFilterMap!.values.toList();
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
                                        propertiesViewModel
                                            .propertyFilterMap!['Type']) {
                                      d('Type : ${list[index]} == ${propertiesViewModel.propertyFilterMap!['Type']}');
                                      propertiesViewModel
                                              .propertyFilterData!.type ==
                                          null;
                                    } else if (list[index] ==
                                        propertiesViewModel
                                            .propertyFilterMap!['Currency']) {
                                      d('Currency : ${list[index]} == ${propertiesViewModel.propertyFilterMap!['Currency']}');
                                      propertiesViewModel
                                              .propertyFilterData!.currency ==
                                          null;
                                    } else if (list[index] ==
                                        propertiesViewModel
                                            .propertyFilterMap!['Budget']) {
                                      d('Budget : ${list[index]} == ${propertiesViewModel.propertyFilterMap!['Budget']}');
                                      propertiesViewModel
                                              .propertyFilterData!.maxPrice ==
                                          null;
                                      propertiesViewModel
                                              .propertyFilterData!.minPrice ==
                                          null;
                                    } else if (list[index] ==
                                        propertiesViewModel
                                            .propertyFilterMap!['AreaUnit']) {
                                      d('AreaUnit : ${list[index]} == ${propertiesViewModel.propertyFilterMap!['AreaUnit']}');
                                      propertiesViewModel
                                              .propertyFilterData!.areaUnit ==
                                          null;
                                    }
                                    propertiesViewModel.propertyFilterMap!
                                        .removeWhere((key, value) =>
                                            value == list[index]);
                                    propertiesViewModel.changePropertyFilterMap(
                                        propertiesViewModel.propertyFilterMap!);
                                    setState(() {});
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
          PropertyByType(),
          PropertiesByBudget(),
          PropertyByAreaUnit(),
          PropertiesByArea(),
          PropertyByBedroom(),
          PropertyByBathroom(),
          PropertyByFurnished(),
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
                propertiesViewModel.propertyFilterData = PropertyFilterModel();
                propertiesViewModel.propertyFilterMap = {};
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(
                      isFilter: true,
                      module: 'Property',
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
                propertiesViewModel
                    .propertyFilterData!.page = 1;
                setState(() {});
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(
                      isFilter: true,
                      module: 'Property',
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
