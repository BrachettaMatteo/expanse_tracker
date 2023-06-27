import 'dart:developer';

import 'package:expanse_tracker/Application/BusinessLogic/bloc/expanse_tracker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Domain/Model/cost.dart';
import '../../Domain/Model/edit_page_args.dart';

class EditPage extends StatefulWidget {
  static const route = "/editPage";
  final EditiPageArg args;
  const EditPage({super.key, required this.args});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  //TODO: add focus and validator
  final TextEditingController _importController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late final Cost _initCost;
  @override
  void initState() {
    _initCost = widget.args.elementCost;
    if (_initCost.import > 0) {
      _importController.text = _initCost.import.toString();
    }
    if (_initCost.description != null && _initCost.description!.isNotEmpty) {
      _descriptionController.text = _initCost.description!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _importController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: InkWell(
        onLongPress: () =>
            _initCost.import == 0 ? _createCost() : _updateCost(),
        child: _getInputForm(),
      ),
      floatingActionButton: _initCost.import > 0
          ? FloatingActionButton(onPressed: () {
              BlocProvider.of<ExpanseTrackerBloc>(context)
                  .add(ExpanseTrackerEventRemoveCost(_initCost.id));
              Navigator.pop(context);
            })
          : null,
    );
  }

  Widget _getInputForm() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: _getFieldImport(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: _getInputDescription(),
          ),
        ],
      ),
    );
  }

  void _updateCost() {
    if (double.parse(_importController.text) != _initCost.import ||
        _descriptionController.text != _initCost.description) {
      log(_initCost.toString());
      if (double.parse(_importController.text) > 0) {
        _initCost.description = _descriptionController.text.isEmpty
            ? _initCost.description
            : _descriptionController.text;
        _initCost.import = double.parse(_importController.text);
        BlocProvider.of<ExpanseTrackerBloc>(context)
            .add(ExpanseTrakerEventUpdateCost(_initCost.id, _initCost));
      }
    }
    Navigator.of(context).pop();
  }

  void _createCost() {
    if (_importController.text.isNotEmpty &&
        double.parse(_importController.text) > 0) {
      _initCost.description = _descriptionController.text;
      _initCost.import = double.parse(_importController.text);
      BlocProvider.of<ExpanseTrackerBloc>(context)
          .add(ExpanseTrackerEventAddCost(_initCost));
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  _getFieldImport() => TextField(
        keyboardType: TextInputType.number,
        controller: _importController,
        style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        showCursor: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            FontAwesomeIcons.dollarSign,
            color: Theme.of(context).textTheme.bodyMedium!.color,
            size: 35,
          ),
          hintText: _initCost.import == 0
              ? 'new cost'
              : _initCost.import.toStringAsFixed(2),
          border: InputBorder.none,
        ),
      );

  _getInputDescription() => TextField(
        textAlign: TextAlign.center,
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText:
              _initCost.description == null || _initCost.description!.isEmpty
                  ? 'Enter a description'
                  : "",
          border: InputBorder.none,
        ),
      );
}
