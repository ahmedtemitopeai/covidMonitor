import 'package:covid19_tracker/change_countries.dart';
import 'package:covid19_tracker/covid_data.dart';
import 'package:covid19_tracker/reusable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19_tracker/report_container.dart';
import 'package:covid19_tracker/constants.dart';
import 'package:covid19_tracker/reusable_container.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:covid19_tracker/country_data.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final dynamic covidData;
  final dynamic locationData;
  final dynamic countryData;
  final double lat;
  final double lng;
  final Placemark place;

  HomePage(
      {this.covidData,
      this.lat,
      this.lng,
      this.locationData,
      this.countryData,
      this.place});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CovidModel covid = CovidModel();
  CountryFlag cf = CountryFlag();

  String countryFlag = '';
  var countryData, newsData;
  int totalResults = 0;

  ProgressDialog pr;
  bool _saving = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String totalCases = '0',
      newCases = '0',
      totalDeaths = '0',
      newDeaths = '0',
      totalRecovered = '0',
      activeCases = '0',
      criticalCases = '0';

  var lastUpdated;

  void updateUI(dynamic covidData) {
    setState(() {
      _saving = true;
      if (covidData == null) {
        totalCases = '0';
        newCases = '0';
        totalDeaths = '0';
        newDeaths = '0';
        totalRecovered = '0';
        return;
      }
      totalCases = covidData['total_cases'];
      newCases = covidData['new_cases'];
      totalDeaths = covidData['total_deaths'];
      newDeaths = covidData['new_deaths'];
      totalRecovered = covidData['total_recovered'];
      activeCases = covidData['active_cases'];
      criticalCases = covidData['serious_critical'];
      lastUpdated = DateTime.parse(covidData['statistic_taken_at']);
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    var covidData = await covid.getCovidData();
    updateUI(covidData);
    getCountryLocalityName();
    countryDataCovid();
    getCovidNewsData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      // updateUI(widget.covidData);
      getCovidNewsData();
    });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    // Update Covid Data by the widget.covidData from the loading screen
    updateUI(widget.covidData);
    getCountryLocalityName();
    countryDataCovid();
    getCovidNewsData();
  }

  String countryName, cityName, isoCode, ctryName;

  // Function to get the Country Name and City Name
  void getCountryLocalityName() {
    Placemark latLngData = widget.place;
    updateLocation(latLngData);
  }

  void updateLocation(dynamic latLngData) {
    setState(() {
      _saving = true;
      countryName = latLngData.country;
      cityName = latLngData.locality;
      isoCode = latLngData.isoCountryCode;
      print(countryName);
      print(cityName);
      print(isoCode);
    });
  }

  String newsTitle, newsContent;

  void getCovidNewsData() async {
    try {
      newsData = await covid.getNewsData(isoCode.toLowerCase());
      print(newsData);
      print('News Data $newsData');
    } catch (e) {
      print(e);
    }

    setState(() {
      if (newsData['totalResults'] != null)
        totalResults = newsData['totalResults'];
    });
  }

  // Function to get the Country Covid API data
  void countryDataCovid() async {
    ctryName = countryName;
    try {
      if (countryName.toLowerCase() == 'united states of america' ||
          countryName.toLowerCase() == 'united states') {
        ctryName = 'usa';
      } else if (countryName.toLowerCase() == 'united kingdom') {
        ctryName = 'uk';
      } else if (countryName.toLowerCase() == 'united arab emirates') {
        ctryName = 'uae';
      } else if (countryName.toLowerCase() == 'côte d\'ivoire') {
        ctryName = 'ivory coast';
      } else if (countryName.toLowerCase() == 'south korea') {
        ctryName = 's. korea';
      } else if (countryName.toLowerCase() == 'democratic republic of congo') {
        ctryName = 'drc';
      }

      countryData = await covid.getCountryData(ctryName);
    } catch (e) {
      print(e);
    }
    updateCountry(countryData);
  }

  // Update Covid API data
  String countryTotalCases = '0',
      countryNewCases = '0',
      countryTotalDeaths = '0',
      countryNewDeaths = '0',
      countryTotalRecovered = '0';
  var countryLastUpdated;

  void updateCountry(dynamic countryData) {
    if (ctryName.toLowerCase() ==
        countryData['country'].toString().toLowerCase()) {
      setState(
        () {
          _saving = false;
          if (countryData == null) {
            countryTotalCases = '0';
            countryNewCases = '0';
            countryTotalDeaths = '0';
            countryNewDeaths = '0';
            countryTotalRecovered = '0';
            return;
          }

          try {
            countryTotalCases = countryData["latest_stat_by_country"][0]
                    ['total_cases']
                .toString();
            countryNewCases = countryData["latest_stat_by_country"][0]
                    ['new_cases']
                .toString();
            countryTotalDeaths = countryData["latest_stat_by_country"][0]
                    ['total_deaths']
                .toString();
            countryNewDeaths = countryData["latest_stat_by_country"][0]
                    ['new_deaths']
                .toString();
            countryTotalRecovered = countryData["latest_stat_by_country"][0]
                    ['total_recovered']
                .toString();
            // activeCases = countryData[0]['active_cases'];
            // criticalCases = countryData[0]['serious_critical'];
            countryLastUpdated = DateTime.parse(
                countryData["latest_stat_by_country"][0]['record_date']);

            if (countryTotalCases == '') {
              countryTotalCases = '0';
            }
            if (countryNewCases == '') {
              countryNewCases = '0';
            }
            if (countryTotalDeaths == '') {
              countryTotalDeaths = '0';
            }
            if (countryTotalRecovered == '') {
              countryTotalRecovered = '0';
            }
            if (countryNewDeaths == '') {
              countryNewDeaths = '0';
            }
          } catch (e) {
            print(e);
          }

          for (String cflg in cf.countries.keys) {
            if (cflg.toLowerCase() == countryName.toLowerCase()) {
              countryFlag = cf.countries[cflg];
            }
          }
        },
      );
    }
  }

  void loading() async {
    await pr.show();
  }

  void stopLoading() async {
    await pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    // getCovidNewsData();
    pr = new ProgressDialog(context);

    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1C1E1F),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text('Covid-19'),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text('Preventions'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Symptoms'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Popular Questions'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Covid App Tracker'),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        progressIndicator: CircularProgressIndicator(),
        color: Colors.black,
        opacity: .9,
        isLoading: _saving,
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text('Pull up load');
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text('Load Failed: Retry');
              } else if (mode == LoadStatus.canLoading) {
                body = Text('release to load more');
              } else {
                body = Text('No more data');
              }
              return Container(
                height: 55.0,
                child: Center(
                  child: body,
                ),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Report Container
                  ReportContainer(
                    onTap: () {
                      print('Report section Tapped');
                    },
                    reportTextTitle: 'Report your COVID-19 health status',
                    reportTextContent:
                        'Take 1 min everyday to report your health status and help us map the spread of corona virus to prevail faster',
                  ),
                  kSizedBox,
                  // Corona Virus Global
                  ReusableContainer(
                      containerTitle: 'Coronavirus Global',
                      totalCases: totalCases,
                      newCases: newCases,
                      totalDeaths: totalDeaths,
                      newDeaths: newDeaths,
                      totalRecovered: totalRecovered,
                      lastUpdated: lastUpdated),
                  kSizedBox,
                  ReusableContainer(
                    countryImage: Text(
                      countryFlag,
                    ),
                    containerTitle: "$countryName" ?? "",
                    totalCases: countryTotalCases,
                    newCases: countryNewCases,
                    totalDeaths: countryTotalDeaths,
                    newDeaths: countryNewDeaths,
                    totalRecovered: countryTotalRecovered,
                    lastUpdated: lastUpdated,
                    countriesDropdown: GestureDetector(
                      onTap: () async {
                        countryName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CountryChange(
                              cNamee: countryName,
                            ),
                          ),
                        );
                        if (countryName != null) {
                          countryDataCovid();
                        }
                      },
                      child: ReusableText(
                        text: 'change',
                        colour: Colors.blueAccent,
                      ),
                    ),
                  ),
                  kSizedBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Latest News',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 22.0),
                      ),
                      kSizedBox,
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: totalResults,
                        separatorBuilder: (BuildContext context, int index) =>
                            Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1C1E1F),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.5),
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(0.0, 1.0),
                                ),
                              ],
                            ),
                            child: RaisedButton(
                              padding: EdgeInsets.all(0.0),
                              color: Color(0xFF1C1E1F),
                              onPressed: () {
                                _launchURL() async {
                                  String url = "${newsData['articles'][index]['url']}";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                }
                                _launchURL();
                              },
                              child: ListTile(
                                contentPadding: EdgeInsets.all(0.0),
                                title: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "${newsData['articles'][index]['title'] ?? ""}" ??
                                          'No news available',
                                      style: TextStyle(
                                          color: Colors.white60,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 0.0),
                                        child: Image.network(
                                            "${newsData['articles'][index]['urlToImage'] ?? ""}"),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "${newsData['articles'][index]['description'] ?? ""}",
                                          style: TextStyle(
                                              color: Colors.white38,
                                              height: 1.5),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${newsData['articles'][index]['source']['name'] ?? ""}",
                                            style: TextStyle(
                                                color: Colors
                                                    .amberAccent.shade700
                                                    .withOpacity(.5)),
                                          ),
                                          Text(
                                              "${newsData['articles'][index]['author'] ?? ""}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
