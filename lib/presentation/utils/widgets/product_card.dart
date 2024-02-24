import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductCard extends StatefulWidget {
  final bool? isFeatured;
  final bool? isFav;
  final bool? isVerified;
  final bool? isOff;
  final String? categories;
  final String? logo;
  final String? imageUrl;
  final String? title;
  final String? address;
  final String? price;
  final String? currencyCode;
  final VoidCallback? onFavTap;
  final String? beds;
  final String? baths;
  final String? baths1;

  const ProductCard({
    Key? key,
    this.isFeatured = false,
    this.isOff = false,
    this.imageUrl =
        'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg',
    this.title = '',
    this.address = '',
    this.price = '',
    this.baths = '',
    this.logo,
    this.categories = '',
    this.beds = '',
    this.baths1 = '',
    this.currencyCode = '',
    this.isFav = false,
    this.isVerified = false,
    this.onFavTap,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    String imageUrl;
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      imageUrl =
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
    } else {
      imageUrl = widget.imageUrl!;
    }
    return Container(
      // height: med.height * 0.32,
      width: med.width * 0.45,
      margin:
          EdgeInsets.only(bottom: med.height * 0.005, right: med.width * 0.005),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomAppTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0.2,
            blurRadius: 1,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: med.height * 0.16,
                    width: med.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        widget.isFeatured!
                            ? Container(
                                height: med.height * 0.022,
                                // width: med.width*0.18,
                                decoration: BoxDecoration(
                                  color: CustomAppTheme().secondaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: CustomAppTheme().backgroundColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Center(
                                          child: Text(
                                            'Featured',
                                            style: CustomAppTheme()
                                                .normalText
                                                .copyWith(
                                                    fontSize: 10,
                                                    color: CustomAppTheme()
                                                        .backgroundColor),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.isFeatured!
                            ? SizedBox(
                                width: med.width * 0.01,
                              )
                            : const SizedBox.shrink(),
                        //10% OFF BOX
                        /*widget.isOff!
                           ? Container(
                               height: med.height * 0.022,
                               // width: med.width*0.18,
                               decoration: BoxDecoration(
                                 color: CustomAppTheme().secondaryColor,
                                 borderRadius: BorderRadius.circular(4),
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                 child: Center(
                                   child: Text(
                                     '10% off',
                                     style: CustomAppTheme().normalText.copyWith(fontSize: 10, color: CustomAppTheme().backgroundColor),
                                   ),
                                 ),
                               ),
                             )
                           : const SizedBox.shrink(),
                       widget.isOff!
                           ? SizedBox(
                               width: med.width * 0.01,
                             )
                           : const SizedBox.shrink(),*/
                        widget.isOff!
                            ? Container(
                                height: med.height * 0.022,
                                // width: med.width*0.18,
                                decoration: BoxDecoration(
                                  color: const Color(0xfffe2e2e),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Center(
                                    child: Text(
                                      'For Sale',
                                      style: CustomAppTheme()
                                          .normalText
                                          .copyWith(
                                              fontSize: 10,
                                              color: CustomAppTheme()
                                                  .backgroundColor),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                child: Column(
                  children: <Widget>[
                    //Verified widget
                    widget.isVerified!
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: med.width * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      const Color(0xffFFF0D2), // Colors.white
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.verified_outlined,
                                        color:
                                            Color(0xff653700) /*Colors.white*/,
                                        size: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                          'Verified',
                                          style: CustomAppTheme()
                                              .normalText
                                              .copyWith(
                                                  color: const Color(
                                                      0xff653700) /*Colors
                                                      .white*/
                                                  ,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: med.width * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      Colors.white /*const Color(0xffFFF0D2)*/,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.verified_outlined,
                                        color:
                                            Colors.white /*Color(0xff653700)*/,
                                        size: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                          'Verified',
                                          style: CustomAppTheme()
                                              .normalText
                                              .copyWith(
                                                  color: Colors
                                                      .white /*const Color(0xff653700)*/,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                    SizedBox(
                      height: med.height * 0.01,
                    ),

                    //Title and fav
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: med.width * 0.33,
                          child: Text(
                            widget.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CustomAppTheme().normalText.copyWith(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: widget.onFavTap ?? () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xffe6fff9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                  widget.isFav == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: CustomAppTheme().primaryColor,
                                  size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on_rounded,
                            color: CustomAppTheme().primaryColor,
                            size: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: SizedBox(
                              width: med.width * 0.37,
                              child: Text(
                                widget.address!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomAppTheme()
                                    .normalText
                                    .copyWith(fontSize: 9),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: med.height * 0.015,
                    ),

                    Row(
                      children: <Widget>[
                        Text(
                          '${widget.currencyCode} ${widget.price}',
                          style: CustomAppTheme().normalText.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: CustomAppTheme().primaryColor),
                        ),

                        /*widget.isOff!
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '${widget.currencyCode} 56',
                                  style: CustomAppTheme().normalText.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                              )
                            : const SizedBox.shrink(),*/

                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white /*const Color(0xffe6fff9)*/,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(Icons.location_on_rounded,
                                color: Colors
                                    .white /*CustomAppTheme().primaryColor*/,
                                size: 14),
                          ),
                        ),

                        //View on map
                        /*Container(
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(4),
                                         color: const Color(0xffe6fff9),
                                         border: Border.all(color: CustomAppTheme().primaryColor),
                                       ),
                                       child: Padding(
                                         padding: const EdgeInsets.all(2.0),
                                         child: Row(
                                           children: <Widget>[
                                             Icon(Icons.location_on_rounded, size: 12, color: CustomAppTheme().primaryColor,),
                                             Text('View on Map',
                                               style: CustomAppTheme().normalText.copyWith(fontSize: 8, color: CustomAppTheme().primaryColor),
                                             )
                                           ],
                                         ),
                                       ),
                                     ),
*/
                      ],
                    ),

                    SizedBox(
                      height: med.height * 0.008,
                    ),

                    const Divider(
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: widget.categories == "auto"
                            ? [
                                propertyFeatureWidget(
                                    svgUrl: 'assets/svgs/milage.svg',
                                    type: widget.beds ?? 'Beds'),
                                propertyFeatureWidget(
                                    svgUrl: 'assets/svgs/transmission.svg',
                                    type: widget.baths ?? ''),
                                // propertyFeatureWidget(
                                //     svgUrl: 'assets/svgs/engine.svg',
                                //     type: widget.baths ?? ''),
                              ]
                            : <Widget>[
                                propertyFeatureWidget(
                                    svgUrl: widget.categories == "property"
                                        ? 'assets/svgs/bedIcon.svg'
                                        : 'assets/svgs/typeIcon.svg',
                                    type: widget.beds ?? ''),
                                propertyFeatureWidget(
                                    svgUrl: widget.categories == "property"
                                        ? 'assets/svgs/sqftIcon.svg'
                                        : 'assets/svgs/conditionIcon.svg',
                                    type: widget.baths ?? ''),
                                // propertyFeatureWidget(
                                //     svgUrl: 'assets/svgs/sqftIcon.svg',
                                //     type: 'sqft',
                                //     isEmpty: true),
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: med.height * 0.135,
              ),
              Container(
                height: med.height * 0.05,
                width: med.width * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: CustomAppTheme().backgroundColor, width: 2.0),
                  image: widget.logo != null
                      ? DecorationImage(
                          image: NetworkImage(
                            widget.logo!,
                          ),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('assets/images/userIconImage.png'),
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget propertyFeatureWidget({required String svgUrl, required String type}) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          svgUrl,
          height: MediaQuery.of(context).size.height * 0.012,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            type,
            style: CustomAppTheme().normalText.copyWith(fontSize: 8),
          ),
        ),
      ],
    );
  }
}
