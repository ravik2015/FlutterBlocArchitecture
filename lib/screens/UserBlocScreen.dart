import 'package:flutter/material.dart';
import 'package:midastouch/blocs/CountryBloc.dart';
import 'package:midastouch/repositories/Repository.dart';

class UserBlocScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserBlocScreenState();
}

class _UserBlocScreenState extends State<UserBlocScreen> {
  CountryBloc _countryBloc;
  final Repository _repository = Repository();
  @override
  void initState() {
    _countryBloc = CountryBloc(this._repository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("testing");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc'),
        actions: <Widget>[
          InkWell(
            onTap: () {
              _countryBloc.loadCountries();
            },
            child: Icon(Icons.refresh),
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<CountryState>(
          stream: _countryBloc.countries,
          initialData: CountryInitState(),
          builder: (context, snapshot) {
            if (snapshot.data is CountryInitState) {
              return _buildInit();
            }
            if (snapshot.data is CountryDataState) {
              CountryDataState state = snapshot.data;
              return _buildContent(state.country);
            }
            if (snapshot.data is CountryLoadingState) {
              return _buildLoading();
            }
            if (snapshot.data is CountryErrorState) {
              return _buildErrorContent();
            }
          },
        ),
      ),
    );
  }

  Widget _buildInit() {
    return Center(
      child: Column(children: <Widget>[
        RaisedButton(
          child: const Text('Load country data'),
          onPressed: () {
            _countryBloc.loadCountries();
          },
        ),
      ]),
    );
  }

  Widget _buildContent(data) {
    print(data);
    return new ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Text(data[index].name);
        });
  }

  Widget _buildErrorContent() {
    return Center(
      child: Text('Something went wromng'),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _countryBloc.dispose();
    super.dispose();
  }
}
