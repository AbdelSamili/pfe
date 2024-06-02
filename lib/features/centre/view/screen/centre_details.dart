import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pfe_1/features/centre/model/center_model.dart';
import 'package:pfe_1/features/centre/view/components/button.dart';
import 'package:pfe_1/features/centre/view/components/custom_appbar.dart';
import 'package:pfe_1/features/centre/view/screen/booking_page.dart';
import 'package:pfe_1/utils/Config.dart';

class CentreDetails extends StatefulWidget {
  const CentreDetails({super.key, required this.centre, required this.isFav});
  final CenterModel centre;
  final bool isFav;

  @override
  State<CentreDetails> createState() => _CentreDetailsState();
}

class _CentreDetailsState extends State<CentreDetails> {
  bool isFav = false;
  late CenterModel centre;

  @override
  void initState() {
    centre = widget.centre;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Centre Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AboutCentre(centre: centre),
            DetailBody(centre: centre),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                width: double.infinity,
                title: 'Book Appointment',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BookingPage(idCentre: widget.centre.id),
                    ),
                  );
                },
                disabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutCentre extends StatelessWidget {
  const AboutCentre({super.key, required this.centre});

  final CenterModel centre;

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: NetworkImage(centre.profileImage),
            backgroundColor: Colors.white,
          ),
          Config.spaceMedium,
          Text(
            centre.centerName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: Text(
              centre.email,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: Text(
              centre.phoneNumber,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({super.key, required this.centre});
  final CenterModel centre;

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.spaceSmall,
          CentreInfo(exp: 5, rating: centre.rating, creationDate: centre.creationDate),
          Config.spaceMedium,
          const Text(
            'About Centre',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Config.spaceSmall,
          Text(
            centre.description,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class CentreInfo extends StatelessWidget {
  const CentreInfo({super.key, required this.exp, required this.rating, required this.creationDate});

  final int exp;
  final double rating;
  final String creationDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Date de Creation',
          value: creationDate.split('T').first,
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Rating',
          value: rating.toStringAsFixed(1),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
