import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/request/controlRequestImage.dart'
    as controlRequestImage;
import 'package:retailapp/ui/all/imageZoomUI.dart';
import 'package:retailapp/ui/request/requestImageNewUI.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/mySuperTooltip.dart';
import 'package:retailapp/control/my/myDialog.dart' as myDialog;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class RequestImageListUI extends StatefulWidget {
  final double requestID;
  RequestImageListUI(this.requestID);
  @override
  RequestImageListUIState createState() => RequestImageListUIState();
}

class RequestImageListUIState extends State<RequestImageListUI>
    with SingleTickerProviderStateMixin {
  bool _filterActive = false;
  String _filter = '';
  TextEditingController _filterController = TextEditingController(text: '');

  AnimationController _ac;

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
    _ac =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              _buildFilter(),
              _buildList(),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildAppBar() {
    return _filterActive
        ? null
        : AppBar(
            title: Text(MyLanguage.text(myLanguageItem.timelineImages)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _filterReactive,
              )
            ],
          );
  }

  Widget _buildFilter() {
    return _filterActive
        ? SizeTransition(
            axis: Axis.horizontal,
            sizeFactor:
                CurvedAnimation(parent: _ac, curve: Curves.fastOutSlowIn),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1.0, color: MyColor.color1))),
                  padding: EdgeInsets.only(top: 25.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            color: MyColor.color1,
                          ),
                          onTap: _filterReactive,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          autofocus: true,
                          style: MyStyle.style15Color1(),
                          controller: _filterController,
                          onChanged: (v) => _filterApply(v),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                MyLanguage.text(myLanguageItem.search) + '...',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: _filter.isEmpty == true
                            ? SizedBox(width: 0)
                            : InkWell(
                                child: Icon(
                                  Icons.clear,
                                  color: MyColor.color1,
                                ),
                                onTap: _filterClear,
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 1,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: MyColor.color1,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 5.0)),
                    ])),
              ],
            ),
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlRequestImage.getAll(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return Flexible(
          child: ListView(
            padding: EdgeInsets.only(bottom: 70),
            children: v.data.documents.where((v) {
              return _cardValid(v);
            }).map((DocumentSnapshot dr) {
              return _buildCard(dr);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCard(DocumentSnapshot dr) {
    return Card(
      child: ListTile(
        title: _buildImage(dr),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                dr['note'],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    dr['user'],
                  ),
                ),
                Text(
                  MyDateTime.formatAndShortByFromString(
                      dr['dateTimeIs'].toString(),
                      MyDateTimeFormatTypes.ddMMyyyyhhmma),
                  textAlign: TextAlign.end,
                  style: MyStyle.style12Color3(),
                ),
                SizedBox(
                  width: 8.0,
                ),
                _buildStage(dr['stageIs']),
                _buildNeedInsertOrUpdate(dr),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => ImageZoomUI(dr['pathImage'])));
        },
      ),
    );
  }

  Widget _buildImage(DocumentSnapshot dr) {
    return Container(
        height: 200,
        child: CachedNetworkImage(
          imageUrl: dr['pathImage'],
          placeholder: CircularProgressIndicator(),
          errorWidget: Icon(Icons.error),
        ));
  }

  Widget _buildNeedInsertOrUpdate(DocumentSnapshot dr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        dr['needInsert'] == false
            ? _buildDelete(dr)
            : _buildNeedAction(Icons.add),
        dr['needUpdate'] == false ? SizedBox() : _buildNeedAction(Icons.update)
      ],
    );
  }

  Widget _buildNeedAction(IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: Icon(
        icon,
        color: Colors.red,
      ),
    );
  }

  Widget _buildStage(int v) {
    String t = 'lib/res/image/Prospect_001_32.png';

    switch (v) {
      case 1:
        t = 'lib/res/image/Prospect_001_32.png';
        break;
      case 2:
        t = 'lib/res/image/CallerID_003_32.png';
        break;
      case 3:
        t = 'lib/res/image/Request_003_32.png';
        break;
      case 4:
        t = 'lib/res/image/Quotation_002_32.png';
        break;
      case 5:
        t = 'lib/res/image/Installation_001_32.png';
        break;
      case 6:
        t = 'lib/res/image/MoneyCollection_001_32.png';
        break;
      case 7:
        t = 'lib/res/image/Win_001_32.png';
        break;
      case 9:
        t = 'lib/res/image/Close_004_32.png';
        break;
    }

    return Image.asset(
      t,
      color: MyColor.color1,
      height: 16.0,
      width: 16.0,
    );
  }

  Widget _buildDelete(DocumentSnapshot dr) {
    return InkWell(
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      onTap: _deleteTooltip,
      onLongPress: () => _delete(dr),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _new,
      backgroundColor: MyColor.color1,
    );
  }

  bool _cardValid(DocumentSnapshot dr) {
    if (dr['requestID'] != widget.requestID) return false;

    if ((dr['user'] + dr['note']).toLowerCase().contains(_filter) == false)
      return false;

    if (controlUser.drNow.data['name'].toString().toLowerCase() == 'admin')
      return true;

    //for some time
    if (dr['isPrivate'] == null) return true;

    if (dr['isPrivate'] == true && dr['userID'] != controlUser.drNow.documentID)
      return false;

    return true;
  }

  void _deleteTooltip() {
    MySuperTooltip.show4(
        context, MyLanguage.text(myLanguageItem.pressForALongTimeToDeleteIt));
  }

  void _delete(DocumentSnapshot dr) async {
    if (await myDialog.deleteAsk(context) == myDialog.ReturnDialog.yes) {
      controlRequestImage.delete(dr.documentID);
    }
  }

  void _filterReactive() {
    setState(() {
      _filterActive = !_filterActive;
      _filterController = TextEditingController(text: '');
      _filterApply('');

      if (_filterActive) {
        _ac.reset();
        _ac.forward();
      }
    });
  }

  void _filterApply(String v) {
    setState(() {
      _filter = v.toLowerCase();
    });
  }

  void _filterClear() {
    setState(() {
      _filter = '';
      _filterController = TextEditingController(text: '');
    });
  }

  void _new() {
    Navigator.push(context,
        MaterialPageRoute(builder: (c) => RequestImageNewUI(widget.requestID)));
  }

  @override
  void dispose() {
    super.dispose();
    _ac.dispose();
    _filterController.dispose();
  }
}
