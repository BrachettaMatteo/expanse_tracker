import 'package:expanse_tracker/Application/Presentation/components/element_view_cost.dart';
import 'package:expanse_tracker/Application/Presentation/edit_page.dart';
import 'package:expanse_tracker/Domain/Model/edit_page_args.dart';
import 'package:expanse_tracker/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Domain/Model/cost.dart';
import '../BusinessLogic/bloc/expanse_tracker_bloc.dart';

class HomePage extends StatefulWidget {
  static String route = "/";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double analiticsMonth = 0.0;
  double analiticsYear = 0.0;
  double analiticsDay = 0.0;
  List<Cost> lsCost = [];

  @override
  void initState() {
    final state = BlocProvider.of<ExpanseTrackerBloc>(context).state;
    if (state is ExpanseTrackerLoaded) {
      setState(() {
        lsCost = state.lstAllCost;
        analiticsDay = lsCost
            .where(
                (element) => element.date.difference(DateTime.now()).inDays < 1)
            .fold(0.0,
                (previousValue, element) => previousValue + element.import);

        analiticsYear = lsCost
            .where((element) => element.date.year == DateTime.now().year)
            .fold(0.0,
                (previousValue, element) => previousValue + element.import);

        analiticsYear = lsCost
            .where((element) => element.date.year == DateTime.now().year)
            .fold(0.0,
                (previousValue, element) => previousValue + element.import);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExpanseTrackerBloc, ExpanseTrackerState>(
          builder: (context, state) {
        if (state is ExpanseTrackerInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ExpanseTrackerLoaded) {
          lsCost = state.lstAllCost;
          analiticsDay = lsCost
              .where((element) =>
                  element.date.difference(DateTime.now()).inDays < 1)
              .fold(0.0,
                  (previousValue, element) => previousValue + element.import);

          analiticsMonth = lsCost
              .where((element) => element.date.month == DateTime.now().month)
              .fold(0.0,
                  (previousValue, element) => previousValue + element.import);

          analiticsYear = lsCost
              .where((element) => element.date.year == DateTime.now().year)
              .fold(0.0,
                  (previousValue, element) => previousValue + element.import);
        }
        return Column(
          children: [
            Material(
              elevation: 20,
              color: Theme.of(context).primaryColor,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("This month",
                                    style: TextStyle(color: Colors.white70)),
                                IconButton(
                                    onPressed: () => {_openSettings()},
                                    icon: const Icon(FontAwesomeIcons.sliders))
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.dollarSign,
                                  color: Colors.white,
                                ),
                                Text(
                                  Utility.getFromatCost(number: analiticsMonth),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _getContainer(
                                label: "day", analitics: analiticsDay),
                            _getContainer(
                                label: "month", analitics: analiticsMonth),
                            _getContainer(
                                label: "year", analitics: analiticsYear)
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  )),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        Cost el = lsCost[index];
                        return Dismissible(
                          key: Key(el.id),
                          onDismissed: (direction) {
                            BlocProvider.of<ExpanseTrackerBloc>(context)
                                .add(ExpanseTrackerEventRemoveCost(el.id));
                          },
                          background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.solidTrashCan,
                                    color: Colors.white,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.solidTrashCan,
                                    color: Colors.white,
                                  ),
                                ]),
                          ),
                          child: ElementViewCost(
                            elementCost: el,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: lsCost.length),
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
                Navigator.of(context).pushNamed(EditPage.route,
                    arguments: EditiPageArg(Cost.empty()))
              },
          label: Row(
            children: const [
              Icon(FontAwesomeIcons.dollarSign),
              SizedBox(
                width: 10,
              ),
              Text("add cost")
            ],
          )),
    );
  }

  Widget _getContainer({required String label, required double analitics}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).shadowColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).shadowColor),
        ),
        child: Column(
          children: [
            Text(
              Utility.getFromatCost(number: analitics),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ));
  }

  void _openSettings() {}
}
