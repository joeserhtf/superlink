class DadosLink {
  String filial;
  String orcamento;
  String id;
  String status;
  String dataInclusao;
  String dataAlteracao;
  String usrInclusao;
  String usrAlteracao;
  String order;
  String nSU;
  String autorizacao;
  String parcela;
  String bandeira;

  DadosLink(
      {this.filial,
        this.orcamento,
        this.id,
        this.status,
        this.dataInclusao,
        this.dataAlteracao,
        this.usrInclusao,
        this.usrAlteracao,
        this.order,
        this.nSU,
        this.autorizacao,
        this.parcela,
        this.bandeira});

  DadosLink.fromJson(Map<String, dynamic> json) {
    filial = json['filial'];
    orcamento = json['orcamento'];
    id = json['id'];
    status = json['status'];
    dataInclusao = json['dataInclusao'];
    dataAlteracao = json['dataAlteracao'];
    usrInclusao = json['usrInclusao'];
    usrAlteracao = json['usrAlteracao'];
    order = json['order'];
    nSU = json['NSU'];
    autorizacao = json['autorizacao'];
    parcela = json['parcela'];
    bandeira = json['bandeira'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filial'] = this.filial;
    data['orcamento'] = this.orcamento;
    data['id'] = this.id;
    data['status'] = this.status;
    data['dataInclusao'] = this.dataInclusao;
    data['dataAlteracao'] = this.dataAlteracao;
    data['usrInclusao'] = this.usrInclusao;
    data['usrAlteracao'] = this.usrAlteracao;
    data['order'] = this.order;
    data['NSU'] = this.nSU;
    data['autorizacao'] = this.autorizacao;
    data['parcela'] = this.parcela;
    data['bandeira'] = this.bandeira;
    return data;
  }
}
