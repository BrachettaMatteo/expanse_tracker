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
  final FocusNode _focusNodeImport = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();
  final TextEditingController _importController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late final Cost _initCost;

  final _formKey = GlobalKey<FormState>();
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
    _focusNodeDescription.dispose();
    _focusNodeImport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: InkWell(
        focusColor: Colors.transparent,
        highlightColor: Theme.of(context).primaryColor,
        onLongPress: () =>
            _initCost.import == 0 ? _createCost() : _updateCost(),
        child: _getInputForm(),
      ),
      floatingActionButton: _initCost.import > 0
          ? FloatingActionButton(
              child: const Icon(FontAwesomeIcons.solidTrashCan),
              onPressed: () {
                BlocProvider.of<ExpanseTrackerBloc>(context)
                    .add(ExpanseTrackerEventRemoveCost(_initCost.id));
                Navigator.pop(context);
              })
          : null,
    );
  }

  Widget _getInputForm() {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getFieldImport(),
            _getInputDescription(),
          ],
        ),
      ),
    );
  }

  void _updateCost() {
    if (double.parse(_importController.text) != _initCost.import ||
        _descriptionController.text != _initCost.description) {
      if (double.parse(_importController.text) > 0) {
        _initCost.description = _descriptionController.text.isEmpty
            ? _initCost.description
            : _descriptionController.text;
        _initCost.import = double.parse(_importController.text);
        BlocProvider.of<ExpanseTrackerBloc>(context)
            .add(ExpanseTrakerEventUpdateCost(_initCost.id, _initCost));
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(_errorSnackBar());
    }
  }

  void _createCost() {
    if (_formKey.currentState!.validate()) {
      _initCost.description = _descriptionController.text;
      _initCost.import = double.parse(_importController.text);
      BlocProvider.of<ExpanseTrackerBloc>(context)
          .add(ExpanseTrackerEventAddCost(_initCost));
      Navigator.of(context).pop();
    } else {
      _importController.clear();
      ScaffoldMessenger.of(context).showSnackBar(_errorSnackBar());
    }
  }

  _getFieldImport() => IntrinsicWidth(
        child: TextFormField(
          keyboardType: TextInputType.number,
          focusNode: _focusNodeImport,
          textInputAction: TextInputAction.go,
          controller: _importController,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          showCursor: true,
          autocorrect: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "error import";
            } else {
              return double.parse(value) > 0 ? null : "import < 0";
            }
          },
          onFieldSubmitted: (value) {
            _focusNodeImport.unfocus();
            FocusScope.of(context).requestFocus(_focusNodeDescription);
          },
          decoration: InputDecoration(
            prefix: Icon(
              FontAwesomeIcons.dollarSign,
              color: Theme.of(context).textTheme.bodyMedium!.color,
              size: 35,
            ),
            hintText: _initCost.import == 0
                ? 'import'
                : _initCost.import.toStringAsFixed(2),
            border: InputBorder.none,
          ),
        ),
      );

  _getInputDescription() => IntrinsicWidth(
        child: TextField(
          autocorrect: false,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.done,
          focusNode: _focusNodeDescription,
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText:
                _initCost.description == null || _initCost.description!.isEmpty
                    ? 'Enter a description'
                    : "",
            border: InputBorder.none,
          ),
        ),
      );

  SnackBar _errorSnackBar() => SnackBar(
        content: const Text('import not valid'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        elevation: 30,
        action: SnackBarAction(
          label: 'go home',
          textColor: Colors.white70,
          onPressed: () => Navigator.pop(context),
        ),
      );

  AppBar _appBar() => AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () =>
              _initCost.import == 0 ? _createCost() : _updateCost(),
          icon: const Icon(FontAwesomeIcons.floppyDisk),
          color: Colors.green.shade500,
        )
      ],
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.close,
          color: Colors.red,
        ),
      ));
}
