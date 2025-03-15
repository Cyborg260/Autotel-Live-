import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/repository/geo_fence_list_repository.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/utils/utils.dart';
import 'package:trackerapp/view_model/geofence_view_view_model.dart';

class GeoFenceListScreen extends StatefulWidget {
  const GeoFenceListScreen({super.key});

  @override
  State<GeoFenceListScreen> createState() => _GeoFenceListScreenState();
}

class _GeoFenceListScreenState extends State<GeoFenceListScreen> {
  GeoFenceViewViewModel geoFenceViewViewModel = GeoFenceViewViewModel();

  bool currentCheckBoxValue = false;
  @override
  void initState() {
    // TODO: implement initState
    geoFenceViewViewModel.fetchGeoFenceFromApi();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Geofence List',
              style: AppColors.appTitleTextStyle,
            ),
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            centerTitle: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              ChangeNotifierProvider<GeoFenceViewViewModel>(
                create: (BuildContext context) => geoFenceViewViewModel,
                child: Consumer<GeoFenceViewViewModel>(
                  builder: (context, value, child) {
                    switch (value.geoFenceListResponse.status) {
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
                                Image(
                                    image:
                                        AssetImage('assets/images/loading.gif'),
                                    width: 100,
                                    height: 100),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(AppColors.errorMessage)
                              ],
                            ),
                          ),
                        );
                      case Status.COMPLETED:
                        return Expanded(
                            child: ListView.builder(
                          itemCount: value.geoFenceListResponse.data!.items
                              .geofences.length,
                          itemBuilder: (context, index) {
                            if (value.geoFenceListResponse.data!.items
                                    .geofences[index].active ==
                                1) {
                              currentCheckBoxValue = true;
                            } else {
                              currentCheckBoxValue = false;
                            }
                            return Card(
                              child: ListTile(
                                title: Text(
                                  value.geoFenceListResponse.data!.items
                                      .geofences[index].name
                                      .toString(),
                                  style: AppColors.settingTextstyle,
                                ),
                                leading: SizedBox(
                                  width: 50,
                                  child: GFCheckbox(
                                    activeBgColor: AppColors.buttonColor,
                                    onChanged: (activationStatus) {
                                      Utils.toastMessage('Updating...');
                                      if (activationStatus) {
                                        geoFenceViewViewModel
                                            .changeGeoFenceStatusFromAPI(
                                                value.geoFenceListResponse.data!
                                                    .items.geofences[index].id
                                                    .toString(),
                                                1);
                                      } else {
                                        geoFenceViewViewModel
                                            .changeGeoFenceStatusFromAPI(
                                                value.geoFenceListResponse.data!
                                                    .items.geofences[index].id
                                                    .toString(),
                                                0);
                                      }
                                    },
                                    value: currentCheckBoxValue,
                                    size: GFSize.SMALL,
                                  ),
                                ),
                                trailing: InkWell(
                                  child: const Icon(Icons.delete),
                                  onTap: () {
                                    Utils.toastMessage('Deleting Geofence...');
                                    geoFenceViewViewModel.deleteGeoFenceFromAPI(
                                        value.geoFenceListResponse.data!.items
                                            .geofences[index].id
                                            .toString());
                                  },
                                ),
                                subtitle: Text(value.geoFenceListResponse.data!
                                    .items.geofences[index].createdAt),
                              ),
                            );
                          },
                        ));

                      default:
                    }
                    return Container();
                  },
                ),
              )
            ],
          )),
    );
  }
}
