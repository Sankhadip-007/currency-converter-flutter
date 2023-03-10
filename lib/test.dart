import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xchange/api_client.dart';

import 'icon_map.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List<String>? currencies;
  String fromCurrency = "USD";
  String toCurrency = "INR";
  String? result;
  String amount="1";
  late Map<String, dynamic> jsonData,result_data;
  @override
  void initState() {
    super.initState();

    ApiClient().getJSONData().
    then((data) {
      setState(() {
        jsonData = data;
        Map<String,dynamic> symbols=jsonData["symbols"];
        currencies = symbols.keys.toList();
      });
    });

  }

  Future<Map<String, dynamic>> fetchExchangeRates() async {
    amount=fromTextController.text;
    var url = 'https://yourAPIurl/convert?to=$toCurrency&from=$fromCurrency&amount=$amount';
    var apikey = 'your api key';
    loading();
    var response = await http.get(Uri.parse(url), headers: {'apikey': apikey});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      //throw('Error: ${response.statusCode}');
      throw Exception('Failed to load data from URL');
    }
  }
  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return currencies==null?
    Container(
        decoration: BoxDecoration(color: Colors.blueGrey,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,width: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/exchange.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 150,),
            CircularProgressIndicator(color: Colors.white,),
          ],
        )
    )
        :
    Scaffold(
      appBar: AppBar(
        title: const Text("XChange"),
      ),
      body:
      Container(
        //height: MediaQuery.of(context).size.height/2 ,
        //width: MediaQuery.of(context).size.width,
        color: Color(0xFF3F5A79),
        child: Padding(
          padding:  const EdgeInsets.only(top: 7,right: 7,left: 7,bottom: 7),
          child: Card(
            color: Colors.blueGrey,
            elevation: 4.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20,),
                ListTile(
                 leading: leadingTile(fromCurrency),

                  title: Container(
                    height: 45,
                    decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: Colors.black54),
                    ),
                    padding: EdgeInsets.only(left: 5),
                    child: TextField(
                      controller: fromTextController,
                      cursorColor: Colors.green[900],
                      decoration: const InputDecoration(
                        hintText: "Enter Amount",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.black,),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  trailing: _buildDropDownButton(fromCurrency),
                ),
                SizedBox(height:10),
                IconButton(
                  icon: Icon(Icons.keyboard_double_arrow_down),
                  onPressed: (){
                    fetchExchangeRates().then((data) {
                      setState(() {
                        result_data = data;
                        result = result_data["result"].toString();
                      });
                    });
                  },
                ),
                ListTile(
                  leading: leadingTile(toCurrency),
                  title: Container(
                    alignment: Alignment.center,
                    height: 45,
                      decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                                                border: Border.all(color: Colors.black54),

                      ),
                    child: result != null ?
                     Text(
                        result!,
                    ) :  Text("0.00")
                  ),
                  trailing: _buildDropDownButton(toCurrency),
                ),
                SizedBox(height:10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      iconSize: 20,
      dropdownColor: Colors.blueGrey,
      iconEnabledColor: Colors.white,
      value: currencyCategory,
      items: currencies
          ?.map((String value) => DropdownMenuItem(
        value: value,
        child: Row(
          children: <Widget>[
            Text(value,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          ],
        ),
      ))
          .toList(),
      onChanged: (String? value) {
        if(currencyCategory == fromCurrency){
          _onFromChanged(value!);
        }else {
          _onToChanged(value!);
        }
      },
    );
  }
  Widget leadingTile(String curr){
    return Container(
      width: 60,
      decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(25.0)),
        color: Colors.black54,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                icon_map().currencyIcons[curr]! ,
                key: ValueKey(Text(icon_map().currencyIcons[curr]!)),
                style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold , color: Colors.white),
              ),
            ),
            Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,),
          ],
        ),
      ),
    );
  }
  void loading(){
    int _second = DateTime.now().second;
    setState(() {
      if(_second%2==0){result='loading'+'...';}
      else{result='loading'+'..';}
    });
  }
}
