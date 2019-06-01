import 'package:flutter/material.dart';
import 'package:flutter_hack/src/widget/metrices_widget.dart';
import 'package:pie_chart/pie_chart.dart';

class MentorProfile extends StatefulWidget {
  @override
  MentorProfileState createState() {
    return MentorProfileState();
  }
}

class MentorProfileState extends State<MentorProfile> {
  Map<String, double> dataMap = new Map();
  @override
  void initState() {
    dataMap.putIfAbsent("Flutter", () => 75);
    dataMap.putIfAbsent("React Native", () => 46);
    dataMap.putIfAbsent("Xamarin", () => 20);
    dataMap.putIfAbsent("Java", () => 35);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue, title: Text("Prifile")),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://pbs.twimg.com/profile_images/864282616597405701/M-FEJMZ0_400x400.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: UserMetrics(title: "Following", value: 98),
                    flex: 1,
                  ),
                  Flexible(
                    child: UserMetrics(title: "Followers", value: 100),
                    flex: 1,
                  ),
                  Flexible(
                    child: UserMetrics(title: "Repos", value: 5),
                    flex: 1,
                  ),
                  Flexible(
                    child: UserMetrics(title: "Gists", value: 56),
                    flex: 1,
                  )
                ],
              ),
              SizedBox(height: 10.0),
              PieChart(dataMap: dataMap)
            ],
          ),
        ));
  }
}
