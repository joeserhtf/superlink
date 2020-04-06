class Filial {
  String codigo;
  String habilitadaAPP;
  String uf;
  String sigla;
  String nome;
  String cnpjEmpresa;
  String ieEmpresa;
  String grupoEmpresas;
  String enderecoEmpresa;
  String cidadeEmpresa;
  String ufEmpresa;
  String bairroEmpresa;
  String cepEmpresa;
  String vendedorWeb;
  List<CieloSuperLink> cieloSuperLink;

  Filial(
      {this.codigo,
        this.habilitadaAPP,
        this.uf,
        this.sigla,
        this.nome,
        this.cnpjEmpresa,
        this.ieEmpresa,
        this.grupoEmpresas,
        this.enderecoEmpresa,
        this.cidadeEmpresa,
        this.ufEmpresa,
        this.bairroEmpresa,
        this.cepEmpresa,
        this.vendedorWeb,
        this.cieloSuperLink});

  Filial.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    habilitadaAPP = json['habilitadaAPP'];
    uf = json['uf'];
    sigla = json['sigla'];
    nome = json['nome'];
    cnpjEmpresa = json['cnpjEmpresa'];
    ieEmpresa = json['ieEmpresa'];
    grupoEmpresas = json['grupoEmpresas'];
    enderecoEmpresa = json['enderecoEmpresa'];
    cidadeEmpresa = json['cidadeEmpresa'];
    ufEmpresa = json['ufEmpresa'];
    bairroEmpresa = json['bairroEmpresa'];
    cepEmpresa = json['cepEmpresa'];
    vendedorWeb = json['vendedorWeb'];
    if (json['cieloSuperLink'] != null) {
      cieloSuperLink = new List<CieloSuperLink>();
      json['cieloSuperLink'].forEach((v) {
        cieloSuperLink.add(new CieloSuperLink.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['habilitadaAPP'] = this.habilitadaAPP;
    data['uf'] = this.uf;
    data['sigla'] = this.sigla;
    data['nome'] = this.nome;
    data['cnpjEmpresa'] = this.cnpjEmpresa;
    data['ieEmpresa'] = this.ieEmpresa;
    data['grupoEmpresas'] = this.grupoEmpresas;
    data['enderecoEmpresa'] = this.enderecoEmpresa;
    data['cidadeEmpresa'] = this.cidadeEmpresa;
    data['ufEmpresa'] = this.ufEmpresa;
    data['bairroEmpresa'] = this.bairroEmpresa;
    data['cepEmpresa'] = this.cepEmpresa;
    data['vendedorWeb'] = this.vendedorWeb;
    if (this.cieloSuperLink != null) {
      data['cieloSuperLink'] =
          this.cieloSuperLink.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CieloSuperLink {
  String id;
  String clientSecret;

  CieloSuperLink({this.id, this.clientSecret});

  CieloSuperLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientSecret = json['clientSecret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['clientSecret'] = this.clientSecret;
    return data;
  }
}
