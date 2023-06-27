import 'package:expanse_tracker/Application/Presentation/edit_page.dart';
import 'package:expanse_tracker/Domain/Model/edit_page_args.dart';
import 'package:expanse_tracker/utility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../Domain/Model/cost.dart';

class ElementViewCost extends StatefulWidget {
  final Cost elementCost;
  const ElementViewCost({super.key, required this.elementCost});

  @override
  State<ElementViewCost> createState() => _ElementViewCostState();
}

class _ElementViewCostState extends State<ElementViewCost> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.green.shade400,
      splashColor: Colors.green.shade100,
      focusColor: Colors.transparent,
      child: ListTile(
        leading: _costumViewCost(),
        title: Text(DateFormat("dd MMMM").format(widget.elementCost.date)),
        subtitle: Text(widget.elementCost.description == null ||
                widget.elementCost.description!.isEmpty
            ? "-"
            : widget.elementCost.description!),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).pushNamed(EditPage.route,
            arguments: EditiPageArg(widget.elementCost)),
      ),
    );
  }

  _costumViewCost() => AspectRatio(
        aspectRatio: 5 / 3,
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(FontAwesomeIcons.dollarSign,
                  size: 14, color: Colors.green.shade900),
              Text(
                Utility.getFromatCost(number: widget.elementCost.import),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900),
              )
            ]),
          ),
        ),
      );
}
