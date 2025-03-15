import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/event_modle.dart';
import 'package:trackerapp/models/event_on_map_model.dart';
import 'package:trackerapp/models/events_intitial_data.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/res/components/custometitletontainer.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/utils/utils.dart';
import 'package:trackerapp/view_model/event_view_model.dart';

class EventsAlertsPage extends StatefulWidget {
  final EventsInitialData eventsInitialData;
  const EventsAlertsPage(
    this.eventsInitialData, {
    super.key,
  });

  @override
  State<EventsAlertsPage> createState() => _EventsAlertsPageState();
}

class _EventsAlertsPageState extends State<EventsAlertsPage> {
  EventViewModel eventViewModel = EventViewModel();
  late List<Data> alertsList = [];
  late ScrollController _controller = ScrollController();
  bool isSearchResult = false;
  // late String deviceID = '';
  // late String eventType = '';
  late String fromDate = '';
  late String toDate = '';
  late String deviceID = widget.eventsInitialData.deviceID.toString();
  late String eventType = widget.eventsInitialData.eventType.toString();
  // late String fromDate = widget.eventsInitialData.fromDate.toString();
  // late String toDate = widget.eventsInitialData.toDate.toString();
  late int pageNumber = 1;
  late int totalPages;
  late bool isLoadingPage = false;
  late List<Data> alertSearchResults = [];
  final searchKeywordController = TextEditingController();
  void _runFilter(String enteredKeyword) {
    alertSearchResults.clear();
    List<Data> results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all vehciles
      results = alertsList;
      isSearchResult = false;
    } else {
      results = alertsList
          .where((alert) =>
              alert.deviceName!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              alert.message!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    alertSearchResults.addAll(results);
    isSearchResult = true;
    eventViewModel.resetEventsAlertsResponse();
    // Refresh the UI
  }

  _loadMore() async {
    if (_controller.position.extentAfter < 100) {
      if (!isLoadingPage && pageNumber < totalPages) {
        pageNumber = pageNumber + 1;
        Utils.toastMessage('Loading more alerts...');
        eventViewModel.fetchEventsAlertsFromApi(
            deviceID, eventType, fromDate, toDate, pageNumber.toString());
        isLoadingPage = true;
      }
      // if (searchKeywordController.value.text.isNotEmpty) {
      //   Future.delayed(Duration.zero, () {
      //     _runFilter(searchKeywordController.value.toString());
      //   });
      // }
    }
  }

  @override
  void initState() {
    print('this is ' + widget.eventsInitialData.deviceID.toString());
    eventViewModel.fetchEventsAlertsFromApi(
        widget.eventsInitialData.deviceID.toString(),
        eventType,
        fromDate,
        toDate,
        pageNumber.toString());
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: AppColors.appScreenBackgroundImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: InkWell(
                  onTap: () {
                    eventViewModel.destroyEventsAlertsFromApi().then((value) =>
                        Utils.toastMessage('All alerts are deleted'));
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              VerticalDivider(),
            ],
            title: Text(
              'Events and Alerts',
              style: AppColors.appTitleTextStyle,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchKeywordController,
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                      labelText: 'Search Vehicle or Alert',
                      suffixIcon: Icon(Icons.search)),
                ),
              ),
              ChangeNotifierProvider<EventViewModel>(
                create: (BuildContext context) => eventViewModel,
                child: Consumer<EventViewModel>(
                  builder: (context, value, _) {
                    switch (value.eventsAlertsResponse.status) {
                      case Status.LOADING:
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                    image:
                                        AssetImage('assets/images/loading.gif'),
                                    width: 100,
                                    height: 100),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Loading...')
                              ],
                            ),
                          ),
                        );
                      case Status.ERROR:
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                Divider(),
                                Text(AppColors.errorMessage)
                              ],
                            ),
                          ),
                        );
                      case Status.COMPLETED:

                        // alertsList.clear();
                        if (!isSearchResult) {
                          for (var element in value
                              .eventsAlertsResponse.data!.items!.data!) {
                            alertsList.add(element);
                          }
                          alertSearchResults.clear();
                          alertSearchResults.addAll(alertsList);
                        }
                        print(
                            'Alert List length' + alertsList.length.toString());
                        // if (!isSearchResult) {
                        //   Future.delayed(Duration.zero, () {
                        //     _runFilter('');
                        //   });
                        // }
                        totalPages =
                            value.eventsAlertsResponse.data!.items!.lastPage!;

                        isLoadingPage = false;
                        isSearchResult = false;
                        return Expanded(
                          child: alertSearchResults.isNotEmpty
                              ? ListView.builder(
                                  controller: _controller,
                                  itemCount: alertSearchResults.length,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              RoutesName.eventondevicemap,
                                              arguments: EventOnMapDataModel(
                                                  intialLat: alertSearchResults[
                                                          index]
                                                      .latitude,
                                                  intiallng:
                                                      alertSearchResults[
                                                              index]
                                                          .longitude,
                                                  vehiclename:
                                                      alertSearchResults[
                                                              index]
                                                          .deviceName,
                                                  message:
                                                      alertSearchResults[
                                                              index]
                                                          .message,
                                                  speed:
                                                      alertSearchResults[index]
                                                          .speed,
                                                  intialdirection:
                                                      alertSearchResults[index]
                                                          .course,
                                                  eventtime:
                                                      alertSearchResults[index]
                                                          .time));
                                        },
                                        child: Card(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          shape: AppColors.cardBorderShape,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomTitleContainer(
                                                      titleText:
                                                          alertSearchResults[
                                                                  index]
                                                              .deviceName
                                                              .toString()),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.grey,
                                                      size: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // const Divider(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .notifications_active_outlined,
                                                      color: Colors.red,
                                                    ),
                                                    const VerticalDivider(
                                                      width: 4,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${alertSearchResults[index].message}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10,
                                                            bottom: 8),
                                                    child: Text(
                                                        '${alertSearchResults[index].time}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                )
                              : const Text('No alerts found'),
                        );

                      default:
                        const Text('Something went wrong');
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
