import 'package:flutter/material.dart';
import 'package:flutter_demo/models/phongban.dart';

class PhongBanView extends StatefulWidget {
  final PhongBan phongBan;
  final Function onTap;
  PhongBanView({Key? key, required this.phongBan, required this.onTap})
      : super(key: key);

  @override
  State<PhongBanView> createState() => _PhongBanViewState();
}

class _PhongBanViewState extends State<PhongBanView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor.withRed(180),
      margin: const EdgeInsets.only(bottom: 2.0, top: 2.0),
      elevation: 0,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6.0),
            Text(
              'Phòng: ${widget.phongBan.ten!}',
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
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Mô tả: ${widget.phongBan.mo_ta!}',
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Số phòng: ${widget.phongBan.so_phong}'),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text('Trưởng phòng:'),
                      if (widget.phongBan.name?.isNotEmpty ?? false)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: Color.fromARGB(255, 223, 231, 233)),
                          padding: const EdgeInsets.all(4.0),
                          child: Text('${widget.phongBan.name!}',
                              style: const TextStyle(
                                fontSize: 14.0,
                                // color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                              )),
                        ),
                    ],
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
