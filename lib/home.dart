import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Http-Json"),
          centerTitle: true,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: getJSONData(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              return _listView(snapshot.data);
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Future<Map<String, dynamic>> getJSONData() async {
    const String url = 'https://unsplash.com/napi/photos/Q14J2k8VE3U/related';

    final response = await http.get(Uri.parse(url));

    var jsonParse = (json.decode(response.body));
    return jsonParse;
  }

  Widget _listView(var data) {
    var imagens = data!['results'] as List;
    return ListView.builder(
      itemCount: imagens.length,
      itemBuilder: (context, index) {
        return _exibirImagem(imagens[index]);
      },
    );
  }

  _exibirImagem(dynamic imagemUrl) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: imagemUrl['urls']['small'],
            ),
            _criarLinhaTexto(imagemUrl),
          ],
        ));
  }
}

//

_criarLinhaTexto(dynamic item) {
  return ListTile(
    title: Text(item['description']),
    subtitle: Text("Likes : ${item['likes']}"),
  );
}
