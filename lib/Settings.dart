import 'package:dial/ReusableCode.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    //const String number = '0676428404';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xff3D3C77),
        title: Text(
          'Settings',
          style: TextStyle(
              color: Theme.of(context).primaryColorLight, fontSize: 14),
        ),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/addFriends', (route) => false);
          },
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 0.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff3D3C77), Color(0xff000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text(
                        "More",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                headers(context, 'Generals'),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: InkWell(
                    child: Text(
                      "One time payment to remove adds permanently",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                headers(context, 'About'),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      tapButton(
                          context,
                          'Share with Friends',
                          () => Reuse.display(
                              context,
                              "Dial App\n",
                              "Download Dial on play store with a blue"
                                  " background and white dots",
                              "")),
                      //tapButton(context, 'More Apps', () => null),
                      tapButton(
                        context,
                        'Send us feedback',
                        () => Navigator.pushNamedAndRemoveUntil(
                            context, '/emailTemplate', (route) => false),
                      ),
                    ],
                  ),
                ),
                // headers(context, 'Follow Us'),
                // SizedBox(
                //   child: Column(
                //     children: [
                //       Reuse.links(
                //           context,
                //           Uri.parse(
                //               'www.linkedin.com/in/templeton-meshack-9b288b1a0'),
                //           "LinkedIn"),
                //       Reuse.links(
                //           context,
                //           Uri.parse('https://dribbble.com/Templeton'),
                //           "Dribbble"),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "App version 2.3.2",
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryColorLight),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container headers(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).primaryColor.withOpacity(.5),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(
          child: Text(
            title,
            style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Padding tapButton(BuildContext context, String title, Function() function) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: InkWell(
        onTap: function,
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
    );
  }

  Padding tapIconButton(
      BuildContext context, String title, Function() function, Icon icon) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 7,
            ),
            Text(
              title,
              style: TextStyle(color: Theme.of(context).primaryColorLight),
            ),
          ],
        ));
  }
}
