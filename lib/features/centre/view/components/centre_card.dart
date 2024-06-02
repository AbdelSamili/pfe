import 'package:flutter/material.dart';
import 'package:pfe_1/features/centre/model/center_model.dart';
import 'package:pfe_1/features/centre/view/screen/centre_details.dart';
import 'package:pfe_1/utils/Config.dart';

class CentreCard extends StatelessWidget {
  const CentreCard({
    super.key,
    required this.centre,
    required this.isFav,
  });

  final bool isFav;
  final CenterModel centre;

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                height: Config.heightSize * 0.2,
                child: Image.network(
                  centre.profileImage,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        centre.centerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        centre.matricule,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(centre.rating.toStringAsFixed(1)),
                          const SizedBox(width: 5),
                          Text('Reviews'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CentreDetails(
                centre: centre,
                isFav: isFav,
              ),
            ),
          );
        },
      ),
    );
  }
}
