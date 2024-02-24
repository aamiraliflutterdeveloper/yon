import 'package:app/common/logger/log.dart';
import 'package:app/presentation/classified/classified_filers/classified_by_budget.dart';
import 'package:app/presentation/classified/classified_filers/classified_by_category.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/searchs/searchScreen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filtered_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassifiedFilterScreen extends StatefulWidget {
  final String? title;

  const ClassifiedFilterScreen({Key? key, this.title}) : super(key: key);

  @override
  State<ClassifiedFilterScreen> createState() => _ClassifiedFilterScreenState();
}

class _ClassifiedFilterScreenState extends State<ClassifiedFilterScreen> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'By Category'),
    const Tab(text: 'By Budget'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    d('CLASSIFIED TITLE : ${widget.title}');
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
    final ClassifiedViewModel classifiedViewModel = context.watch<ClassifiedViewModel>();
    List<String> list = classifiedViewModel.classifiedFilterMap!.values.toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomAppTheme().backgroundColor,
        elevation: 0.0,
        title: Text(
          'Filters',
          style: CustomAppTheme().headingText.copyWith(fontSize: 20, color: CustomAppTheme().blackColor),
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
              child: Icon(Icons.arrow_back_ios_rounded, size: 15, color: CustomAppTheme().blackColor),
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
                    ? const Text('No selected filter', style: TextStyle(color: Colors.black))
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
                                    if (list[index] == classifiedViewModel.classifiedFilterMap!['Category']) {
                                      d('Category : ${list[index]} == ${classifiedViewModel.classifiedFilterMap!['Category']}');
                                      classifiedViewModel.classifiedFilterData!.category = null;
                                    } else if (list[index] == classifiedViewModel.classifiedFilterMap!['SubCategory']) {
                                      d('SubCategory : ${list[index]} == ${classifiedViewModel.classifiedFilterMap!['SubCategory']}');
                                      classifiedViewModel.classifiedFilterData!.subCategory = null;
                                    } else if (list[index] == classifiedViewModel.classifiedFilterMap!['Brand']) {
                                      d('Brand : ${list[index]} == ${classifiedViewModel.classifiedFilterMap!['Brand']}');
                                      classifiedViewModel.classifiedFilterData!.brand = null;
                                    } else if (list[index] == classifiedViewModel.classifiedFilterMap!['Condition']) {
                                      d('Condition : ${list[index]} == ${classifiedViewModel.classifiedFilterMap!['Condition']}');
                                      classifiedViewModel.classifiedFilterData!.condition = null;
                                    } else if (list[index] == classifiedViewModel.classifiedFilterMap!['Currency']) {
                                      d('Currency : ${list[index]} == ${classifiedViewModel.classifiedFilterMap!['Currency']}');
                                      classifiedViewModel.classifiedFilterData!.currency = null;
                                    } else if (list[index] == classifiedViewModel.classifiedFilterMap!['Budget']) {
                                      d('Budget : ${list[index]} == ${classifiedViewModel.classifiedFilterMap!['Budget']}');
                                      classifiedViewModel.classifiedFilterData!.maxPrice = null;
                                      classifiedViewModel.classifiedFilterData!.minPrice = null;
                                    }
                                    classifiedViewModel.classifiedFilterMap!.removeWhere((key, value) => value == list[index]);
                                    classifiedViewModel.changeClassifiedFilterMap(classifiedViewModel.classifiedFilterMap!);
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
                  isScrollable: false,
                  physics: const NeverScrollableScrollPhysics(),
                  indicatorColor: CustomAppTheme().primaryColor,
                  labelColor: CustomAppTheme().blackColor,
                  unselectedLabelColor: CustomAppTheme().greyColor,
                  labelStyle: CustomAppTheme().normalText.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                  automaticIndicatorColorAdjustment: true,
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(med.height * 0.1),
        ),
      ),
      body: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: _tabController, children: const <Widget>[
        ClassifiedByCategory(),
        ClassifiedByBudget(),
      ]),
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
                classifiedViewModel.classifiedFilterData = ClassifiedFilterModel();
                classifiedViewModel.classifiedFilterMap = {};
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(
                      isFilter: true,
                      module: 'Classified',
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
                  border: Border.all(color: CustomAppTheme().primaryColor, width: 1.5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      'Clear Filters',
                      style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.title != null) {
                  classifiedViewModel.classifiedFilterData!.title = widget.title;
                }
                classifiedViewModel.classifiedFilterData!.page = 1;
                print(classifiedViewModel.classifiedFilterData!.page);
                print("=============================");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(
                      isFilter: true,
                      module: 'Classified',
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
                  border: Border.all(color: CustomAppTheme().primaryColor, width: 1.5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      'Apply Filters',
                      style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor, fontSize: 14, fontWeight: FontWeight.w600),
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
