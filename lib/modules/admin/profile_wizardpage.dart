import 'package:fashionet_provider/blocs/blocs.dart';
import 'package:fashionet_provider/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileWizardForm extends StatefulWidget {
  @override
  _ProfileWizardFormState createState() => _ProfileWizardFormState();
}

class _ProfileWizardFormState extends State<ProfileWizardForm> {
  final _pageController = PageController(initialPage: 0, keepPage: true);
  PageView _pageView;

  int _currentWizardPageIndex = 0;

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  void _jumpToPreviousPage({@required AuthBloc authBloc}) {
    if (_currentWizardPageIndex == 0) {
      authBloc.signout();
    } else {
      _pageController.jumpToPage(--_currentWizardPageIndex);
    }
  }

  void _jumpToNextPage() {
    if (_currentWizardPageIndex == 4) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      _pageController.jumpToPage(++_currentWizardPageIndex);
    }
  }

  Widget _buildActiveWizardPage() {
    return Container(
      width: 9.0,
      height: 9.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(width: 2.0, color: Theme.of(context).accentColor),
      ),
    );
  }

  Widget _buildInactiveWizardPage() {
    return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color.fromRGBO(0, 0, 0, 0.4)));
  }

  Widget _buildFormWizardIndicator() {
    List<Widget> dots = [];

    for (int i = 0; i < 5; i++) {
      dots.add(i == _currentWizardPageIndex
          ? _buildActiveWizardPage()
          : _buildInactiveWizardPage());
    }

    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 20.0,
      height: 70.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dots,
      ),
    );
  }

  Widget _buildFormWizardActions({@required AuthBloc authBloc}) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      height: 80.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black54,
              ]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _currentWizardPageIndex > 0
                ? Container()
                : FlatButton(
                    splashColor: Colors.white30,
                    child: Text(
                      _currentWizardPageIndex == 0 ? 'Logout' : 'Previous',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 20.0),
                    ),
                    onPressed: () => _jumpToPreviousPage(authBloc: authBloc),
                  ),
            FlatButton(
              splashColor: Colors.white30,
              child: Text(
                _currentWizardPageIndex == 4 ? 'Complete' : 'Continue',
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20.0),
              ),
              onPressed: _jumpToNextPage,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);

    _pageView = PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (int index) {
        setState(() {
          _currentWizardPageIndex = index;
        });
      },
      children: <Widget>[
        ProfileImageForm(),
        // ProfileBioForm(),
        // ProfileBusinessForm(),
        // ProfileContactForm(),
        // ProfileLocationForm(),
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          _pageView,
          _buildFormWizardIndicator(),
          _buildFormWizardActions(authBloc: _authBloc)
        ],
      ),
    );
  }
}
