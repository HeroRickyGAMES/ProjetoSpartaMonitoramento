import 'dart:convert';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;

//Programado por HeroRickyGames com ajuda de Deus!

Future<Map<String, dynamic>> pushPessoas(var context, String ip, int porta, String usuario, String Senha, String modelo) async {

  //ControlID
  if(modelo == "Control iD"){
    final ipog = Uri.parse('http://$ip:$porta/login.fcgi');

    Map<String, String> headerslog = {
      "Content-Type": "application/json"
    };

    Map<String, dynamic> bodylog = {
      "login": usuario,
      "password": Senha
    };
    try{
      final response = await http.post(
        ipog,
        headers: headerslog,
        body: jsonEncode(bodylog),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        final url = Uri.parse('http://$ip:$porta/load_objects.fcgi?session=${responseData["session"]}');

        Map<String, String> headers = {
          "Content-Type": "application/json"
        };

        Map<String, dynamic> body = {
          "object": "users"
        };

        try {
          final responsee = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );

          if (responsee.statusCode == 200) {
            Map<String, dynamic> users = jsonDecode(responsee.body);

            return users;
          } else {
            showToast("Erro com a comunicação, status: ${responsee.statusCode}", context: context);
          }
        } catch (e) {
          showToast("Erro ao executar a requisição: $e", context: context);
        }

      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
      }
      
    }catch(e){
      showToast("Erro ao executar a requisição: $e", context: context);
    }
  }

  //Intelbras
  if(modelo == "Intelbras"){
    final url = Uri.parse('http://$ip:$porta/cgi-bin/recordFinder.cgi?action=doSeekFind&name=AccessControlCard&count=4300');

    Map<String, String> headers = {
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
    };

    final client = http_auth.DigestAuthClient(usuario, Senha);

    try {
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
      }
    } catch (e) {
      showToast("Erro ao executar a requisição: $e",context:context);
    }
  }
  return {};
}