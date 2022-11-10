import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

const primaryColor =
    Color.fromARGB(255, 0, 85, 85); //rgb(247, 233, 215)/rgb(235, 216, 195)
const secondaryColor = Color.fromARGB(255, 161, 227, 216); //rgb(255, 246, 234)
const bgColor =
    Color.fromARGB(255, 6, 154, 142); //rgb(247, 255, 147)rgb(161, 227, 216)

const defaultPadding = 8.0;

class Header extends StatelessWidget {
  const Header({
    Key key,
    this.rightIcon,
    this.backIcon,
  }) : super(key: key);

  final Widget rightIcon;
  final bool backIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (backIcon != null && backIcon)
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Text("Quản lý nhân sự"),
          ),
        ),
        // ProfileCard()
        if (rightIcon != null) rightIcon,
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Color.fromARGB(135, 104, 104, 104)),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 18,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Lê Quang Vinh"),
            ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
