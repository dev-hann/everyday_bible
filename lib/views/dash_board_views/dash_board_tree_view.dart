
part of dash_board_lib;

class DashBoardTreeView extends StatefulWidget {
  @override
  _TreeViewState createState() => _TreeViewState();
}

class _TreeViewState extends State<DashBoardTreeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey)
        // color: Colors.grey[400]
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Center(child: FaIcon(FontAwesomeIcons.pagelines,size: 150,)),
      ),
    );
  }
}
