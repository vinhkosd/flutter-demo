import 'package:flutter/material.dart';
import 'package:flutter_demo/models/account.dart';
import 'package:provider/provider.dart';

import '../../controller/PhongBanListController.dart';

class AccountView extends StatefulWidget {
  final Account account;
  final Function onTap;
  const AccountView({Key? key, required this.account, required this.onTap})
      : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 140, 231, 227),
      margin: const EdgeInsets.only(bottom: 2.0, top: 2.0),
      elevation: 0,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.account.imageurl.toString()),
              onBackgroundImageError: (_, __) {},
            ),
            const SizedBox(height: 6.0),
            Text(
              'Họ và tên: ${widget.account.name!}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
            ),
            const SizedBox(
              height: 6.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: const Color.fromARGB(255, 117, 117, 117)),
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Tài khoản: ${widget.account.username!}',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: const Color.fromARGB(255, 117, 117, 117)),
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Phòng ban: ${context.read<PhongBanListController>().loadNameById(widget.account.phongban_id) ?? 'Không thuộc phòng ban'}',
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: const Color.fromARGB(255, 117, 117, 117)),
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Chức vụ: ${widget.account.getRoleName()}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6.0,
            ),
            const SizedBox(height: 6.0),
          ],
        ),
        onTap: () async {
          widget.onTap();
        },
      ),
    );
  }
}
