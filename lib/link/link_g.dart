import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:superlink/globals.dart';
import 'package:superlink/link/dados_class.dart';
import 'package:superlink/link/filial_class.dart';

class CieloApi {
  static Future<dynamic> gerarAuth(String base) async {
    Dio dio;

    String url_auth = "https://cieloecommerce.cielo.com.br/api/public/v2/token";

    dio = Dio(BaseOptions(
        headers: {"Authorization": "Basic $base", "Content-Type": "application/x-www-form-urlencoded"}));

    var res;

    try {
      Response resposta = await dio.post(url_auth);
      res = resposta;
    } on DioError catch (e) {
      print(e);
    }

    return res.data["access_token"];
  }

  static Future<dynamic> gerarLink(
    String orcamento,
    int valor,
    String acessToken,
    int parcela,
    String data,
  ) async {
    var url_cielo = 'https://cieloecommerce.cielo.com.br/api/public/v1/products/';

    Map<String, String> headers = {
      "Authorization": "Bearer $acessToken",
      "Content-Type": "application/json",
    };

    Map params = {
      "Type": "Payment",
      "name": "Orçamento $orcamento",
      "description": "Orçamento $orcamento",
      "price": "$valor",
      "ExpirationDate": "$data", //$data
      "maxNumberOfInstallments": "$parcela",
      "quantity": 1,
      "shipping": {"type": "Free", "name": "", "price": "0"}
    };

    String json_params = json.encode(params);


    try {
      var resposta = await http.post(url_cielo, body: json_params, headers: headers);

      //print('Status: ${resposta.statusCode}');
      //print('Status: ${resposta.body}');

      var responseDecode = json.decode(resposta.body);
      if(resposta.statusCode != 201){
        return {
          "id": 'Error',
          "Body": resposta.body,
        };
      }else{
        return responseDecode;
      }


    } on Exception catch (e) {
      return 'Erro $e';
    }
  }


  static Future<dynamic> verStatus(String acessToken, String id, {bool verLink = false}) async {
    Map<String, String> headers = {
      "Authorization": "Bearer $acessToken",
      "Content-Type": "application/json",
    };

    var url_cielo;

    if (verLink) {
      url_cielo = "https://cieloecommerce.cielo.com.br/api/public/v1/products/$id";
    } else {
      url_cielo = "https://cieloecommerce.cielo.com.br/api/public/v1/products/$id/payments";
    }

    print(url_cielo);

    var resposta = await http.get(url_cielo, headers: headers);

    if (resposta.statusCode != 200) {
      return null;
    }

    //print('Status: ${resposta.body}');

    Map responseDecode = json.decode(resposta.body);

    return responseDecode;
  }

  static Future<dynamic> capturarPagamento(String acessToken, String orderNumber) async {
    Map<String, String> headers = {
      "Authorization": "Bearer $acessToken",
      "Content-Type": "application/json",
    };

    var url_cielo = "https://cieloecommerce.cielo.com.br/api/public/v2/orders/$orderNumber/capture";

    print(url_cielo);

    var resposta = await http.put(url_cielo, headers: headers);

    if (resposta.statusCode != 200) {
      return null;
    }

    Map responseDecode = json.decode(resposta.body);

    return responseDecode;
  }

  static Future<dynamic> getOrder(String acessToken, String orderNumber) async {
    Map<String, String> headers = {
      "Authorization": "Bearer $acessToken",
      "Content-Type": "application/json",
    };

    var url_cielo = "https://cieloecommerce.cielo.com.br/api/public/v2/orders/$orderNumber";

    print(url_cielo);

    var resposta = await http.get(url_cielo, headers: headers);

    if (resposta.statusCode != 200) {
      return null;
    }

    Map responseDecode = json.decode(resposta.body);

    return responseDecode;
  }

  static Future<dynamic> salvarDados(String idLink, String orcamento) async {
    Map params = {
      'APP': 'SUPER LINK',
      'CODUSER': '002291 ',
      'CODFILIAL': '0101',
      'CODORCAMENTO': orcamento,
      'ID_SUPERLINK': idLink,
    };

    var url_chico_cielo =
        "$globalurl/rest/ORCAMENTO/SUPERLINK?APP=${params['APP']}&CODUSER=${params['CODUSER']}&ID_SUPERLINK=${params['ID_SUPERLINK']}&CODFILIAL=${params['CODFILIAL']}&CODORCAMENTO=${params['CODORCAMENTO']}";

    print(url_chico_cielo);
    var resposta = await http.post(url_chico_cielo);

    if (resposta.statusCode != 200) {
      return null;
    }

    Map responseDecode = json.decode(resposta.body);

    print(responseDecode);

    return responseDecode;
  }

  static Future<dynamic> atualizarDados(String idLink, String orcamento, String stLink, String orderLink,
      String nsuLink, String authLink, String parcLink, String bandLink) async {
    try {
      Map params = {
        'APP': '',
        'CODUSER': '',
        'CODFILIAL': '',
        'CODORCAMENTO': orcamento,
        'ID_SUPERLINK': idLink,
        'ST_SUPERLINK': stLink,
        "ORDER_SUPERLINK": orderLink,
        'NSU_SUPERLINK': nsuLink,
        'AUTORIZACAO_SUPERLINK': authLink,
        'PARCELA_SUPERLINK': parcLink,
        'BANDEIRA_SUPERLINK': bandLink,
      };

      print('oxijxi');

      var url_chico_cielo = "$globalurl/rest/ORCAMENTO/SUPERLINK?APP=${params['APP']}&CODUSER=${params['CODUSER']}" +
          "&CODFILIAL=${params['CODFILIAL']}&CODORCAMENTO=${params['CODORCAMENTO']}&ID_SUPERLINK=${params['ID_SUPERLINK']}" +
          "&ST_SUPERLINK=${params['ST_SUPERLINK']}&ORDER_SUPERLINK=${params['ORDER_SUPERLINK']}" +
          "&NSU_SUPERLINK=${params['NSU_SUPERLINK']}&AUTORIZACAO_SUPERLINK=${params['AUTORIZACAO_SUPERLINK']}" +
          "&PARCELA_SUPERLINK=${params['PARCELA_SUPERLINK']}&BANDEIRA_SUPERLINK=${params['BANDEIRA_SUPERLINK']}";

      print(url_chico_cielo);

      var resposta = await http.put(url_chico_cielo);

      if (resposta.statusCode != 200) {
        return null;
      }

      Map responseDecode = json.decode(resposta.body);

      return responseDecode;
    } catch (error) {
      print(error);
    }
  }

  static Future<List<DadosLink>> getDados(String orcamento, String filial) async {
    Map params = {
      'APP': 'SUPER LINK',
      'CODUSER': '002291',
      'CODFILIAL': '$filial',
      'CODORCAMENTO': orcamento,
    };

    var url_cielo = "$globalurl/rest/ORCAMENTO/SUPERLINK?APP=${params['APP']}&CODUSER=${params['CODUSER']}" +
        "&CODFILIAL=${params['CODFILIAL']}&CODORCAMENTO=${params['CODORCAMENTO']}";

    print(url_cielo);

    var resposta = await http.get(url_cielo);

    if (resposta.statusCode != 200) {
      return null;
    }

    List dadosList = json.decode(resposta.body);

    final dados = List<DadosLink>();

    for (Map map in dadosList) {
      DadosLink a = DadosLink.fromJson(map);
      dados.add(a);
    }

    return dados;
  }

  // ignore: non_constant_identifier_names
  static Future<String> getCredenciais({@required String filial_link}) async {
    Map params = {
      'APP': 'SUPER LINK',
      'CODUSER': '002291 ',
      'CODFILIAL': '0101',
    };

    String clientID;
    String clientSe;

    var url_filial =
        "$globalurl/rest/ADMIN/FILIAIS?APP=${params['APP']}&CODUSER=${params['CODUSER']}&CODFILIAL=${params['CODFILIAL']}";

    print(url_filial);

    var resposta = await http.get(url_filial);

    if (resposta.statusCode != 200) {
      return null;
    }

    List filiais = json.decode(resposta.body);

    final filial = List<Filial>();

    for (Map map in filiais) {
      Filial a = Filial.fromJson(map);
      filial.add(a);
    }

    for (int k = 0; k < filial.length; k++) {
      if (filial[k].codigo == filial_link) {
        clientID = filial[k].cieloSuperLink[0].id;
        clientSe = filial[k].cieloSuperLink[0].clientSecret;
      }
    }

    if (clientID == null) {
      return 'ERRO';
    }

    var emutf8 = utf8.encode('$clientID:$clientSe');
    var base = base64.encode(emutf8);

    return base;
  }

  static Future<dynamic> sendEmail(
      String assunto, String destino, String nome, String link, String filial) async {
    try {
      Map params = {
        'APP': 'SUPER LINK',
        'CODUSER': '002291',
        'CODFILIAL': '0101',
        'TOKEN': '',
        'ASSUNTO': "Orçamento $assunto",
        'DESTINATARIO': destino, //"franscicocardosonunes@gmail.com"
      };

      var url_banner = bannerFilial(filial);

      var a =
          "<body style='width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0;'> <div class='es-wrapper-color' style='background-color:#F6F6F6;'> <!--[if gte mso 9]><v:background xmlns:v='urn:schemas-microsoft-com:vml' fill='t'> <v:fill type='tile' color='#f6f6f6'></v:fill> </v:background><![endif]-->"
          "<table class='es-wrapper' width='100%' cellspacing='0' cellpadding='0' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;'> <tr style='border-collapse:collapse;'> <td valign='top' style='padding:0;Margin:0;'> <table class='es-header' cellspacing='0' cellpadding='0' align='center' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top;'> <tr style='border-collapse:collapse;'> <td align='center' style='padding:0;Margin:0;'>"
          "<table class='es-header-body' width='600' cellspacing='0' cellpadding='0' bgcolor='#ffffff' align='center' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;'> <tr style='border-collapse:collapse;'> <td align='left' style='padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px;'> <!--[if mso]><table width='560' cellpadding='0' cellspacing='0'><tr><td width='270' valign='top'><![endif]--> <table cellpadding='0' cellspacing='0' class='es-left' align='left' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left;'> <tr style='border-collapse:collapse;'> <td width='270' align='left' style='padding:0;Margin:0;'> <table width='100%' cellspacing='0' cellpadding='0' role='presentation' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'>"
          "<tr style='border-collapse:collapse;'> <td align='center' style='padding:0;Margin:0;font-size:0px;'><img class='adapt-img' src='https://carjas-s3-travel.s3.amazonaws.com/Logotipos/LogoCarajas.png' alt style='display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;' height='86'></td> </tr> </table></td> </tr> </table> <!--[if mso]></td><td width='20'></td><td width='270' valign='top'><![endif]--> <table cellpadding='0' cellspacing='0' class='es-right' align='right' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right;'> <tr style='border-collapse:collapse;'> <td width='270' align='left' style='padding:0;Margin:0;'> <table width='100%' cellspacing='0' cellpadding='0' role='presentation' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'> <tr class='es-mobile-hidden' style='border-collapse:collapse;'>"
          "<td align='center' class='es-m-txt-c' style='padding:0;Margin:0;font-size:0px;'><img src='https://carjas-s3-travel.s3.amazonaws.com/Logotipos/TeleVendas.png' alt style='display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;' width='121'></td> </tr> </table></td> </tr> </table> <!--[if mso]></td></tr></table><![endif]--></td> </tr> </table></td> </tr> </table> <table class='es-content' cellspacing='0' cellpadding='0' align='center' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;'> <tr style='border-collapse:collapse;'> <td align='center' style='padding:0;Margin:0;'> <table class='es-content-body' width='600' cellspacing='0' cellpadding='0' bgcolor='#ffffff' align='center' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;'>"
          "<tr style='border-collapse:collapse;'> <td align='left' style='padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px;'> <table width='100%' cellspacing='0' cellpadding='0' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'> <tr style='border-collapse:collapse;'> <td width='560' valign='top' align='center' style='padding:0;Margin:0;'> <table width='100%' cellspacing='0' cellpadding='0' role='presentation' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'> <tr style='border-collapse:collapse;'> <td align='left' style='padding:5px;Margin:0;'><p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:28px;color:#333333;'>Olá, <strong>$nome </strong>Estamos Quase Lá!</p></td> </tr>"
          "<tr style='border-collapse:collapse;'> <td align='left' class='es-m-txt-l' style='padding:5px;Margin:0;'><p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:28px;color:#333333;'>Número Do Orçamento:&nbsp;<strong>$assunto</strong><br>Para Finalizar Seu Orçamento, Favor realizar o pagamento atravez do Link abaixo<br><br><a href='$link' style='-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:14px;text-decoration:none;color:#0DD22A;'>$link</a><br><br>Vocé Pode Ver Um Video de Demonstração para o pagamento logo abaixo<br>"
          "<a href='https://carjas-s3-travel.s3.amazonaws.com/Videos/LINK_PAGAMENTO.mp4' style='-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:14px;text-decoration:none;color:#0DD22A;'>https://carjas-s3-travel.s3.amazonaws.com/Videos/LINK_PAGAMENTO.mp4</a><br><br></p></td> </tr> <tr style='border-collapse:collapse;'> <td align='left' style='padding:5px;Margin:0;'><p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:28px;color:#333333;'>A Carajás, Agradece Sua Preferencia!<br><br>Todos os seus dados estão seguros na Carajás!<br>Carajás Aqui o importante é você!</p></td> </tr> <tr style='border-collapse:collapse;'> <td align='left' style='padding:5px;Margin:0;'>"
          "<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:28px;color:#333333;'><strong>Atenção:</strong> Esta é uma mensagem automática, não é necessária respondê-la.</p></td> </tr> </table></td> </tr> </table></td> </tr> </table></td> </tr> </table> <table class='es-footer' cellspacing='0' cellpadding='0' align='center' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top;'> <tr style='border-collapse:collapse;'> <td align='center' style='padding:0;Margin:0;'>"
          "<table class='es-footer-body' width='600' cellspacing='0' cellpadding='0' bgcolor='#ffffff' align='center' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;'> <tr style='border-collapse:collapse;'> <td align='left' style='Margin:0;padding-top:20px;padding-bottom:20px;padding-left:20px;padding-right:20px;'> <!--[if mso]><table width='560' cellpadding='0' cellspacing='0'><tr><td width='270' valign='top'><![endif]--> <table class='es-left' cellspacing='0' cellpadding='0' align='left' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left;'> <tr style='border-collapse:collapse;'> <td class='es-m-p20b' width='270' align='left' style='padding:0;Margin:0;'> <table width='100%' cellspacing='0' cellpadding='0' role='presentation' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'>"
          "<tr style='border-collapse:collapse;'> <td align='center' style='padding:0;Margin:0;font-size:0px;'><img class='adapt-img' src='https://carjas-s3-travel.s3.amazonaws.com/Logotipos/SuperLink.png' alt style='display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;' height='57'></td> </tr> </table></td> </tr> </table> <!--[if mso]></td><td width='20'></td><td width='270' valign='top'><![endif]--> <table class='es-right' cellspacing='0' cellpadding='0' align='right' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right;'> <tr style='border-collapse:collapse;'> <td width='270' align='left' style='padding:0;Margin:0;'> <table width='100%' cellspacing='0' cellpadding='0' role='presentation' style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'> <tr style='border-collapse:collapse;'>"
          "<td align='center' style='padding:0;Margin:0;font-size:0px;'><img class='adapt-img' src='$url_banner' alt style='display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;' width='270'></td> </tr> </table></td> </tr> </table> <!--[if mso]></td></tr></table><![endif]--></td> </tr> </table></td> </tr> </table></td> </tr> </table> </div> </body>"; //SENDMAIL/ENVIAR/{CODUSER}{APP}{CODFILIAL}{TOKEN}{ASSUNTO}{HTML}{DESTINATARIO}

      print(a);
      var url =
          '$globalurl/rest/SENDMAIL/ENVIAR?APP=${params['APP']}&CODUSER=${params['CODUSER']}&CODFILIAL=${params['CODFILIAL']}&TOKEN=&ASSUNTO=${params['ASSUNTO']}&DESTINATARIO=${params['DESTINATARIO']}';

      print(' enviarEmail >>>>>>>>>>>  $url');

      var response = await http.post(url, body: a);

      print(response.body);

      return response;
    } catch (error) {
      print(error);
    }
  }
}

bannerFilial(String filial) {
  if (filial == '0101') {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/MACEIO.png";
  } else if (filial == '0103') {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/ARAPIRACA.png";
  } else if (filial == '0104') {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/JOAOPESSOA.png";
  } else if (filial == '0106') {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/CAMPINAGRANDE.png";
  } else if (filial == '0107') {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/NATAL.png";
  } else if (filial == '0108') {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/CABEDELO.png";
  } else if (filial == '0109') {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/FORTALEZA.png";
  } else if (filial == '0110') {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/JUAZEIRO.png";
  } else {
    return "https://carjas-s3-travel.s3.amazonaws.com/Banners/TeleVendas/MACEIO.png";
  }
}
