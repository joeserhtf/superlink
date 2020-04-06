library superlink;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:superlink/link/dados_class.dart';
import 'package:superlink/link/link_g.dart';

Future GerarLink({
  @required String valorOrc,
  @required String codOrc,
  @required int parcelasLink,
  @required String filial,
}) async {

  //Pega Data Atual
  var hoje = new DateTime.now();

  //Valida Proximo Dia
  var amanha = hoje.add(new Duration(days: 1));

  //Formata Data Para Cielo
  var formatter = new DateFormat('yyyy-MM-dd');

  //Formata Valor
  final formatterR = NumberFormat.simpleCurrency(locale: "pt_Br");

  //Uso Formatação
  String vencimento = formatter.format(amanha);

  //Transformação Valor Para Centavaos
  var valorcent = (double.parse(valorOrc) * 100).roundToDouble();

  //Gerar Base
  var base = await CieloApi.getCredenciais(filial_link: filial);

  //Gerar AcessToken
  var acesstoken = await CieloApi.gerarAuth(base);

  //Gerar Link
  var fullLink = await CieloApi.gerarLink(codOrc, valorcent, acesstoken, parcelasLink, vencimento);

  //Salvar Informaçoes Do Link Na Base Local
  var dados = await CieloApi.salvarDados(fullLink['id'], codOrc);
  print(dados);

  if(fullLink['id'] == "Error"){
    return {
      'STATUS': 'Error',
      "INFO": fullLink["Body"],
    };
  }else {
    return {
      'STATUS': 'Criado',
      "INFO": {
        "LINK": '${fullLink['shortUrl']}',
        "IdLink": '${fullLink['id']}',
        "Vencimento": '${fullLink['expirationDate']}',
        "Parcelas": '${fullLink['maxNumberOfInstallments']}',
        "Valor": '${fullLink['price']}',
      }
    };
  }
}

Future StatusLink({@required String filial, @required String codOrc}) async {
  //Gerar Base Variando da Filial
  var base = await CieloApi.getCredenciais(filial_link: filial);

  print('Base:   ' + base);

  if (base == 'ERRO') {
    print('Nao Foi possivel pegar base');
  } else {
    //Gerar Token para filial Selecionada
    var acesstoken = await CieloApi.gerarAuth(base);
    print('AcessToken: ' + acesstoken);

    //Verificar Existencia De Registo De link Para Orçamento Selecionado
    List<DadosLink> dadosSalvos = await CieloApi.getDados(codOrc, filial);

    //Validar Exitencia E Chechar Informaçoes Do Link Na Cielo
    var id = dadosSalvos.isEmpty ? 'Z' : dadosSalvos[0].id;

    if (id == 'Z') {
      return {
        'STATUS': '0',
        "INFO": {
          "LINK": '',
          "IdLink": '',
          "OrderNumber": '',
          "Vencimento": '',
          "StatusPagamento": '',
          "DataPagamento": '',
          "Parcelas": '',
          "Valor": '',
        }
      };
    }

    var verlink = await CieloApi.verStatus(acesstoken, id, verLink: true);

    //Verifiar Se Foi Relizado Tentativa de Pagamento
    var status = await CieloApi.verStatus(acesstoken, id);

    //Salvar Dados Da Api Local Para Comparação
    var statusLocal = dadosSalvos.isEmpty ? "" : dadosSalvos[0].status;

    //Verifica A Data Limite Para Expirar o Link
    var expiDate;
    if (verlink != null) {
      if (verlink["expirationDate"] != null) {
        expiDate = DateTime.parse(verlink["expirationDate"].replaceAll('T', ' ')).millisecondsSinceEpoch;
      }
    }

    int caso = 0;
    //Existe Status De Pagamento
    if (status != null) {
      //Confirma Se foi Realizado Tentativa De Pagamento
      if (status["orders"].isEmpty) {
        //Check Se Link Esta Expirado
        if (expiDate != null) {
          //Link Ativo
          if (expiDate > DateTime.now().millisecondsSinceEpoch) {
            caso = 3; //Nao vencido
            //Link Vencido
          } else {
            caso = 4; // Vencido
          }
          //Vencimento Indeterminado
        } else {
          caso = 2; // Sem vencimento
        }

        //Tentativa de Pagamento Realizada
      } else {
        //Compara Status Local Com Status Cielo
        if (statusLocal != status["orders"][0]["payment"]["status"]) {
          //Caso Verdade Atualiza Banco Local
          _salvarDados(acesstoken, status["orders"][0]["orderNumber"], status["productId"], codOrc);
        }

        //Caso Link Tenha Sido Pago
        if (status["orders"][0]["payment"]["status"] == "Paid") {
          caso = 1; //Pago
        } else if (status["orders"][0]["payment"]["status"] == "Authorized") {
          //Pagamento Autorizado Para ser Feito Captura
          _capturarPagamento(acesstoken, status["orders"][0]["orderNumber"], verlink["id"], codOrc);
          caso = 5; //Autorizado
        } else {
          //Tentativa De pagamento Negado
          caso = 6; //Negada
        }
      }
    } else {
      //Link Não Gerado
      caso = 0;
    }

    return {
      'STATUS': '$caso',
      "INFO": {
        "LINK": '${verlink['shortUrl'] ?? ''}',
        "IdLink": '${verlink['id'] ?? ''}',
        "OrderNumber": '${status["orders"].isEmpty ? '' : status["orders"][0]["orderNumber"]}',
        "Vencimento": '${verlink["expirationDate"] ?? ''}',
        "StatusPagamento": '${status["orders"].isEmpty ? '' : status["orders"][0]["payment"]["status"]}',
        "DataPagamento": '${status["orders"].isEmpty ? '' : status["orders"][0]["payment"]["createdDate"]}',
        "Parcelas": '${status["orders"].isEmpty ? '' : status["orders"][0]["payment"]["numberOfPayments"]}',
        "Valor": '${verlink['price']/100 ?? ''}',
      }
    };
  }
}

void _salvarDados(String acessToken, String orderNumber, String idLink, String codOrc) async {
  var info = await CieloApi.getOrder(acessToken, orderNumber);
  var dadosSalvos = await CieloApi.atualizarDados(
      idLink.toString(),
      codOrc,
      info["payment"]["status"].toString(),
      info["orderNumber"].toString(),
      info["payment"]["nsu"].toString(),
      info["payment"]["authorizationCode"].toString(),
      info["payment"]["numberOfPayments"].toString(),
      info["payment"]["brand"].toString());
}

void _capturarPagamento(acesstoken, ordernumber, String idLink, String codOrc) async {
  var cap = await CieloApi.capturarPagamento(acesstoken, ordernumber);
  if (cap["success"]) {
    _salvarDados(acesstoken, ordernumber, idLink, codOrc);
  } else {
    //Informar erro
  }
}

