# Superlink

Pacote Para Auxilio SuperLink

## Uso

dev_dependencies:

superlink:
    path: ../superlink

import 'package:superlink/superlink.dart';

var status = await StatusLink(filial: '{codFilial}', codOrc: '{CodOrc}');

var novo = await GerarLink(codOrc: '{CodOrc}',filial: '{codFilial}',parcelasLink: {int},valorOrc: '{ValorORc}');

## Status{
	Cod --------------- Descrição
	0   --------------- Link Não Criado
	1   --------------- Link Pago
	2   --------------- Link Ativo Sem Vencimento
	3   --------------- Link Ativo Com Vencimento
	4   --------------- Link Expirado/Vencido
	5   --------------- Link Autorizado
	6   --------------- Link Com Pagamento Negado
}

## Respota Do Status
	{
        'Status': '0',
        "Info": {
          "Link": '',
          "IdLink": '',
          "OrderNumber": '',
          "Vencimento": '',
          "StatusPagamento": '',
          "DataPagamento": '',
          "Parcelas": '',
          "Valor": '',
        }
}

## Respota Do Gerarl Link Com Erro
	{
      'Status': 'Error',
      "Info": fullLink["Body"],
    }


## Respota Do Gerarl Link Okay
	{
      'Status': 'Criado',
      "Info": {
        "Link": '${fullLink['shortUrl']}',
        "IdLink": '${fullLink['id']}',
        "Vencimento": '${fullLink['expirationDate']}',
        "Parcelas": '${fullLink['maxNumberOfInstallments']}',
        "Valor": '${fullLink['price']}',
      }
   }
