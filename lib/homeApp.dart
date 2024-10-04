import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluid_kit/fluid_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_context_menu_ng/native_context_menu_widget.dart';
import 'package:native_context_menu_ng/native_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilant/FirebaseHost.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/botaoDireito.dart';
import 'package:vigilant/getIds.dart';
import 'package:vigilant/intRamdom/intRamdom.dart';
import 'package:vigilant/login/login.dart';
import 'package:vigilant/libDePessoas/cadastroDeUsuariosNoEquipamento.dart';
import 'package:vigilant/libDePessoas/pushPessoas.dart';
import 'package:vigilant/videoStream/videoStreamWidget.dart';
import 'package:vigilant/voip/voipAPI.dart';
import 'package:uuid/uuid.dart';

//Desenvolvido por HeroRickyGames com ajuda de Deus!

//Strings
String ip = '';
String user = "";
String pass = "";
String anotacao = "";
String idCondominio = "";
String idCondominioAnt = "";
String imageURL = "";
String imageURLMorador = "";
String NomeMorador = "";
String RGMorador = "";
String CPFMorador = "";
String PlacaMorador = "";
String TelefoneMorador = "";
String CelularMorador = "";
String MoradorId = "";
String UnidadeMorador = "";
String BlocoMorador = "";
String ModeloDoCFTV = "";

//Strings de Pesquisa
String pesquisa = '';
String pesquisa2 = '';
String pesquisa3 = '';
String pesquisa4 = '';
String pesquisa5 = '';
String pesquisa6 = '';
String pesquisa7 = '';
String pesquisa8 = '';
String pesquisa9 = '';
String pesquisa10 = '';
String EmpresaPertence = "";

//Controladores
TextEditingController anotacaoControlCondominio = TextEditingController(text: anotacao);

//Booleanos
bool pesquisaNumeros = false;
bool acionamento1clicado = false;
bool inicializado = false;
bool pesquisaCPF = false;
bool pesquisando = false;
bool pesquisando2 = false;
bool pesquisando3 = false;
bool pesquisando4 = false;
bool pesquisando5  = false;
bool pesquisando6  = false;
bool pesquisando7  = false;
bool pesquisando8  = false;
bool pesquisando9  = false;
bool pesquisando10  = false;
bool showSearchBar = false;
bool showSearchBar2 = false;

//Booleanos de controle dos usuarios
bool AdicionarCondominios = false;
bool AdicionarAcionamentos = false;
bool adicionarMoradores = false;
bool adicionarRamal = false;
bool adicionarUsuarios = false;
bool editarAnotacao = false;
bool permissaoCriarUsuarios = false;
bool adicionarVeiculo = false;
bool adicionarVisitante = false;
bool EditarCFTV = false;
bool acessoDevFunc = false;
bool deslogando = false;

//Inteiros
int porta = 00;
int? camera1;
int? camera2;
int? camera3;
int? camera4;
int? camera5;
int? camera6;
int? camera7;
int? camera8;
int? camera9;

//DropDownValues
var dropValue = ValueNotifier('');

//Cores
Color colorBtn = Colors.blue;
Color colorBtnFab = Colors.blue;
Color corDasBarras = Colors.transparent;
Color textColor = Colors.white;
Color textColorWidgets = Colors.black;
Color textColorFab = Colors.white;
Color textColorDrop = Colors.white;
Color textAlertDialogColor = Colors.black;
Color textAlertDialogColorReverse = Colors.white;
Color textColorInitBlue = Colors.white;

//Listas
List ModelosAcionamentos = [
  "Intelbras",
  "Control iD",
  "Hikvision",
  "Modulo Guarita (Nice)",
];

List ImportarUsuarios = [
  "Control iD",
  'Hikvision',
  "Outros",
];

List ModelosdeCFTV = [
  "Intelbras",
  "Hikvision",
];

//doubles
double topbot = 7.5;

class homeApp extends StatefulWidget {
  const homeApp({super.key});

  @override
  State<homeApp> createState() => _homeAppState();
}

class _homeAppState extends State<homeApp>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Pega todas as permissões do usuario
    checkarAsPermissoes() async {
      try{
        await Future.delayed(const Duration(seconds: 1));
        var getUserPermissions = await FirebaseFirestore.instance
            .collection("Users")
            .doc(UID).get();

        setState(() {
          AdicionarCondominios = getUserPermissions['AdicionarCondominios'];
          AdicionarAcionamentos = getUserPermissions['adicionaAcionamentos'];
          adicionarRamal = getUserPermissions['adicionarRamal'];
          adicionarUsuarios = getUserPermissions['adicionarUsuarios'];
          adicionarMoradores = getUserPermissions['adicionarMoradores'];
          editarAnotacao = getUserPermissions['editarAnotacao'];
          permissaoCriarUsuarios = getUserPermissions['permissaoCriarUsuarios'];
          adicionarVeiculo = getUserPermissions['adicionarVeiculo'];
          adicionarVisitante = getUserPermissions['adicionarVisitante'];
          acessoDevFunc = getUserPermissions['acessoDevFunc'];
          EditarCFTV = getUserPermissions['editarCFTV'];
          EmpresaPertence = getUserPermissions['idEmpresaPertence'];
          //Setar a inicialização
          inicializado = true;
        });
      }catch(e){
        checkarAsPermissoes();
      }
    }
    if(deslogando == false){
      if(inicializado == false){
        checkarAsPermissoes();
      }
    }

    return LayoutBuilder(builder: (context, constrains){
      double wid = constrains.maxWidth;
      double heig = constrains.maxHeight;



      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: wid,
              height: heig,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/FundoMetalPrata.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  //UI começa aqui!
                  SizedBox(
                    width: wid,
                    height: heig,
                    child: Row(
                      children: [
                        StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                          return SizedBox(
                            width: wid / 4,
                            height: heig,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Image.asset(
                                        "assets/vigilantLogo.png",
                                        scale: 20
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/fundoWidgetContainerMain.png'),
                                        fit: BoxFit.cover,
                                      ),

                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: wid / 4,
                                          height: heig / 1.7,
                                          child: Stack(
                                              children: [
                                                Center(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: heig / 1.7,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.blue,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.all(10),
                                                                child: Stack(
                                                                  children: [
                                                                    TextField(
                                                                      cursorColor: Colors.black,
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        pesquisa = value;

                                                                        if(value == ""){
                                                                          setStater((){
                                                                            pesquisa = value;
                                                                            pesquisando = false;
                                                                            pesquisaNumeros = false;
                                                                          });
                                                                        }

                                                                      },
                                                                      decoration: const InputDecoration(
                                                                        filled: true,
                                                                        fillColor: Colors.white,
                                                                        border: OutlineInputBorder(),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(width: 3, color: Colors.white), //<-- SEE HERE
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width: 3,
                                                                              color: Colors.black
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      style: const TextStyle(
                                                                          color: Colors.black
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      alignment: AlignmentDirectional.centerEnd,
                                                                      child: TextButton(
                                                                        onPressed: (){

                                                                          RegExp numeros = RegExp(r'[0-9]');

                                                                          if(numeros.hasMatch(pesquisa)){
                                                                            setStater(() {
                                                                              pesquisaNumeros = true;
                                                                            });
                                                                          }else{
                                                                            setStater(() {
                                                                              pesquisaNumeros = false;
                                                                            });
                                                                          }

                                                                          if(pesquisa == ""){
                                                                            setStater(() {
                                                                              pesquisando = false;
                                                                            });
                                                                          }else{
                                                                            setStater(() {
                                                                              pesquisando = true;
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Image.asset(
                                                                            "assets/search.png",
                                                                            scale: 14
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              StreamBuilder(
                                                                stream: pesquisando == true ?
                                                                pesquisaNumeros == false ? FirebaseFirestore.instance
                                                                    .collection("Condominios")
                                                                    .where("idEmpresaPertence", isEqualTo: EmpresaPertence)
                                                                    .where("Nome", isGreaterThanOrEqualTo: pesquisa)
                                                                    .where("Nome", isLessThan: "${pesquisa}z")
                                                                    .snapshots()
                                                                    :
                                                                FirebaseFirestore.instance
                                                                    .collection("Condominios")
                                                                    .where("idEmpresaPertence", isEqualTo: EmpresaPertence)
                                                                    .where("Codigo", isGreaterThanOrEqualTo: pesquisa)
                                                                    .where("Codigo", isLessThan: "${pesquisa}9")
                                                                    .snapshots()
                                                                    :
                                                                FirebaseFirestore.instance
                                                                    .collection("Condominios")
                                                                    .where("idEmpresaPertence", isEqualTo: EmpresaPertence)
                                                                    .snapshots(),
                                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                                                                  if (!snapshot.hasData) {
                                                                    return const Center(
                                                                      child: CircularProgressIndicator(),
                                                                    );
                                                                  }

                                                                  return SizedBox(
                                                                    width: double.infinity,
                                                                    height: heig / 2.2,
                                                                    child: ListView(
                                                                      children: snapshot.data!.docs.map((documents){
                                                                        return SizedBox(
                                                                          width: wid / 4,
                                                                          height: 70,

                                                                          child: InkWell(
                                                                            onTap: () async {
                                                                              setState(() {
                                                                                ip = documents["IpCamera"];
                                                                                user = documents["UserAccess"];
                                                                                pass = documents["PassAccess"];
                                                                                porta = documents["PortaCameras"];
                                                                                idCondominio = documents["idCondominio"];
                                                                                anotacao = documents["Aviso"];
                                                                                ModeloDoCFTV = documents['ipCameraModelo'];
                                                                                idCondominioAnt = documents["idCondominio"];
                                                                                anotacao = documents["Aviso"];
                                                                                anotacaoControlCondominio.text = anotacao;
                                                                              });

                                                                              var getIpCameraSettings = await FirebaseFirestore.instance
                                                                                  .collection("Condominios")
                                                                                  .doc(idCondominio).get();
                                                                              setState((){
                                                                                CFTV = 0;
                                                                                camera1 = getIpCameraSettings["ipCamera1"];
                                                                                camera2 = getIpCameraSettings["ipCamera2"];
                                                                                camera3 = getIpCameraSettings["ipCamera3"];
                                                                                camera4 = getIpCameraSettings["ipCamera4"];
                                                                                camera5 = getIpCameraSettings["ipCamera5"];
                                                                                camera6 = getIpCameraSettings["ipCamera6"];
                                                                                camera7 = getIpCameraSettings["ipCamera7"];
                                                                                camera8 = getIpCameraSettings["ipCamera8"];
                                                                                camera9 = getIpCameraSettings["ipCamera9"];
                                                                                isStarted = true;
                                                                              });
                                                                            },
                                                                            child: Stack(
                                                                              children: [
                                                                                FutureBuilder<NativeMenu>(
                                                                                  future: initMenuCondominio(),
                                                                                  builder: (BuildContext context, AsyncSnapshot<NativeMenu> snapshot){

                                                                                    if (!snapshot.hasData) {
                                                                                      return const Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                      );
                                                                                    }

                                                                                    return SizedBox(
                                                                                      width: wid / 4,
                                                                                      child: NativeContextMenuWidget(
                                                                                        actionCallback: (action) {
                                                                                          if(action == "editCondominio"){

                                                                                            String NomeCondominio = documents["Nome"];
                                                                                            String IPCameras = documents["IpCamera"];
                                                                                            int PortaCameras = documents["PortaCameras"];
                                                                                            String UserAccess = documents["UserAccess"];
                                                                                            String Cidade = documents["Cidade"];
                                                                                            String Endereco = documents["Endereco"];
                                                                                            String bairro = documents["bairro"];
                                                                                            String cep = documents["cep"];
                                                                                            String Sindico = documents["Sindico"];
                                                                                            String Telefone = documents["Telefone"];
                                                                                            String CNPJ = documents["CNPJ"];
                                                                                            String Zelador = documents["Zelador"];
                                                                                            String PassAccess = documents["PassAccess"];
                                                                                            String SIPUrl = documents["SIPUrl"];
                                                                                            String Porta = documents["PortaSIP"];
                                                                                            String AuthUser = documents["authUserSIP"];
                                                                                            String Pass = documents["PassAccess"];
                                                                                            String codigo = documents["Codigo"];
                                                                                            String modeloselecionado = documents["ipCameraModelo"];
                                                                                            var dropValue2 = ValueNotifier(modeloselecionado);

                                                                                            //Controladores
                                                                                            TextEditingController NomeCondominioControl = TextEditingController(text: NomeCondominio);
                                                                                            TextEditingController IPCamerasControl = TextEditingController(text: IPCameras);
                                                                                            TextEditingController CidadeControl = TextEditingController(text: Cidade);
                                                                                            TextEditingController EnderecoControl = TextEditingController(text: Endereco);
                                                                                            TextEditingController bairroControl = TextEditingController(text: bairro);
                                                                                            TextEditingController cepControl = TextEditingController(text: cep);
                                                                                            TextEditingController SindicoControl = TextEditingController(text: Sindico);
                                                                                            TextEditingController TelefoneControl = TextEditingController(text: Telefone);
                                                                                            TextEditingController CNPJControl = TextEditingController(text: CNPJ);
                                                                                            TextEditingController ZeladorControl = TextEditingController(text: Zelador);
                                                                                            TextEditingController PortaCamerasControl = TextEditingController(text: "$PortaCameras");
                                                                                            TextEditingController UserAccessControl = TextEditingController(text: UserAccess);
                                                                                            TextEditingController PassAccessControl = TextEditingController(text: PassAccess);
                                                                                            TextEditingController SIPUrlControl = TextEditingController(text: SIPUrl);
                                                                                            TextEditingController PortaSIPControl = TextEditingController(text: Porta);
                                                                                            TextEditingController AuthUserSIPControl = TextEditingController(text: AuthUser);
                                                                                            TextEditingController PassSIPControl = TextEditingController(text: Pass);
                                                                                            TextEditingController codigoControl = TextEditingController(text: codigo);

                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (BuildContext context) {
                                                                                                return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                                                  return SingleChildScrollView(
                                                                                                    child: Dialog(
                                                                                                      shape: RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                      ),
                                                                                                      child: Stack(
                                                                                                        children: [
                                                                                                          // Imagem de fundo
                                                                                                          Positioned.fill(
                                                                                                            child: ClipRRect(
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                              child: Image.asset(
                                                                                                                "assets/FundoMetalPreto.jpg",
                                                                                                                fit: BoxFit.fill,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            width: 700,
                                                                                                            padding: const EdgeInsets.all(30),
                                                                                                            child: Column(
                                                                                                              children: [
                                                                                                                Column(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    SizedBox(
                                                                                                                      //width: 200,
                                                                                                                      height: 50,
                                                                                                                      child: Center(
                                                                                                                        child: Row(
                                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                          children: [
                                                                                                                            const Text(
                                                                                                                              'Cadastro de Cliente',
                                                                                                                              style: TextStyle(
                                                                                                                                fontSize: 30,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            SizedBox(
                                                                                                                              width: 100,
                                                                                                                              height: 100,
                                                                                                                              child: TextButton(onPressed: (){
                                                                                                                                Navigator.pop(context);
                                                                                                                              }, child: const Center(
                                                                                                                                child: Icon(
                                                                                                                                  Icons.close,
                                                                                                                                  size: 40,
                                                                                                                                ),
                                                                                                                              )
                                                                                                                              ),
                                                                                                                            )
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    const Padding(
                                                                                                                      padding: EdgeInsets.only(bottom: 16),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: NomeCondominioControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              NomeCondominio = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Nome do Condominio',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: codigoControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              codigo = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Codigo do Condominio (4 caracteres Ex: 2402)',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: CidadeControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              Cidade = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Cidade',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: EnderecoControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              Endereco = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Endereco',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: bairroControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              bairro = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Bairro',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: cepControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              cep = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'CEP',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: SindicoControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              Sindico = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Sindico',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: TelefoneControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              Telefone = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Telefone',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: CNPJControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              CNPJ = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'CNPJ',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: ZeladorControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              Zelador = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Zelador',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Column(
                                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                        children: [
                                                                                                                          const Text('Modelo do CFTV:'),
                                                                                                                          ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
                                                                                                                            return DropdownButton(
                                                                                                                              hint: Text(
                                                                                                                                'Selecione o modelo',
                                                                                                                                style: TextStyle(
                                                                                                                                    color: textColorDrop
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              value: (value.isEmpty)? null : value,
                                                                                                                              onChanged: (escolha) async {
                                                                                                                                dropValue2.value = escolha.toString();
                                                                                                                                setStater(() {
                                                                                                                                  modeloselecionado = escolha.toString();
                                                                                                                                });
                                                                                                                              },
                                                                                                                              items: ModelosdeCFTV.map((opcao) => DropdownMenuItem(
                                                                                                                                value: opcao,
                                                                                                                                child:
                                                                                                                                Text(
                                                                                                                                  opcao,
                                                                                                                                  style: TextStyle(
                                                                                                                                      color: textColorDrop
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              ).toList(),
                                                                                                                            );
                                                                                                                          }),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: IPCamerasControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              IPCameras = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'URL do CFTV (RTSP)',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: PortaCamerasControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              PortaCameras = int.parse(value);
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Porta do CFTV (RTSP) (Normalmente é 554, mas pode variar dependendo do CFTV)',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: UserAccessControl ,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              UserAccess = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Usuario para acesso das cameras',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: PassAccessControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              PassAccess = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            labelText: 'Senha para acesso das cameras',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: SIPUrlControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              SIPUrl = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelText: 'SIP Url (sip2.chamada.com.br), para ambientes não suportado é recomendado deixar (*) apenas.',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: PortaSIPControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              Porta = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelText: 'SIP Porta (5060)',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: AuthUserSIPControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              AuthUser = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelText: 'Usuario de acesso do SIP',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: TextField(
                                                                                                                          controller: PassSIPControl,
                                                                                                                          keyboardType: TextInputType.emailAddress,
                                                                                                                          enableSuggestions: false,
                                                                                                                          autocorrect: false,
                                                                                                                          onChanged: (value){
                                                                                                                            setStater(() {
                                                                                                                              Pass = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            labelStyle: TextStyle(
                                                                                                                                color: textAlertDialogColor,
                                                                                                                                backgroundColor: Colors.white
                                                                                                                            ),
                                                                                                                            border: const OutlineInputBorder(),
                                                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                            ),
                                                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                                                              borderSide: BorderSide(
                                                                                                                                  width: 3,
                                                                                                                                  color: Colors.black
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            labelText: 'Senha de acesso do SIP',
                                                                                                                          ),
                                                                                                                          style: TextStyle(
                                                                                                                              color: textAlertDialogColor
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    ElevatedButton(onPressed: (){
                                                                                                                      if(NomeCondominio == ""){
                                                                                                                        showToast("O nome do Condominio está vazio!",context:context);
                                                                                                                      }else{
                                                                                                                        if(codigo == ""){
                                                                                                                          showToast("O codigo está vazio!",context:context);
                                                                                                                        }else{
                                                                                                                          if(codigo.length == 4){
                                                                                                                            if(IPCameras == ""){
                                                                                                                              showToast("A URL das Cameras está vazia!",context:context);
                                                                                                                            }else{
                                                                                                                              if(PortaCameras == null){
                                                                                                                                showToast("A Porta em RTSP das Cameras está vazia!",context:context);
                                                                                                                              }else{
                                                                                                                                if(UserAccess == ""){
                                                                                                                                  showToast("O Usuario para acesso das cameras está vazio!",context:context);
                                                                                                                                }else{
                                                                                                                                  if(PassAccess == ""){
                                                                                                                                    showToast("A Senha para acesso das cameras está vazia!",context:context);
                                                                                                                                  }else{
                                                                                                                                    FirebaseFirestore.instance.collection('Condominios').doc(documents["idCondominio"]).update({
                                                                                                                                      "idCondominio": documents["idCondominio"],
                                                                                                                                      "Nome": NomeCondominio,
                                                                                                                                      "IpCamera": IPCameras,
                                                                                                                                      "PortaCameras": PortaCameras,
                                                                                                                                      "UserAccess": UserAccess,
                                                                                                                                      "PassAccess": PassAccess,
                                                                                                                                      "SIPUrl": SIPUrl,
                                                                                                                                      "PortaSIP": Porta,
                                                                                                                                      "authUserSIP": AuthUser,
                                                                                                                                      "authSenhaSIP": Pass,
                                                                                                                                      "Codigo" : codigo,
                                                                                                                                      "ipCameraModelo": modeloselecionado,
                                                                                                                                      "Cidade": Cidade,
                                                                                                                                      "Endereco": Endereco,
                                                                                                                                      "bairro": bairro,
                                                                                                                                      "cep": cep,
                                                                                                                                      "Sindico": Sindico,
                                                                                                                                      "Telefone": Telefone,
                                                                                                                                      "CNPJ": CNPJ,
                                                                                                                                      "Zelador": Zelador,
                                                                                                                                    }).whenComplete(() {
                                                                                                                                      showToast('Sucesso!', context: context);
                                                                                                                                      Navigator.pop(context);
                                                                                                                                    });
                                                                                                                                  }
                                                                                                                                }
                                                                                                                              }
                                                                                                                            }
                                                                                                                          }else{
                                                                                                                            if(codigo.length > 4){
                                                                                                                              showToast("Existem mais caracteres do que o permitido no codigo do condominio!",context:context);
                                                                                                                            }
                                                                                                                            if(codigo.length < 4){
                                                                                                                              showToast("Existem menos caracteres do que o permitido no codigo do condominio!",context:context);
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }
                                                                                                                      }
                                                                                                                    },
                                                                                                                        style: ElevatedButton.styleFrom(
                                                                                                                            backgroundColor: colorBtn
                                                                                                                        ),
                                                                                                                        child: Text(
                                                                                                                          'Salvar',
                                                                                                                          style: TextStyle(
                                                                                                                              color: textColor
                                                                                                                          ),
                                                                                                                        )
                                                                                                                    )
                                                                                                                  ],
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          }
                                                                                          if(action == "remover_condominio"){
                                                                                            FirebaseFirestore.instance.collection("Condominios").doc(documents["idCondominio"]).delete().whenComplete((){
                                                                                              showToast("Cliente deletado!",context:context);
                                                                                            });
                                                                                          }
                                                                                        },
                                                                                        menu: snapshot.requireData,
                                                                                        otherCallback: (method) {
                                                                                        },
                                                                                        child: const Text(
                                                                                          "abc",
                                                                                          style: TextStyle(
                                                                                              color: Colors.transparent
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(16),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Stack(
                                                                                        children: [
                                                                                          //Sombra
                                                                                          Text(
                                                                                            "${documents["Codigo"]} ${documents['Nome']}",
                                                                                            style: TextStyle(
                                                                                              fontSize: 16,
                                                                                              foreground: Paint()
                                                                                                ..style = PaintingStyle.stroke
                                                                                                ..strokeWidth = 4
                                                                                                ..color = (idCondominio == documents['idCondominio'] ? Colors.blue[900] : Colors.blue)!,
                                                                                            ),
                                                                                          ),
                                                                                          //Texto normal
                                                                                          Text(
                                                                                            "${documents["Codigo"]} ${documents['Nome']}",
                                                                                            style: TextStyle(
                                                                                              fontSize: 16,
                                                                                              color: textColorInitBlue,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          IconButton(onPressed: (){
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (BuildContext context) {
                                                                                                return Center(
                                                                                                  child: Dialog(
                                                                                                    child: Stack(
                                                                                                      children: [
                                                                                                        Positioned.fill(
                                                                                                          child: ClipRRect(
                                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                                            child: Image.asset(
                                                                                                              "assets/FundoMetalPreto.jpg",
                                                                                                              fit: BoxFit.fill,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                            width: 550,
                                                                                                            height: 350,
                                                                                                            child: SingleChildScrollView(
                                                                                                              child: Column(
                                                                                                                children: [
                                                                                                                  Row(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                    children: [
                                                                                                                      Container(
                                                                                                                        padding: const EdgeInsets.all(16),
                                                                                                                        child: const Text(
                                                                                                                          'Informações sobre o condominio',
                                                                                                                          style: TextStyle(
                                                                                                                              fontSize: 25,
                                                                                                                              fontWeight: FontWeight.bold
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      SizedBox(
                                                                                                                          width: 100,
                                                                                                                          height: 100,
                                                                                                                          child: TextButton(onPressed: (){
                                                                                                                            Navigator.pop(context);
                                                                                                                          }, child: const Center(
                                                                                                                            child: Icon(
                                                                                                                              Icons.close,
                                                                                                                              size: 40,
                                                                                                                            ),
                                                                                                                          )
                                                                                                                          )
                                                                                                                      )
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                  Text("Nome do Condominio: ${documents["Nome"]}"),
                                                                                                                  Text("Cidade: ${documents["Cidade"]}"),
                                                                                                                  Text("Endereço: ${documents["Endereco"]}"),
                                                                                                                  Text("Bairro: ${documents["bairro"]}"),
                                                                                                                  Text("CEP: ${documents["cep"]}"),
                                                                                                                  Text("Sindico: ${documents["Sindico"]}"),
                                                                                                                  Text("Telefone: ${documents["Telefone"]}"),
                                                                                                                  Text("CNPJ: ${documents["CNPJ"]}"),
                                                                                                                  Text("Zelador: ${documents["Zelador"]}"),
                                                                                                                ],
                                                                                                              ),
                                                                                                            )
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                              icon: const Icon(
                                                                                                  color: Colors.white,
                                                                                                  Icons.info
                                                                                              )
                                                                                          ),
                                                                                          IconButton(onPressed: (){
                                                                                            setStater(() {
                                                                                              idCondominioAnt = documents["idCondominio"];
                                                                                              anotacao = documents["Aviso"];
                                                                                              anotacaoControlCondominio.text = anotacao;
                                                                                            });
                                                                                          },
                                                                                              icon: Icon(
                                                                                                  color: documents["Aviso"] == "" ? Colors.red : Colors.green,
                                                                                                  Icons.edit_note
                                                                                              )
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                AdicionarCondominios == true ? Container(
                                                  alignment: Alignment.bottomRight,
                                                  padding: const EdgeInsets.all(16),
                                                  child: TextButton(
                                                      onPressed: (){
                                                        String NomeCondominio = "";
                                                        String IPCameras = "";
                                                        int? PortaCameras;
                                                        String Cidade = "";
                                                        String Endereco = "";
                                                        String bairro = "";
                                                        String cep = "";
                                                        String Sindico = "";
                                                        String Telefone = "";
                                                        String CNPJ = "";
                                                        String Zelador = "";
                                                        String UserAccess = "";
                                                        String PassAccess = "";
                                                        String SIPUrl = "";
                                                        String Porta = "";
                                                        String AuthUser = "";
                                                        String Pass = "";
                                                        String codigo = "";
                                                        String modeloselecionado = "Intelbras";
                                                        var dropValue2 = ValueNotifier('Intelbras');

                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                              return SingleChildScrollView(
                                                                child: Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      // Imagem de fundo
                                                                      Positioned.fill(
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          child: Image.asset(
                                                                            "assets/FundoMetalPreto.jpg",
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: 700,
                                                                        padding: const EdgeInsets.all(30),
                                                                        child: Column(
                                                                          children: [
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  //width: 200,
                                                                                  height: 50,
                                                                                  child: Center(
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        const Text(
                                                                                          'Cadastro de Cliente',
                                                                                          style: TextStyle(
                                                                                            fontSize: 30,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 100,
                                                                                          height: 100,
                                                                                          child: TextButton(onPressed: (){
                                                                                            Navigator.pop(context);
                                                                                          }, child: const Center(
                                                                                            child: Icon(
                                                                                              Icons.close,
                                                                                              size: 40,
                                                                                            ),
                                                                                          )
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const Padding(
                                                                                  padding: EdgeInsets.only(bottom: 16),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          NomeCondominio = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Nome do Condominio',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          codigo = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Codigo do Condominio (4 caracteres Ex: 2402)',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          Cidade = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Cidade',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          Endereco = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Endereco',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          bairro = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Bairro',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          cep = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'CEP',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          Sindico = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Sindico',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          Telefone = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Telefone',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          CNPJ = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'CNPJ',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          Zelador = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Zelador',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      const Text('Modelo do CFTV:'),
                                                                                      ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
                                                                                        return DropdownButton(
                                                                                          hint: Text(
                                                                                            'Selecione o modelo',
                                                                                            style: TextStyle(
                                                                                                color: textColorDrop
                                                                                            ),
                                                                                          ),
                                                                                          value: (value.isEmpty)? null : value,
                                                                                          onChanged: (escolha) async {
                                                                                            dropValue2.value = escolha.toString();
                                                                                            setStater(() {
                                                                                              modeloselecionado = escolha.toString();
                                                                                            });
                                                                                          },
                                                                                          items: ModelosdeCFTV.map((opcao) => DropdownMenuItem(
                                                                                            value: opcao,
                                                                                            child:
                                                                                            Text(
                                                                                              opcao,
                                                                                              style: TextStyle(
                                                                                                  color: textColorDrop
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          ).toList(),
                                                                                        );
                                                                                      }),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          IPCameras = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'URL do CFTV (RTSP)',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          PortaCameras = int.parse(value);
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Porta do CFTV (RTSP) (Normalmente é 554, mas pode variar dependendo do CFTV)',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          UserAccess = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Usuario para acesso das cameras',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          PassAccess = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        labelText: 'Senha para acesso das cameras',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          SIPUrl = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelText: 'SIP Url (sip2.chamada.com.br), para ambientes não suportado é recomendado deixar (*) apenas.',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          Porta = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelText: 'SIP Porta (5060)',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          AuthUser = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelText: 'Usuario de acesso do SIP',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(16),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setStater(() {
                                                                                          Pass = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor,
                                                                                            backgroundColor: Colors.white
                                                                                        ),
                                                                                        border: const OutlineInputBorder(),
                                                                                        enabledBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: const OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelText: 'Senha de acesso do SIP',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                ElevatedButton(onPressed: (){
                                                                                  if(NomeCondominio == ""){
                                                                                    showToast("O nome do Condominio está vazio!",context:context);
                                                                                  }else{
                                                                                    if(codigo == ""){
                                                                                      showToast("O codigo está vazio!",context:context);
                                                                                    }else{
                                                                                      if(codigo.length == 4){
                                                                                        if(IPCameras == ""){
                                                                                          showToast("A URL das Cameras está vazia!",context:context);
                                                                                        }else{
                                                                                          if(PortaCameras == null){
                                                                                            showToast("A Porta em RTSP das Cameras está vazia!",context:context);
                                                                                          }else{
                                                                                            if(UserAccess == ""){
                                                                                              showToast("O Usuario para acesso das cameras está vazio!",context:context);
                                                                                            }else{
                                                                                              if(PassAccess == ""){
                                                                                                showToast("A Senha para acesso das cameras está vazia!",context:context);
                                                                                              }else{
                                                                                                Uuid uuid = const Uuid();
                                                                                                String UUID = uuid.v4();
                                                                                                FirebaseFirestore.instance.collection('Condominios').doc(UUID).set({
                                                                                                  "idCondominio": UUID,
                                                                                                  "Nome": NomeCondominio,
                                                                                                  "IpCamera": IPCameras,
                                                                                                  "PortaCameras": PortaCameras,
                                                                                                  "UserAccess": UserAccess,
                                                                                                  "PassAccess": PassAccess,
                                                                                                  "Aviso": "",
                                                                                                  "SIPUrl": SIPUrl,
                                                                                                  "PortaSIP": Porta,
                                                                                                  "authUserSIP": AuthUser,
                                                                                                  "authSenhaSIP": Pass,
                                                                                                  "Codigo" : codigo,
                                                                                                  'idEmpresaPertence' : EmpresaPertence,
                                                                                                  "ipCameraModelo": modeloselecionado,
                                                                                                  "Cidade": Cidade,
                                                                                                  "Endereco": Endereco,
                                                                                                  "bairro": bairro,
                                                                                                  "cep": cep,
                                                                                                  "Sindico": Sindico,
                                                                                                  "Telefone": Telefone,
                                                                                                  "CNPJ": CNPJ,
                                                                                                  "Zelador": Zelador,
                                                                                                  "ipCamera1": 1,
                                                                                                  "ipCamera2": 2,
                                                                                                  "ipCamera3": 3,
                                                                                                  "ipCamera4": 4,
                                                                                                  "ipCamera5": 5,
                                                                                                  "ipCamera6": 6,
                                                                                                  "ipCamera7": 7,
                                                                                                  "ipCamera8": 8,
                                                                                                  "ipCamera9": 9,
                                                                                                  "ipCamera10": 10,
                                                                                                  "ipCamera11": 11,
                                                                                                  "ipCamera12": 12,
                                                                                                  "ipCamera13": 13,
                                                                                                  "ipCamera14": 14,
                                                                                                  "ipCamera15": 15,
                                                                                                  "ipCamera16": 16,
                                                                                                  "ipCamera17": 17,
                                                                                                  "ipCamera18": 18,
                                                                                                  "ipCamera19": 19,
                                                                                                  "ipCamera20": 20,
                                                                                                  "ipCamera21": 21,
                                                                                                  "ipCamera22": 22,
                                                                                                  "ipCamera23": 23,
                                                                                                  "ipCamera24": 24,
                                                                                                  "ipCamera25": 25,
                                                                                                  "ipCamera26": 26,
                                                                                                  "ipCamera27": 27,
                                                                                                  "ipCamera28": 28,
                                                                                                  "ipCamera29": 29,
                                                                                                  "ipCamera30": 30,
                                                                                                  "ipCamera31": 31,
                                                                                                  "ipCamera32": 32,
                                                                                                  "ipCamera33": 33,
                                                                                                  "ipCamera34": 34,
                                                                                                  "ipCamera35": 35,
                                                                                                  "ipCamera36": 36,
                                                                                                }).whenComplete(() {
                                                                                                  showToast('Sucesso!', context: context);
                                                                                                  Navigator.pop(context);
                                                                                                });
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      }else{
                                                                                        if(codigo.length > 4){
                                                                                          showToast("Existem mais caracteres do que o permitido no codigo do condominio!",context:context);
                                                                                        }
                                                                                        if(codigo.length < 4){
                                                                                          showToast("Existem menos caracteres do que o permitido no codigo do condominio!",context:context);
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: colorBtn
                                                                                    ),
                                                                                    child: Text(
                                                                                      'Registrar novo Cliente',
                                                                                      style: TextStyle(
                                                                                          color: textColor
                                                                                      ),
                                                                                    )
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Image.asset(
                                                          "assets/fab.png",
                                                          scale: 45
                                                      )
                                                  ),
                                                ):
                                                Container(),
                                              ]
                                          ),
                                        ),
                                        Container(
                                          width: wid / 4,
                                          height: heig / 3.3,
                                          decoration: const BoxDecoration(
                                          ),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                width: wid / 4,
                                                height: heig / 3.3,
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        idCondominioAnt == "" ?
                                                        const Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(''
                                                                  'Clique no icone ',
                                                                  style: TextStyle(
                                                                      color: Colors.black
                                                                  )
                                                              ),
                                                              Icon(
                                                                Icons.edit_note,
                                                                color: Colors.black,
                                                              ),
                                                              Text(
                                                                  ' para editar a anotação',
                                                                  style: TextStyle(
                                                                      color: Colors.black
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                            :
                                                        Container(
                                                          padding: const EdgeInsets.all(16),
                                                          child: TextField(
                                                            controller: anotacaoControlCondominio,
                                                            keyboardType: TextInputType.multiline,
                                                            enableSuggestions: true,
                                                            autocorrect: true,
                                                            minLines: 5,
                                                            maxLines: null,
                                                            onChanged: (value){
                                                              anotacao = value;
                                                            },
                                                            style: const TextStyle(
                                                                color: Colors.black
                                                            ),
                                                            decoration: const InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              border: OutlineInputBorder(),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 3,
                                                                    color: Colors.black
                                                                ),
                                                              ),
                                                              labelStyle: TextStyle(
                                                                  color: Colors.black,
                                                                  backgroundColor: Colors.white
                                                              ),
                                                              labelText: "Anotações sobre o condominio",
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: wid / 4,
                                                height: heig / 3.3,
                                                padding: const EdgeInsets.all(10),
                                                alignment: Alignment.bottomRight,
                                                child:  idCondominioAnt == "" || editarAnotacao == false ?
                                                Container():
                                                FloatingActionButton(
                                                    onPressed:idCondominioAnt == "" ? null : (){
                                                      FirebaseFirestore.instance.collection('Condominios').doc(idCondominioAnt).update({
                                                        "Aviso": anotacao,
                                                      }).whenComplete(() {
                                                        showToast("Anotação salva com sucesso!",context:context);
                                                      });
                                                    },
                                                    backgroundColor: colorBtnFab,
                                                    child: Icon(
                                                        Icons.done,
                                                        color: textColor
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                            width: wid / 2,
                            height: heig,
                            child: Column(
                              children: [
                                //CFTV AQUI!
                                StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                      return VideoStreamWidget(
                                          ip, porta, user, pass, corDasBarras, wid, heig, camera1, camera2, camera3, camera4, camera5, camera6, camera7, camera8, camera9, ModeloDoCFTV
                                      );
                                    }
                                ),
                                SizedBox(
                                  width: wid / 2,
                                  height: heig / 2.3,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/fundoWidgetContainerMain.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              idCondominio == ""?
                                              SizedBox(
                                                width: wid / 3,
                                                height: heig / 2.3,
                                              ) :
                                              SizedBox(
                                                width: wid / 3,
                                                height: heig / 2.3,
                                                child: Stack(
                                                  children: [
                                                    StreamBuilder(
                                                      stream: FirebaseFirestore.instance
                                                          .collection('acionamentos')
                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                          .snapshots(),
                                                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                        if (snapshot.hasError) {
                                                          return const Center(child:
                                                          Text('Algo deu errado!')
                                                          );
                                                        }

                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return const Center(child: CircularProgressIndicator());
                                                        }

                                                        if (snapshot.hasData) {
                                                          return GridView.count(
                                                              childAspectRatio: 1.2,
                                                              crossAxisCount: 3,
                                                              children: snapshot.data!.docs.map((documents) {
                                                                double tamanhotext = 14;
                                                                bool isBolded = false;

                                                                if(documents["nome"].length >= 16){
                                                                  tamanhotext = 12;
                                                                }

                                                                if(documents["nome"].length >= 20){
                                                                  tamanhotext = 9;
                                                                  isBolded = true;
                                                                }

                                                                return Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 50,
                                                                        child: TextButton(
                                                                            onPressed: (){
                                                                              if(documents["prontoParaAtivar"] == false){
                                                                                FirebaseFirestore.instance.collection("acionamentos").doc(documents["id"]).update({
                                                                                  "prontoParaAtivar" : true,
                                                                                  "deuErro": false
                                                                                });
                                                                              }
                                                                              if(documents["prontoParaAtivar"] == true){
                                                                                acionarPorta(context, documents["ip"], documents["porta"], documents["modelo"], documents["canal"], documents["usuario"], documents["senha"], documents["id"]);
                                                                              }
                                                                            },
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Image.asset(
                                                                                  documents["deuErro"] == true ?
                                                                                  "assets/btnIsNotAbleToConnect.png":
                                                                                  documents["prontoParaAtivar"] == false ?
                                                                                  "assets/btnInactive.png" :
                                                                                  "assets/btnIsAbleToAction.png",
                                                                                  scale: 5,
                                                                                ),
                                                                                Image.asset(
                                                                                    documents["iconeSeleciondo"],
                                                                                    scale: 45
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                      ),
                                                                      Stack(
                                                                        alignment: Alignment.center,
                                                                        children: [
                                                                          Text(
                                                                              documents["nome"],
                                                                              style: isBolded == true?
                                                                              TextStyle(
                                                                                  color: textColorWidgets,
                                                                                  fontSize: tamanhotext,
                                                                                  fontWeight: FontWeight.bold
                                                                              )
                                                                                  :
                                                                              TextStyle(
                                                                                  color: textColorWidgets,
                                                                                  fontSize: tamanhotext,
                                                                              ),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          SizedBox(
                                                                            height: 20,
                                                                            child: FutureBuilder<NativeMenu>(
                                                                              future: initMenuAcionamentos(),
                                                                              builder: (BuildContext context, AsyncSnapshot<NativeMenu> snapshot){

                                                                                if (!snapshot.hasData) {
                                                                                  return const Center(
                                                                                    child: CircularProgressIndicator(),
                                                                                  );
                                                                                }

                                                                                return NativeContextMenuWidget(
                                                                                  actionCallback: (action) {
                                                                                    if(action == "editar_acionamento"){

                                                                                      TextEditingController identificacaocontr = TextEditingController(text: documents["nome"]);
                                                                                      TextEditingController ipcontr = TextEditingController(text: documents["ip"]);
                                                                                      TextEditingController portacontr = TextEditingController(text: "${documents["porta"]}");
                                                                                      TextEditingController canalcontr = TextEditingController(text: "${documents["canal"]}");
                                                                                      TextEditingController usuariocontr = TextEditingController(text: documents["usuario"]);
                                                                                      TextEditingController senhacontr = TextEditingController(text: documents["senha"]);

                                                                                      String nome = documents["nome"];
                                                                                      String ip = documents["ip"];
                                                                                      String porta = "${documents["porta"]}";
                                                                                      String canal = "${documents["canal"]}";
                                                                                      String usuario = documents["usuario"];
                                                                                      String senha = documents["senha"];
                                                                                      String modeloselecionado = documents["modelo"];
                                                                                      String iconeSelecionado = documents["iconeSeleciondo"];
                                                                                      var dropValue4 = ValueNotifier(iconeSelecionado);

                                                                                      List icones = [
                                                                                        "assets/portaria_acept.png",
                                                                                        "assets/pedestre.png",
                                                                                        "assets/pedestre02.png",
                                                                                        "assets/door.png",
                                                                                        "assets/garagem.png",
                                                                                      ];
                                                                                      var dropValue3 = ValueNotifier(modeloselecionado);
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) {
                                                                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                                            return Center(
                                                                                              child: SingleChildScrollView(
                                                                                                child: Dialog(
                                                                                                  child: Stack(
                                                                                                    children: [
                                                                                                      Positioned.fill(
                                                                                                        child: ClipRRect(
                                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                                          child: Image.asset(
                                                                                                            "assets/FundoMetalPreto.jpg",
                                                                                                            fit: BoxFit.fill,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Container(
                                                                                                        width: 600,
                                                                                                        padding: const EdgeInsets.all(20),
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                              children: [
                                                                                                                Container(
                                                                                                                    padding: const EdgeInsets.only(bottom: 16),
                                                                                                                    child: const Text(
                                                                                                                      'Editar acionamento',
                                                                                                                      style: TextStyle(
                                                                                                                        fontSize: 30,
                                                                                                                      ),
                                                                                                                    )
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  width: 100,
                                                                                                                  height: 100,
                                                                                                                  child: TextButton(onPressed: (){
                                                                                                                    Navigator.pop(context);
                                                                                                                  },
                                                                                                                      child:const Center(
                                                                                                                        child: Icon(
                                                                                                                          Icons.close,
                                                                                                                          size: 40,
                                                                                                                        ),
                                                                                                                      )
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: Column(
                                                                                                                children: [
                                                                                                                  Center(
                                                                                                                    child: Container(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextField(
                                                                                                                        controller: identificacaocontr,
                                                                                                                        keyboardType: TextInputType.name,
                                                                                                                        enableSuggestions: true,
                                                                                                                        autocorrect: true,
                                                                                                                        onChanged: (value){
                                                                                                                          setStater(() {
                                                                                                                            nome = value;
                                                                                                                          });
                                                                                                                        },
                                                                                                                        decoration: InputDecoration(
                                                                                                                          filled: true,
                                                                                                                          fillColor: Colors.white,
                                                                                                                          labelStyle: TextStyle(
                                                                                                                              color: textAlertDialogColor,
                                                                                                                              backgroundColor: Colors.white
                                                                                                                          ),
                                                                                                                          border: const OutlineInputBorder(),
                                                                                                                          enabledBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                          ),
                                                                                                                          focusedBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(
                                                                                                                                width: 3,
                                                                                                                                color: Colors.black
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          label: const Text('Nome'),
                                                                                                                        ),
                                                                                                                        style: TextStyle(
                                                                                                                            color: textAlertDialogColor
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Center(
                                                                                                                    child: Container(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextField(
                                                                                                                        controller: ipcontr,
                                                                                                                        keyboardType: TextInputType.name,
                                                                                                                        enableSuggestions: true,
                                                                                                                        autocorrect: true,
                                                                                                                        onChanged: (value){
                                                                                                                          setStater(() {
                                                                                                                            ip = value;
                                                                                                                          });
                                                                                                                        },
                                                                                                                        decoration: InputDecoration(
                                                                                                                          filled: true,
                                                                                                                          fillColor: Colors.white,
                                                                                                                          labelStyle: TextStyle(
                                                                                                                              color: textAlertDialogColor,
                                                                                                                              backgroundColor: Colors.white
                                                                                                                          ),
                                                                                                                          border: const OutlineInputBorder(),
                                                                                                                          enabledBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                          ),
                                                                                                                          focusedBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(
                                                                                                                                width: 3,
                                                                                                                                color: Colors.black
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          label: const Text('IP'),
                                                                                                                        ),
                                                                                                                        style: TextStyle(
                                                                                                                            color: textAlertDialogColor
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Center(
                                                                                                                    child: Container(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextField(
                                                                                                                        controller: portacontr,
                                                                                                                        keyboardType: TextInputType.name,
                                                                                                                        enableSuggestions: true,
                                                                                                                        autocorrect: true,
                                                                                                                        onChanged: (value){
                                                                                                                          setStater(() {
                                                                                                                            porta = value;
                                                                                                                          });
                                                                                                                        },
                                                                                                                        decoration: InputDecoration(
                                                                                                                          filled: true,
                                                                                                                          fillColor: Colors.white,
                                                                                                                          labelStyle: TextStyle(
                                                                                                                              color: textAlertDialogColor,
                                                                                                                              backgroundColor: Colors.white
                                                                                                                          ),
                                                                                                                          border: const OutlineInputBorder(),
                                                                                                                          enabledBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                          ),
                                                                                                                          focusedBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(
                                                                                                                                width: 3,
                                                                                                                                color: Colors.black
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          label: Text(modeloselecionado == "Modulo Guarita (Nice)" ?'Porta (normalmente 9000)': 'Porta'),
                                                                                                                        ),
                                                                                                                        style: TextStyle(
                                                                                                                            color: textAlertDialogColor
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Center(
                                                                                                                    child: Container(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextField(
                                                                                                                        controller: canalcontr,
                                                                                                                        keyboardType: TextInputType.name,
                                                                                                                        enableSuggestions: true,
                                                                                                                        autocorrect: true,
                                                                                                                        onChanged: (value){
                                                                                                                          setStater(() {
                                                                                                                            canal = value;
                                                                                                                          });
                                                                                                                        },
                                                                                                                        decoration: InputDecoration(
                                                                                                                          filled: true,
                                                                                                                          fillColor: Colors.white,
                                                                                                                          labelStyle: TextStyle(
                                                                                                                              color: textAlertDialogColor,
                                                                                                                              backgroundColor: Colors.white
                                                                                                                          ),
                                                                                                                          border: const OutlineInputBorder(),
                                                                                                                          enabledBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                          ),
                                                                                                                          focusedBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(
                                                                                                                                width: 3,
                                                                                                                                color: Colors.black
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          label: Text(modeloselecionado == "Modulo Guarita (Nice)" ? 'Relê': "Canal"),
                                                                                                                        ),
                                                                                                                        style: TextStyle(
                                                                                                                            color: textAlertDialogColor
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  modeloselecionado == "Modulo Guarita (Nice)" ? Container():
                                                                                                                  Center(
                                                                                                                    child: Container(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextField(
                                                                                                                        controller: usuariocontr,
                                                                                                                        keyboardType: TextInputType.name,
                                                                                                                        enableSuggestions: true,
                                                                                                                        autocorrect: true,
                                                                                                                        onChanged: (value){
                                                                                                                          setStater(() {
                                                                                                                            usuario = value;
                                                                                                                          });
                                                                                                                        },
                                                                                                                        decoration: InputDecoration(
                                                                                                                          filled: true,
                                                                                                                          fillColor: Colors.white,
                                                                                                                          labelStyle: TextStyle(
                                                                                                                              color: textAlertDialogColor,
                                                                                                                              backgroundColor: Colors.white
                                                                                                                          ),
                                                                                                                          border: const OutlineInputBorder(),
                                                                                                                          enabledBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                          ),
                                                                                                                          focusedBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(
                                                                                                                                width: 3,
                                                                                                                                color: Colors.black
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          label: const Text('Usuario'),
                                                                                                                        ),
                                                                                                                        style: TextStyle(
                                                                                                                            color: textAlertDialogColor
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  modeloselecionado == "Modulo Guarita (Nice)" ? Container():
                                                                                                                  Center(
                                                                                                                    child: Container(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextField(
                                                                                                                        controller: senhacontr,
                                                                                                                        keyboardType: TextInputType.name,
                                                                                                                        enableSuggestions: true,
                                                                                                                        autocorrect: true,
                                                                                                                        onChanged: (value){
                                                                                                                          setStater(() {
                                                                                                                            senha = value;
                                                                                                                          });
                                                                                                                        },
                                                                                                                        decoration: InputDecoration(
                                                                                                                          filled: true,
                                                                                                                          fillColor: Colors.white,
                                                                                                                          labelStyle: TextStyle(
                                                                                                                              color: textAlertDialogColor,
                                                                                                                              backgroundColor: Colors.white
                                                                                                                          ),
                                                                                                                          border: const OutlineInputBorder(),
                                                                                                                          enabledBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                          ),
                                                                                                                          focusedBorder: const OutlineInputBorder(
                                                                                                                            borderSide: BorderSide(
                                                                                                                                width: 3,
                                                                                                                                color: Colors.black
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          label: const Text('Senha'),
                                                                                                                        ),
                                                                                                                        style: TextStyle(
                                                                                                                            color: textAlertDialogColor
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                            const Center(
                                                                                                              child: Text('Selecione um icone'),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: ValueListenableBuilder(valueListenable: dropValue4, builder: (context, String value, _){
                                                                                                                return DropdownButton(
                                                                                                                  hint: Text(
                                                                                                                    'Selecione um icone',
                                                                                                                    style: TextStyle(
                                                                                                                        color: textColorDrop
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  value: (value.isEmpty)? null : value,
                                                                                                                  onChanged: (escolha) async {
                                                                                                                    dropValue4.value = escolha.toString();
                                                                                                                    setStater(() {
                                                                                                                      iconeSelecionado = escolha.toString();
                                                                                                                    });
                                                                                                                  },
                                                                                                                  items: icones.map((opcao) => DropdownMenuItem(
                                                                                                                      value: opcao,
                                                                                                                      child: Image.asset(
                                                                                                                          opcao,
                                                                                                                          scale: 30
                                                                                                                      )
                                                                                                                  ),
                                                                                                                  ).toList(),
                                                                                                                );
                                                                                                              }
                                                                                                              ),
                                                                                                            ),
                                                                                                            const Center(
                                                                                                              child: Text('Selecione o modelo'),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: ValueListenableBuilder(valueListenable: dropValue3, builder: (context, String value, _){
                                                                                                                return DropdownButton(
                                                                                                                  hint: Text(
                                                                                                                    'Selecione o modelo',
                                                                                                                    style: TextStyle(
                                                                                                                        color: textColorDrop
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  value: (value.isEmpty)? null : value,
                                                                                                                  onChanged: (escolha) async {
                                                                                                                    dropValue3.value = escolha.toString();
                                                                                                                    setStater(() {
                                                                                                                      modeloselecionado = escolha.toString();
                                                                                                                    });
                                                                                                                  },
                                                                                                                  items: ModelosAcionamentos.map((opcao) => DropdownMenuItem(
                                                                                                                    value: opcao,
                                                                                                                    child:
                                                                                                                    Text(
                                                                                                                      opcao,
                                                                                                                      style: TextStyle(
                                                                                                                          color: textColorDrop
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  ).toList(),
                                                                                                                );
                                                                                                              }),
                                                                                                            ),
                                                                                                            ElevatedButton(
                                                                                                              onPressed: (){
                                                                                                                //"Modulo Guarita (Nice)"
                                                                                                                if(modeloselecionado == "Modulo Guarita (Nice)"){
                                                                                                                  if(nome == ""){
                                                                                                                    showToast("O nome não pode ficar vazio!",context:context);
                                                                                                                  }else{
                                                                                                                    if(ip == ""){
                                                                                                                      showToast("O ip não pode estar vazio!",context:context);
                                                                                                                    }else{
                                                                                                                      if(porta == ""){
                                                                                                                        showToast("A porta não pode estar vazia!",context:context);
                                                                                                                      }else{
                                                                                                                        final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                                                        if(regex.hasMatch(porta)){
                                                                                                                          showToast("A porta contem letras, e letras não são permitidas!",context:context);
                                                                                                                        }else{
                                                                                                                          if(canal == ""){
                                                                                                                            showToast("O relê não pode estar vazia!",context:context);
                                                                                                                          }else{
                                                                                                                            final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                                                            if(regex.hasMatch(canal)){
                                                                                                                              showToast("O relê contem letras, e letras não são permitidas!",context:context);
                                                                                                                            }else{
                                                                                                                              if(iconeSelecionado == ""){
                                                                                                                                showToast("O icone precisa ser selecionado!",context:context);
                                                                                                                              }else{
                                                                                                                                if(modeloselecionado == ""){
                                                                                                                                  showToast("O modelo precisa ser selecionado!",context:context);
                                                                                                                                }else{
                                                                                                                                  FirebaseFirestore.instance.collection("acionamentos").doc(documents["id"]).update({
                                                                                                                                    "nome": nome,
                                                                                                                                    "ip": ip,
                                                                                                                                    "porta": int.parse(porta),
                                                                                                                                    "canal": int.parse(canal),
                                                                                                                                    "usuario": usuario,
                                                                                                                                    "senha": senha,
                                                                                                                                    "modelo": modeloselecionado,
                                                                                                                                    "idCondominio": idCondominio,
                                                                                                                                    "iconeSeleciondo": iconeSelecionado
                                                                                                                                  }).whenComplete((){
                                                                                                                                    Navigator.pop(context);
                                                                                                                                  });
                                                                                                                                }
                                                                                                                              }
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }
                                                                                                                      }
                                                                                                                    }
                                                                                                                  }
                                                                                                                }else{
                                                                                                                  if(nome == ""){
                                                                                                                    showToast("O nome não pode ficar vazio!",context:context);
                                                                                                                  }else{
                                                                                                                    if(ip == ""){
                                                                                                                      showToast("O ip não pode estar vazio!",context:context);
                                                                                                                    }else{
                                                                                                                      if(porta == ""){
                                                                                                                        showToast("A porta não pode estar vazia!",context:context);
                                                                                                                      }else{
                                                                                                                        final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                                                        if(regex.hasMatch(porta)){
                                                                                                                          showToast("A porta contem letras, e letras não são permitidas!",context:context);
                                                                                                                        }else{
                                                                                                                          if(canal == ""){
                                                                                                                            showToast("O canal não pode estar vazia!",context:context);
                                                                                                                          }else{
                                                                                                                            final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                                                            if(regex.hasMatch(canal)){
                                                                                                                              showToast("O canal contem letras, e letras não são permitidas!",context:context);
                                                                                                                            }else{
                                                                                                                              if(usuario == ""){
                                                                                                                                showToast("O usuario não pode estar vazio!",context:context);
                                                                                                                              }else{
                                                                                                                                if(senha == ""){
                                                                                                                                  showToast("A senha não pode estar vazia!",context:context);
                                                                                                                                }else{
                                                                                                                                  if(iconeSelecionado == ""){
                                                                                                                                    showToast("O icone precisa ser selecionado!",context:context);
                                                                                                                                  }else{
                                                                                                                                    if(modeloselecionado == ""){
                                                                                                                                      showToast("O modelo precisa ser selecionado!",context:context);
                                                                                                                                    }else{
                                                                                                                                      FirebaseFirestore.instance.collection("acionamentos").doc(documents["id"]).update({
                                                                                                                                        "nome": nome,
                                                                                                                                        "ip": ip,
                                                                                                                                        "porta": int.parse(porta),
                                                                                                                                        "canal": int.parse(canal),
                                                                                                                                        "usuario": usuario,
                                                                                                                                        "senha": senha,
                                                                                                                                        "modelo": modeloselecionado,
                                                                                                                                        "idCondominio": idCondominio,
                                                                                                                                        "iconeSeleciondo": iconeSelecionado
                                                                                                                                      }).whenComplete((){
                                                                                                                                        Navigator.pop(context);
                                                                                                                                      });
                                                                                                                                    }
                                                                                                                                  }
                                                                                                                                }
                                                                                                                              }
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }
                                                                                                                      }
                                                                                                                    }
                                                                                                                  }
                                                                                                                }
                                                                                                              },style: ElevatedButton.styleFrom(
                                                                                                                backgroundColor: colorBtn
                                                                                                            ),
                                                                                                              child: Text(
                                                                                                                'Salvar edições',
                                                                                                                style: TextStyle(
                                                                                                                    color: textColor
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }
                                                                                    if(action == "delAcionamento"){
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) {
                                                                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                                            return Center(
                                                                                              child: SingleChildScrollView(
                                                                                                child: Dialog(
                                                                                                  child: Stack(
                                                                                                    children: [
                                                                                                      // Imagem de fundo
                                                                                                      Positioned.fill(
                                                                                                        child: ClipRRect(
                                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                                          child: Image.asset(
                                                                                                            "assets/FundoMetalPreto.jpg",
                                                                                                            fit: BoxFit.fill,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Container(
                                                                                                        width: 400,
                                                                                                        padding: const EdgeInsets.all(30),
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            const Text('Deletar esse acionamento?',
                                                                                                              style:TextStyle(fontSize: 23,
                                                                                                                  fontWeight: FontWeight.bold),
                                                                                                            ),
                                                                                                            Container(
                                                                                                              padding: const EdgeInsets.all(16),
                                                                                                              child: const Text('Tem certeza que deseja deletar esse acionamento?',
                                                                                                                style:TextStyle(fontSize: 16),
                                                                                                                textAlign: TextAlign.center,
                                                                                                              ),
                                                                                                            ),
                                                                                                            Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                              children: [
                                                                                                                ElevatedButton(onPressed: (){
                                                                                                                  Navigator.pop(context);
                                                                                                                },
                                                                                                                  style: ElevatedButton.styleFrom(
                                                                                                                      backgroundColor: colorBtn
                                                                                                                  ), child: const Text('Não'),
                                                                                                                ),
                                                                                                                ElevatedButton(onPressed: (){
                                                                                                                  FirebaseFirestore.instance.collection("acionamentos").doc(documents["idCondominio"]).delete().whenComplete((){
                                                                                                                    showToast("Acionamento deletado!",context:context);
                                                                                                                  });
                                                                                                                },
                                                                                                                  style: ElevatedButton.styleFrom(
                                                                                                                      backgroundColor: colorBtn
                                                                                                                  ), child: const Text('Sim'),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  menu: snapshot.requireData,
                                                                                  otherCallback: (method) {
                                                                                  },
                                                                                  child: const Text(
                                                                                    "abc",
                                                                                    style: TextStyle(
                                                                                        color: Colors.transparent
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }).toList().reversed.toList()
                                                          );
                                                        }
                                                        return const Center(
                                                            child: Text('Sem dados!',)
                                                        );
                                                      },
                                                    ),
                                                    if (AdicionarAcionamentos == false) Container() else Container(
                                                      padding: const EdgeInsets.all(16),
                                                      alignment: Alignment.bottomRight,
                                                      child: TextButton(
                                                          onPressed: (){
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {

                                                                String nome = "";
                                                                String ip = "";
                                                                String modeloselecionado = "Intelbras";
                                                                String porta = "";
                                                                String canal = "";
                                                                String usuario = "";
                                                                String senha = "";
                                                                var dropValue3 = ValueNotifier('Intelbras');
                                                                var dropValue4 = ValueNotifier('assets/portaria_acept.png');
                                                                String iconeSelecionado = "assets/portaria_acept.png";
                                                                List icones = [
                                                                  "assets/portaria_acept.png",
                                                                  "assets/pedestre.png",
                                                                  "assets/pedestre02.png",
                                                                  "assets/door.png",
                                                                  "assets/garagem.png",
                                                                ];

                                                                return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                  return Center(
                                                                    child: SingleChildScrollView(
                                                                      child: Dialog(
                                                                        child: Stack(
                                                                          children: [
                                                                            Positioned.fill(
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                child: Image.asset(
                                                                                  "assets/FundoMetalPreto.jpg",
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: 600,
                                                                              padding: const EdgeInsets.all(20),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                          padding: const EdgeInsets.only(bottom: 16),
                                                                                          child: const Text(
                                                                                            'Adicionar novo acionamento',
                                                                                            style: TextStyle(
                                                                                              fontSize: 30,
                                                                                            ),
                                                                                          )
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 100,
                                                                                        height: 100,
                                                                                        child: TextButton(onPressed: (){
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                            child:const Center(
                                                                                              child: Icon(
                                                                                                Icons.close,
                                                                                                size: 40,
                                                                                              ),
                                                                                            )
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Center(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Center(
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: TextField(
                                                                                              keyboardType: TextInputType.name,
                                                                                              enableSuggestions: true,
                                                                                              autocorrect: true,
                                                                                              onChanged: (value){
                                                                                                setStater(() {
                                                                                                  nome = value;
                                                                                                });
                                                                                              },
                                                                                              decoration: InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                labelStyle: TextStyle(
                                                                                                    color: textAlertDialogColor,
                                                                                                    backgroundColor: Colors.white
                                                                                                ),
                                                                                                border: const OutlineInputBorder(),
                                                                                                enabledBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                ),
                                                                                                focusedBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                      width: 3,
                                                                                                      color: Colors.black
                                                                                                  ),
                                                                                                ),
                                                                                                label: const Text('Nome de identificação'),
                                                                                              ),
                                                                                              style: TextStyle(
                                                                                                  color: textAlertDialogColor
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Center(
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: TextField(
                                                                                              keyboardType: TextInputType.name,
                                                                                              enableSuggestions: true,
                                                                                              autocorrect: true,
                                                                                              onChanged: (value){
                                                                                                setStater(() {
                                                                                                  ip = value;
                                                                                                });
                                                                                              },
                                                                                              decoration: InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                labelStyle: TextStyle(
                                                                                                    color: textAlertDialogColor,
                                                                                                    backgroundColor: Colors.white
                                                                                                ),
                                                                                                border: const OutlineInputBorder(),
                                                                                                enabledBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                ),
                                                                                                focusedBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                      width: 3,
                                                                                                      color: Colors.black
                                                                                                  ),
                                                                                                ),
                                                                                                label: const Text('IP'),
                                                                                              ),
                                                                                              style: TextStyle(
                                                                                                  color: textAlertDialogColor
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Center(
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: TextField(
                                                                                              keyboardType: TextInputType.name,
                                                                                              enableSuggestions: true,
                                                                                              autocorrect: true,
                                                                                              onChanged: (value){
                                                                                                setStater(() {
                                                                                                  porta = value;
                                                                                                });
                                                                                              },
                                                                                              decoration: InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                labelStyle: TextStyle(
                                                                                                    color: textAlertDialogColor,
                                                                                                    backgroundColor: Colors.white
                                                                                                ),
                                                                                                border: const OutlineInputBorder(),
                                                                                                enabledBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                ),
                                                                                                focusedBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                      width: 3,
                                                                                                      color: Colors.black
                                                                                                  ),
                                                                                                ),
                                                                                                label: Text(modeloselecionado == "Modulo Guarita (Nice)" ?'Porta (normalmente 9000)': 'Porta'),
                                                                                              ),
                                                                                              style: TextStyle(
                                                                                                  color: textAlertDialogColor
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Center(
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: TextField(
                                                                                              keyboardType: TextInputType.name,
                                                                                              enableSuggestions: true,
                                                                                              autocorrect: true,
                                                                                              onChanged: (value){
                                                                                                setStater(() {
                                                                                                  canal = value;
                                                                                                });
                                                                                              },
                                                                                              decoration: InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                labelStyle: TextStyle(
                                                                                                    color: textAlertDialogColor,
                                                                                                    backgroundColor: Colors.white
                                                                                                ),
                                                                                                border: const OutlineInputBorder(),
                                                                                                enabledBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                ),
                                                                                                focusedBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                      width: 3,
                                                                                                      color: Colors.black
                                                                                                  ),
                                                                                                ),
                                                                                                label: Text(modeloselecionado == "Modulo Guarita (Nice)" ? 'Relê': "Canal"),
                                                                                              ),
                                                                                              style: TextStyle(
                                                                                                  color: textAlertDialogColor
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        modeloselecionado == "Modulo Guarita (Nice)" ? Container():
                                                                                        Center(
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: TextField(
                                                                                              keyboardType: TextInputType.name,
                                                                                              enableSuggestions: true,
                                                                                              autocorrect: true,
                                                                                              onChanged: (value){
                                                                                                setStater(() {
                                                                                                  usuario = value;
                                                                                                });
                                                                                              },
                                                                                              decoration: InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                labelStyle: TextStyle(
                                                                                                    color: textAlertDialogColor,
                                                                                                    backgroundColor: Colors.white
                                                                                                ),
                                                                                                border: const OutlineInputBorder(),
                                                                                                enabledBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                ),
                                                                                                focusedBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                      width: 3,
                                                                                                      color: Colors.black
                                                                                                  ),
                                                                                                ),
                                                                                                label: const Text('Usuario'),
                                                                                              ),
                                                                                              style: TextStyle(
                                                                                                  color: textAlertDialogColor
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        modeloselecionado == "Modulo Guarita (Nice)" ? Container():
                                                                                        Center(
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: TextField(
                                                                                              keyboardType: TextInputType.name,
                                                                                              enableSuggestions: true,
                                                                                              autocorrect: true,
                                                                                              onChanged: (value){
                                                                                                setStater(() {
                                                                                                  senha = value;
                                                                                                });
                                                                                              },
                                                                                              decoration: InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                labelStyle: TextStyle(
                                                                                                    color: textAlertDialogColor,
                                                                                                    backgroundColor: Colors.white
                                                                                                ),
                                                                                                border: const OutlineInputBorder(),
                                                                                                enabledBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                ),
                                                                                                focusedBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                      width: 3,
                                                                                                      color: Colors.black
                                                                                                  ),
                                                                                                ),
                                                                                                label: const Text('Senha'),
                                                                                              ),
                                                                                              style: TextStyle(
                                                                                                  color: textAlertDialogColor
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const Center(
                                                                                    child: Text('Selecione um icone'),
                                                                                  ),
                                                                                  Center(
                                                                                    child: ValueListenableBuilder(valueListenable: dropValue4, builder: (context, String value, _){
                                                                                      return DropdownButton(
                                                                                        hint: Text(
                                                                                          'Selecione um icone',
                                                                                          style: TextStyle(
                                                                                              color: textColorDrop
                                                                                          ),
                                                                                        ),
                                                                                        value: (value.isEmpty)? null : value,
                                                                                        onChanged: (escolha) async {
                                                                                          dropValue4.value = escolha.toString();
                                                                                          setStater(() {
                                                                                            iconeSelecionado = escolha.toString();
                                                                                          });
                                                                                        },
                                                                                        items: icones.map((opcao) => DropdownMenuItem(
                                                                                            value: opcao,
                                                                                            child: Image.asset(
                                                                                                opcao,
                                                                                                scale: 30
                                                                                            )
                                                                                        ),
                                                                                        ).toList(),
                                                                                      );
                                                                                    }
                                                                                    ),
                                                                                  ),
                                                                                  const Center(
                                                                                    child: Text('Selecione o modelo'),
                                                                                  ),
                                                                                  Center(
                                                                                    child: ValueListenableBuilder(valueListenable: dropValue3, builder: (context, String value, _){
                                                                                      return DropdownButton(
                                                                                        hint: Text(
                                                                                          'Selecione o modelo',
                                                                                          style: TextStyle(
                                                                                              color: textColorDrop
                                                                                          ),
                                                                                        ),
                                                                                        value: (value.isEmpty)? null : value,
                                                                                        onChanged: (escolha) async {
                                                                                          dropValue3.value = escolha.toString();
                                                                                          setStater(() {
                                                                                            modeloselecionado = escolha.toString();
                                                                                          });
                                                                                        },
                                                                                        items: ModelosAcionamentos.map((opcao) => DropdownMenuItem(
                                                                                          value: opcao,
                                                                                          child:
                                                                                          Text(
                                                                                            opcao,
                                                                                            style: TextStyle(
                                                                                                color: textColorDrop
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        ).toList(),
                                                                                      );
                                                                                    }),
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                    onPressed: (){
                                                                                      //Manda para o banco de dados toda a informação do Relê!
                                                                                      toDB(){
                                                                                        Uuid uuid = const Uuid();
                                                                                        String UUID = uuid.v4();
                                                                                        FirebaseFirestore.instance.collection("acionamentos").doc(UUID).set({
                                                                                          "nome": nome,
                                                                                          "ip": ip,
                                                                                          "porta": int.parse(porta),
                                                                                          "canal": int.parse(canal),
                                                                                          "usuario": usuario,
                                                                                          "senha": senha,
                                                                                          "modelo": modeloselecionado,
                                                                                          "prontoParaAtivar": false,
                                                                                          "deuErro": false,
                                                                                          "idCondominio": idCondominio,
                                                                                          "id": UUID,
                                                                                          "iconeSeleciondo": iconeSelecionado
                                                                                        }).whenComplete((){
                                                                                          Navigator.pop(context);
                                                                                        });
                                                                                      }

                                                                                      //If para modulo guarita
                                                                                      if(modeloselecionado == "Modulo Guarita (Nice)"){
                                                                                        if(nome == ""){
                                                                                          showToast("O nome não pode ficar vazio!",context:context);
                                                                                        }else{
                                                                                          if(ip == ""){
                                                                                            showToast("O ip não pode estar vazio!",context:context);
                                                                                          }else{
                                                                                            if(porta == ""){
                                                                                              showToast("A porta não pode estar vazia!",context:context);
                                                                                            }else{
                                                                                              final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                              if(regex.hasMatch(porta)){
                                                                                                showToast("A porta contem letras, e letras não são permitidas!",context:context);
                                                                                              }else{
                                                                                                if(canal == ""){
                                                                                                  showToast("O relê não pode estar vazia!",context:context);
                                                                                                }else{
                                                                                                  final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                                  if(regex.hasMatch(canal)){
                                                                                                    showToast("O relê contem letras, e letras não são permitidas!",context:context);
                                                                                                  }else{

                                                                                                    if(iconeSelecionado == ""){
                                                                                                      showToast("O icone precisa ser selecionado!",context:context);
                                                                                                    }else{
                                                                                                      if(modeloselecionado == ""){
                                                                                                        showToast("O modelo precisa ser selecionado!",context:context);
                                                                                                      }else{
                                                                                                        toDB();
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      }else{
                                                                                        if(nome == ""){
                                                                                          showToast("O nome não pode ficar vazio!",context:context);
                                                                                        }else{
                                                                                          if(ip == ""){
                                                                                            showToast("O ip não pode estar vazio!",context:context);
                                                                                          }else{
                                                                                            if(porta == ""){
                                                                                              showToast("A porta não pode estar vazia!",context:context);
                                                                                            }else{
                                                                                              final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                              if(regex.hasMatch(porta)){
                                                                                                showToast("A porta contem letras, e letras não são permitidas!",context:context);
                                                                                              }else{
                                                                                                if(canal == ""){
                                                                                                  showToast("O canal não pode estar vazia!",context:context);
                                                                                                }else{
                                                                                                  final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                                  if(regex.hasMatch(canal)){
                                                                                                    showToast("O canal contem letras, e letras não são permitidas!",context:context);
                                                                                                  }else{
                                                                                                    if(usuario == ""){
                                                                                                      showToast("O usuario não pode estar vazio!",context:context);
                                                                                                    }else{
                                                                                                      if(senha == ""){
                                                                                                        showToast("A senha não pode estar vazia!",context:context);
                                                                                                      }else{
                                                                                                        if(iconeSelecionado == ""){
                                                                                                          showToast("O icone precisa ser selecionado!",context:context);
                                                                                                        }else{
                                                                                                          if(modeloselecionado == ""){
                                                                                                            showToast("O modelo precisa ser selecionado!",context:context);
                                                                                                          }else{
                                                                                                            toDB();
                                                                                                          }
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    },style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: colorBtn
                                                                                  ),
                                                                                    child: Text(
                                                                                      'Criar',
                                                                                      style: TextStyle(
                                                                                          color: textColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Image.asset(
                                                              "assets/fab.png",
                                                              scale: 45
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Stack(
                                                  children: [
                                                    StreamBuilder(stream: FirebaseFirestore.instance
                                                        .collection("Ramais")
                                                        .where("idCondominio", isEqualTo: idCondominio)
                                                        .snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                      if (!snapshot.hasData) {
                                                        return const Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      }
                                                      return Container(
                                                        width: wid / 6,
                                                        height: heig / 2.3,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.blue,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: ListView(
                                                          children: snapshot.data!.docs.map((documents){
                                                            return InkWell(
                                                              onTap: (){
                                                                startCall(context, documents['RamalNumber']);
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.all(3),
                                                                width: double.infinity,
                                                                child: Center(
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                                                          child: const Icon(Icons.call)
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Text("${documents['NomeRamal']}\n${documents['RamalNumber']}"),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      );
                                                    }
                                                    ),
                                                    Container(
                                                      width: wid / 6,
                                                      height: heig / 2.3,
                                                      alignment: Alignment.bottomRight,
                                                      padding: const EdgeInsets.all(16),
                                                      child: adicionarRamal == false ?
                                                      Container():
                                                      TextButton(onPressed:
                                                      idCondominio == "" ? null : (){
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            String NomeRamal = "";
                                                            String RamalNumber = "";

                                                            return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                              return Center(
                                                                child: SingleChildScrollView(
                                                                  child: Dialog(
                                                                    child: Stack(
                                                                      children: [
                                                                        Positioned.fill(
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            child: Image.asset(
                                                                              "assets/FundoMetalPreto.jpg",
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: 600,
                                                                          padding: const EdgeInsets.all(20),
                                                                          child: Column(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                      padding: const EdgeInsets.only(bottom: 16),
                                                                                      child: const Text(
                                                                                        'Crie um Ramal!',
                                                                                        style: TextStyle(
                                                                                          fontSize: 30,
                                                                                        ),
                                                                                      )
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 100,
                                                                                    height: 100,
                                                                                    child: TextButton(onPressed: (){
                                                                                      Navigator.pop(context);
                                                                                    }, child: const Center(
                                                                                      child: Icon(
                                                                                        Icons.close,
                                                                                        size: 40,
                                                                                      ),
                                                                                    )
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Center(
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      child: TextField(
                                                                                        keyboardType: TextInputType.name,
                                                                                        enableSuggestions: true,
                                                                                        autocorrect: true,
                                                                                        onChanged: (value){
                                                                                          setStater(() {
                                                                                            NomeRamal = value;
                                                                                          });
                                                                                        },
                                                                                        decoration: InputDecoration(
                                                                                          filled: true,
                                                                                          fillColor: Colors.white,
                                                                                          labelStyle: TextStyle(
                                                                                              color: textAlertDialogColor,
                                                                                              backgroundColor: Colors.white
                                                                                          ),
                                                                                          border: const OutlineInputBorder(),
                                                                                          enabledBorder: const OutlineInputBorder(
                                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                          ),
                                                                                          focusedBorder: const OutlineInputBorder(
                                                                                            borderSide: BorderSide(
                                                                                                width: 3,
                                                                                                color: Colors.black
                                                                                            ),
                                                                                          ),
                                                                                          label: const Text('Nome do Ramal'),
                                                                                        ),
                                                                                        style: TextStyle(
                                                                                            color: textAlertDialogColor
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Center(
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      child: TextField(
                                                                                        keyboardType: TextInputType.name,
                                                                                        enableSuggestions: true,
                                                                                        autocorrect: true,
                                                                                        onChanged: (value){
                                                                                          setStater(() {
                                                                                            RamalNumber = value;
                                                                                          });
                                                                                        },
                                                                                        decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.white,
                                                                                            labelStyle: TextStyle(
                                                                                                color: textAlertDialogColor,
                                                                                                backgroundColor: Colors.white
                                                                                            ),
                                                                                            border: const OutlineInputBorder(),
                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                            ),
                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                  width: 3,
                                                                                                  color: Colors.black
                                                                                              ),
                                                                                            ),
                                                                                            label: const Text("Numero do Ramal")
                                                                                        ),
                                                                                        style: TextStyle(
                                                                                            color: textAlertDialogColor
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                      onPressed: (){
                                                                                        if(NomeRamal == ""){
                                                                                          showToast("O nome do ramal está vazio!",context:context);
                                                                                        }else{
                                                                                          if(RamalNumber == ""){
                                                                                            showToast("O numero do ramal está vazio!",context:context);
                                                                                          }else{
                                                                                            RegExp numeros = RegExp(r'[a-zA-Z]');
                                                                                            if(RamalNumber.contains(numeros)){
                                                                                              showToast("O ramal contem letras\nSó é permitido numeros!",context:context);
                                                                                            }else{
                                                                                              Uuid uuid = const Uuid();
                                                                                              String UUID = uuid.v4();
                                                                                              FirebaseFirestore.instance.collection('Ramais').doc(UUID).set({
                                                                                                "NomeRamal": NomeRamal,
                                                                                                "RamalNumber": RamalNumber,
                                                                                                "IDEmpresaPertence": UID,
                                                                                                "idCondominio": idCondominio
                                                                                              }).whenComplete((){
                                                                                                Navigator.pop(context);
                                                                                              });
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: colorBtn
                                                                                      ),
                                                                                      child: Text(
                                                                                        'Criar',
                                                                                        style: TextStyle(
                                                                                            color: textColor
                                                                                        ),
                                                                                      )
                                                                                  )
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },);
                                                          },
                                                        );
                                                      },
                                                          child: Image.asset(
                                                              "assets/fab.png",
                                                              scale: 45
                                                          )
                                                      ),
                                                    ),
                                                  ]
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: topbot, top: topbot, left: 200),
                                child: TextButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {

                                          //Strings da API de portas
                                          String IP = "";
                                          String Porta = "";
                                          String Canal = "";
                                          String Usuario = "";
                                          String Senha = "";
                                          String modeloselecionado = "Intelbras";

                                          //Inteiros de gerenciamento de janela
                                          int janela = 1;

                                          //Double do tamanho da janela
                                          double Widet = wid / 3;
                                          double Heigt = wid / 3;

                                          var dropValue4 = ValueNotifier('Intelbras');

                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                            return Center(
                                              child: SingleChildScrollView(
                                                child: Dialog(
                                                  child: Stack(
                                                    children: [
                                                      Positioned.fill(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: Image.asset(
                                                            "assets/FundoMetalPreto.jpg",
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 600,
                                                        padding: const EdgeInsets.all(20),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  'Configurações Geriais',
                                                                  style: TextStyle(
                                                                    fontSize: 25,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 100,
                                                                  height: 100,
                                                                  child: TextButton(onPressed: (){
                                                                    Navigator.pop(context);
                                                                  }, child: const Center(
                                                                    child: Icon(
                                                                      Icons.close,
                                                                      size: 40,
                                                                    ),
                                                                  )
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            acessoDevFunc == true ? Container(
                                                              padding: const EdgeInsets.all(16),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  permissaoCriarUsuarios == true ?
                                                                  ElevatedButton(
                                                                    onPressed: (){
                                                                      setStater((){
                                                                        janela = 1;
                                                                      });
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.blue
                                                                    ),
                                                                    child: Text(
                                                                      "Criação de usuarios",
                                                                      style: TextStyle(
                                                                          color: textAlertDialogColorReverse
                                                                      ),
                                                                    ),
                                                                  ): Container(),
                                                                  ElevatedButton(
                                                                    onPressed: (){
                                                                      setStater((){
                                                                        janela = 2;
                                                                      });
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.blue
                                                                    ),
                                                                    child: Text(
                                                                      "APIs de teste",
                                                                      style: TextStyle(
                                                                          color: textAlertDialogColorReverse
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ): Container(),
                                                            permissaoCriarUsuarios == true? Center(
                                                              child: janela == 1 ?
                                                              Stack(
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.all(16),
                                                                        child: const Text(
                                                                            "Lista de Usuarios",
                                                                            style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold
                                                                            )
                                                                        ),
                                                                      ),
                                                                      StreamBuilder(stream: FirebaseFirestore.instance
                                                                          .collection("Users")
                                                                          .snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                                        if (!snapshot.hasData) {
                                                                          return const Center(
                                                                            child: CircularProgressIndicator(),
                                                                          );
                                                                        }

                                                                        return SizedBox(
                                                                            width: Widet,
                                                                            height: Heigt,
                                                                            child: Center(
                                                                              child: ListView(
                                                                                children: snapshot.data!.docs.map((documents){
                                                                                  return SizedBox(
                                                                                    width: 100,
                                                                                    height: 50,
                                                                                    child: Text(
                                                                                      "Nome: ${documents['Nome']}\nCPF: ${documents['CPF']}",
                                                                                      style: const TextStyle(
                                                                                          fontSize: 16
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  );
                                                                                }).toList(),
                                                                              ),
                                                                            )
                                                                        );
                                                                      }
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    alignment: Alignment.bottomRight,
                                                                    width: Widet,
                                                                    height: Heigt,
                                                                    child: FloatingActionButton(
                                                                      onPressed: (){
                                                                        //Criação do Usuario!

                                                                        //Strings
                                                                        String Nome = "";
                                                                        String CPF = "";
                                                                        String Usrname = "";
                                                                        String Senha = "";
                                                                        String idEmpresa = "";

                                                                        //Booleanos
                                                                        bool addCondominios = false;
                                                                        bool editCFTV = false;
                                                                        bool addAcionamentos = false;
                                                                        bool addRamal = false;
                                                                        bool addMoradores = false;
                                                                        bool addVisitante = false;
                                                                        bool addVeiculos = false;
                                                                        bool criarNovosUsuarios = false;
                                                                        bool acessoDevFuc = false;
                                                                        bool editarAnotacao = false;
                                                                        bool adicionarUsuarioss = false;
                                                                        bool isEmpresa = false;

                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                              return Center(
                                                                                child: Dialog(
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Positioned.fill(
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          child: Image.asset(
                                                                                            "assets/FundoMetalPreto.jpg",
                                                                                            fit: BoxFit.fill,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SingleChildScrollView(
                                                                                        child: Container(
                                                                                          width: 600,
                                                                                          padding: const EdgeInsets.all(20),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  const Text(
                                                                                                    'Criação de Usuario',
                                                                                                    style: TextStyle(
                                                                                                      fontSize: 30,
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    width: 100,
                                                                                                    height: 100,
                                                                                                    child: TextButton(onPressed: (){
                                                                                                      Navigator.pop(context);
                                                                                                    }, child: const Center(
                                                                                                      child: Icon(
                                                                                                        Icons.close,
                                                                                                        size: 40,
                                                                                                      ),
                                                                                                    )
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                              Center(
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  child: TextField(
                                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                                    enableSuggestions: false,
                                                                                                    autocorrect: false,
                                                                                                    onChanged: (value){
                                                                                                      setStater(() {
                                                                                                        Nome = value;
                                                                                                      });
                                                                                                    },
                                                                                                    decoration: InputDecoration(
                                                                                                      filled: true,
                                                                                                      fillColor: Colors.white,
                                                                                                      labelStyle: TextStyle(
                                                                                                          color: textAlertDialogColor,
                                                                                                          backgroundColor: Colors.white
                                                                                                      ),

                                                                                                      border: const OutlineInputBorder(),
                                                                                                      enabledBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                      ),
                                                                                                      focusedBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(
                                                                                                            width: 3,
                                                                                                            color: Colors.black
                                                                                                        ),
                                                                                                      ),
                                                                                                      labelText: 'Nome',
                                                                                                    ),
                                                                                                    style: TextStyle(
                                                                                                        color: textAlertDialogColor
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  child: TextField(
                                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                                    enableSuggestions: false,
                                                                                                    autocorrect: false,
                                                                                                    onChanged: (value){
                                                                                                      setStater(() {
                                                                                                        CPF = value;
                                                                                                      });
                                                                                                    },
                                                                                                    decoration: InputDecoration(
                                                                                                      filled: true,
                                                                                                      fillColor: Colors.white,
                                                                                                      labelStyle: TextStyle(
                                                                                                          color: textAlertDialogColor,
                                                                                                          backgroundColor: Colors.white
                                                                                                      ),
                                                                                                      border: const OutlineInputBorder(),
                                                                                                      enabledBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                      ),
                                                                                                      focusedBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(
                                                                                                            width: 3,
                                                                                                            color: Colors.black
                                                                                                        ),
                                                                                                      ),
                                                                                                      labelText: 'CPF',
                                                                                                    ),
                                                                                                    style: TextStyle(
                                                                                                        color: textAlertDialogColor
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  child: TextField(
                                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                                    enableSuggestions: false,
                                                                                                    autocorrect: false,
                                                                                                    onChanged: (value){
                                                                                                      setStater(() {
                                                                                                        Usrname = value;
                                                                                                      });
                                                                                                    },
                                                                                                    decoration: InputDecoration(
                                                                                                      filled: true,
                                                                                                      fillColor: Colors.white,
                                                                                                      labelStyle: TextStyle(
                                                                                                          color: textAlertDialogColor,
                                                                                                          backgroundColor: Colors.white
                                                                                                      ),
                                                                                                      border: const OutlineInputBorder(),
                                                                                                      enabledBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                      ),
                                                                                                      focusedBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(
                                                                                                            width: 3,
                                                                                                            color: Colors.black
                                                                                                        ),
                                                                                                      ),
                                                                                                      labelText: 'Login',
                                                                                                    ),
                                                                                                    style: TextStyle(
                                                                                                        color: textAlertDialogColor
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  child: TextField(
                                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                                    enableSuggestions: false,
                                                                                                    autocorrect: false,
                                                                                                    onChanged: (value){
                                                                                                      setStater(() {
                                                                                                        Senha = value;
                                                                                                      });
                                                                                                    },
                                                                                                    decoration: InputDecoration(
                                                                                                      filled: true,
                                                                                                      fillColor: Colors.white,
                                                                                                      labelStyle: TextStyle(
                                                                                                          color: textAlertDialogColor,
                                                                                                          backgroundColor: Colors.white
                                                                                                      ),
                                                                                                      border: const OutlineInputBorder(),
                                                                                                      enabledBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                      ),
                                                                                                      focusedBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(
                                                                                                            width: 3,
                                                                                                            color: Colors.black
                                                                                                        ),
                                                                                                      ),
                                                                                                      labelText: 'Senha',
                                                                                                    ),
                                                                                                    style: TextStyle(
                                                                                                        color: textAlertDialogColor
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              isEmpresa == false ? Center(
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  child: TextField(
                                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                                    enableSuggestions: false,
                                                                                                    autocorrect: false,
                                                                                                    onChanged: (value){
                                                                                                      setStater(() {
                                                                                                        idEmpresa = value;
                                                                                                      });
                                                                                                    },
                                                                                                    decoration: InputDecoration(
                                                                                                      filled: true,
                                                                                                      fillColor: Colors.white,
                                                                                                      labelStyle: TextStyle(
                                                                                                          color: textAlertDialogColor,
                                                                                                          backgroundColor: Colors.white
                                                                                                      ),
                                                                                                      border: const OutlineInputBorder(),
                                                                                                      enabledBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                      ),
                                                                                                      focusedBorder: const OutlineInputBorder(
                                                                                                        borderSide: BorderSide(
                                                                                                            width: 3,
                                                                                                            color: Colors.black
                                                                                                        ),
                                                                                                      ),
                                                                                                      labelText: 'ID da Empresa',
                                                                                                    ),
                                                                                                    style: TextStyle(
                                                                                                        color: textAlertDialogColor
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ): Container(),
                                                                                              Center(
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      const Text(
                                                                                                        "É uma conta de controle?\nTipo do Empresa ou Controle?",
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                            fontSize: 16
                                                                                                        ),
                                                                                                        textAlign: TextAlign.center,
                                                                                                      ),
                                                                                                      Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          Checkbox(
                                                                                                            value: isEmpresa,
                                                                                                            onChanged: (bool? value){
                                                                                                              setStater((){
                                                                                                                isEmpresa = value!;
                                                                                                              });
                                                                                                            },
                                                                                                          ),
                                                                                                          const Text(
                                                                                                              'É uma Empresa?',
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: 16
                                                                                                              )
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              const Center(
                                                                                                  child: Text(
                                                                                                      "Permissões",
                                                                                                      style: TextStyle(
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  )
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: addCondominios ,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          addCondominios = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Adicionar novos condominios',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: editCFTV  ,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          editCFTV = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Editar CFTV',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: addAcionamentos,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          addAcionamentos = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Adicionar Acionamentos',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: addRamal,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          addRamal  = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Adicionar Ramal',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: addMoradores ,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          addMoradores = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Adicionar Moradores',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: addVisitante  ,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          addVisitante = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Adicionar Visitantes',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: addVeiculos  ,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          addVeiculos = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Adicionar Veiculos',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: criarNovosUsuarios,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          criarNovosUsuarios  = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Criar novos usuarios',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: editarAnotacao,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          editarAnotacao = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Editar anotação',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: adicionarUsuarioss ,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          adicionarUsuarioss = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Adicionar usuarios',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Center(
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: acessoDevFuc ,
                                                                                                      onChanged: (bool? value){
                                                                                                        setStater((){
                                                                                                          acessoDevFuc = value!;
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    const Text(
                                                                                                        'Acesso as opções de teste e desenvolvimento',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 16
                                                                                                        )
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              ElevatedButton(onPressed: () async {
                                                                                                if(Nome == ""){
                                                                                                  showToast("O nome está vazio!",context:context);
                                                                                                }else{
                                                                                                  if(CPF == ""){
                                                                                                    showToast("O CPF está vazio!",context:context);
                                                                                                  }else{
                                                                                                    if(Usrname == ""){
                                                                                                      showToast("O Login está vazio!",context:context);
                                                                                                    }else{
                                                                                                      if(Senha == ""){
                                                                                                        showToast("A Senha está vazia!",context:context);
                                                                                                      }else{
                                                                                                        FirebaseApp app = await Firebase.initializeApp(
                                                                                                            name: 'Secondary', options: Firebase.app().options
                                                                                                        );
                                                                                                        try{
                                                                                                          Uuid uuid = const Uuid();
                                                                                                          String email = "${uuid.v4()}@email.com";

                                                                                                          var instanciaAuth = FirebaseAuth.instanceFor(app: app);

                                                                                                          instanciaAuth.useAuthEmulator(host, Authport);

                                                                                                          UserCredential userCredential = await instanciaAuth.createUserWithEmailAndPassword(email: email, password: Senha);

                                                                                                          if(isEmpresa == true){
                                                                                                            setStater((){
                                                                                                              idEmpresa = "${userCredential.user?.uid}";
                                                                                                            });
                                                                                                          }

                                                                                                          FirebaseFirestore.instance.collection("Users").doc(userCredential.user?.uid).set({
                                                                                                            "Nome": Nome,
                                                                                                            "username": Usrname.trim(),
                                                                                                            "Email" : email,
                                                                                                            "Senha" : Senha,
                                                                                                            "CPF": CPF,
                                                                                                            "id": userCredential.user?.uid,
                                                                                                            "AdicionarCondominios": addCondominios,
                                                                                                            "acessoDevFunc": acessoDevFuc,
                                                                                                            "adicionaAcionamentos": addAcionamentos,
                                                                                                            "adicionarMoradores": addMoradores,
                                                                                                            "permissaoCriarUsuarios": criarNovosUsuarios,
                                                                                                            "adicionarVeiculo": addVeiculos,
                                                                                                            "adicionarVisitante": addVisitante,
                                                                                                            "editarAnotacao": editarAnotacao,
                                                                                                            "adicionarRamal": adicionarRamal,
                                                                                                            "adicionarUsuarios": adicionarUsuarioss,
                                                                                                            "editarCFTV": editCFTV,
                                                                                                            "idEmpresaPertence": idEmpresa
                                                                                                          }).whenComplete((){
                                                                                                            //Vai exibir uma ação para copiar as credenciais!
                                                                                                            Navigator.pop(context);
                                                                                                            showDialog(
                                                                                                              context: context,
                                                                                                              builder: (BuildContext context) {
                                                                                                                return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                                                                  return AlertDialog(
                                                                                                                    title: const Text('Usuario criado!'),
                                                                                                                    actions: [
                                                                                                                      Center(
                                                                                                                        child: Column(
                                                                                                                          children: [
                                                                                                                            Row(
                                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                              children: [
                                                                                                                                Text("Login: ${Usrname.trim()}"),
                                                                                                                                IconButton(onPressed: (){
                                                                                                                                  FlutterClipboard.copy("Login: ${Usrname.trim()}").then(( value ) {
                                                                                                                                    showToast("Email copiado com sucesso!",context:context);
                                                                                                                                  });
                                                                                                                                },
                                                                                                                                    icon: const Icon(Icons.copy)
                                                                                                                                )
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                            Row(
                                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                              children: [
                                                                                                                                Text("Senha: $Senha"),
                                                                                                                                IconButton(onPressed: (){
                                                                                                                                  FlutterClipboard.copy("Senha: $Senha").then(( value ) {
                                                                                                                                    showToast("Senha copiada com sucesso!",context:context);
                                                                                                                                  });
                                                                                                                                },
                                                                                                                                    icon: const Icon(Icons.copy)
                                                                                                                                )
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                            isEmpresa == true ? Row(
                                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                              children: [
                                                                                                                                Text("ID da Empresa: $idEmpresa"),
                                                                                                                                IconButton(onPressed: (){
                                                                                                                                  FlutterClipboard.copy("Senha: $Senha").then(( value ) {
                                                                                                                                    showToast("ID da Empresa!",context:context);
                                                                                                                                  });
                                                                                                                                },
                                                                                                                                    icon: const Icon(Icons.copy)
                                                                                                                                )
                                                                                                                              ],
                                                                                                                            ):Container(),
                                                                                                                            Row(
                                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                              children: [
                                                                                                                                const Text("Copiar tudo"),
                                                                                                                                IconButton(onPressed: (){
                                                                                                                                  if(isEmpresa == true){
                                                                                                                                    FlutterClipboard.copy("Login: ${Usrname.trim()}\nSenha: $Senha\nID da Empresa: $idEmpresa").then(( value ) {
                                                                                                                                      showToast("Conteúdo copiado com sucesso!",context:context);
                                                                                                                                    });
                                                                                                                                  }else{
                                                                                                                                    FlutterClipboard.copy("Login: ${Usrname.trim()}\nSenha: $Senha").then(( value ) {
                                                                                                                                      showToast("Conteúdo copiado com sucesso!",context:context);
                                                                                                                                    });
                                                                                                                                  }
                                                                                                                                },
                                                                                                                                    icon: const Icon(Icons.copy)
                                                                                                                                )
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                            ElevatedButton(onPressed: (){
                                                                                                                              Navigator.pop(context);
                                                                                                                            },
                                                                                                                              child: const Text("Fechar!"),)
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                      )
                                                                                                                    ],
                                                                                                                  );
                                                                                                                  }
                                                                                                                );
                                                                                                              },
                                                                                                            );
                                                                                                          });

                                                                                                        }catch(e){
                                                                                                          showToast("Ocorreu um erro! $e",context:context);
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              },
                                                                                                  child: const Text("Criar novo usuario!")
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: const Icon(Icons.add),
                                                                    ),
                                                                  )
                                                                ],
                                                              ): janela == 2 ?
                                                              acessoDevFunc == false ?
                                                              Container():
                                                              Column(
                                                                children: [
                                                                  const Center(
                                                                      child: Text(
                                                                          'APIs de Teste',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16
                                                                          )
                                                                      )
                                                                  ),
                                                                  const Center(
                                                                      child: Text(
                                                                          'Teste de acionamentos',
                                                                          style: TextStyle(
                                                                              fontSize: 16
                                                                          )
                                                                      )
                                                                  ),
                                                                  Center(
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(16),
                                                                      child: TextField(
                                                                        keyboardType: TextInputType.emailAddress,
                                                                        enableSuggestions: false,
                                                                        autocorrect: false,
                                                                        onChanged: (value){
                                                                          setStater(() {
                                                                            IP = value;
                                                                          });
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          filled: true,
                                                                          fillColor: Colors.white,
                                                                          labelStyle: TextStyle(
                                                                              color: textAlertDialogColor,
                                                                              backgroundColor: Colors.white
                                                                          ),
                                                                          border: const OutlineInputBorder(),
                                                                          enabledBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                          ),
                                                                          focusedBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width: 3,
                                                                                color: Colors.black
                                                                            ),
                                                                          ),
                                                                          labelText: 'IP',
                                                                        ),
                                                                        style: TextStyle(
                                                                            color: textAlertDialogColor
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(16),
                                                                      child: TextField(
                                                                        keyboardType: TextInputType.emailAddress,
                                                                        enableSuggestions: false,
                                                                        autocorrect: false,
                                                                        onChanged: (value){
                                                                          setStater(() {
                                                                            Porta = value;
                                                                          });
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          filled: true,
                                                                          fillColor: Colors.white,
                                                                          labelStyle: TextStyle(
                                                                              color: textAlertDialogColor,
                                                                              backgroundColor: Colors.white
                                                                          ),
                                                                          border: const OutlineInputBorder(),
                                                                          enabledBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                          ),
                                                                          focusedBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width: 3,
                                                                                color: Colors.black
                                                                            ),
                                                                          ),
                                                                          labelText: 'Porta',
                                                                        ),
                                                                        style: TextStyle(
                                                                            color: textAlertDialogColor
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(16),
                                                                      child: TextField(
                                                                        keyboardType: TextInputType.emailAddress,
                                                                        enableSuggestions: false,
                                                                        autocorrect: false,
                                                                        onChanged: (value){
                                                                          setStater(() {
                                                                            Canal = value;
                                                                          });
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          filled: true,
                                                                          fillColor: Colors.white,
                                                                          labelStyle: TextStyle(
                                                                              color: textAlertDialogColor,
                                                                              backgroundColor: Colors.white
                                                                          ),
                                                                          border: const OutlineInputBorder(),
                                                                          enabledBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                          ),
                                                                          focusedBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width: 3,
                                                                                color: Colors.black
                                                                            ),
                                                                          ),
                                                                          labelText: 'Canal',
                                                                        ),
                                                                        style: TextStyle(
                                                                            color: textAlertDialogColor
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(16),
                                                                      child: TextField(
                                                                        keyboardType: TextInputType.emailAddress,
                                                                        enableSuggestions: false,
                                                                        autocorrect: false,
                                                                        onChanged: (value){
                                                                          setStater(() {
                                                                            Usuario = value;
                                                                          });
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          filled: true,
                                                                          fillColor: Colors.white,
                                                                          labelStyle: TextStyle(
                                                                              color: textAlertDialogColor,
                                                                              backgroundColor: Colors.white
                                                                          ),
                                                                          border: const OutlineInputBorder(),
                                                                          enabledBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                          ),
                                                                          focusedBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width: 3,
                                                                                color: Colors.black
                                                                            ),
                                                                          ),
                                                                          labelText: 'Usuario',
                                                                        ),
                                                                        style: TextStyle(
                                                                            color: textAlertDialogColor
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(16),
                                                                      child: TextField(
                                                                        keyboardType: TextInputType.emailAddress,
                                                                        enableSuggestions: false,
                                                                        autocorrect: false,
                                                                        onChanged: (value){
                                                                          setStater(() {
                                                                            Senha = value;
                                                                          });
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          filled: true,
                                                                          fillColor: Colors.white,
                                                                          labelStyle: TextStyle(
                                                                              color: textAlertDialogColor,
                                                                              backgroundColor: Colors.white
                                                                          ),
                                                                          border: const OutlineInputBorder(),
                                                                          enabledBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                          ),
                                                                          focusedBorder: const OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width: 3,
                                                                                color: Colors.black
                                                                            ),
                                                                          ),
                                                                          labelText: 'Senha',
                                                                        ),
                                                                        style: TextStyle(
                                                                            color: textAlertDialogColor
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child: ValueListenableBuilder(valueListenable: dropValue4, builder: (context, String value, _){
                                                                      return DropdownButton(
                                                                        hint: Text(
                                                                          'Selecione o modelo',
                                                                          style: TextStyle(
                                                                              color: textColorDrop
                                                                          ),
                                                                        ),
                                                                        value: (value.isEmpty)? null : value,
                                                                        onChanged: (escolha) async {
                                                                          dropValue4.value = escolha.toString();
                                                                          setStater(() {
                                                                            modeloselecionado = escolha.toString();
                                                                          });
                                                                        },
                                                                        items: ModelosAcionamentos.map((opcao) => DropdownMenuItem(
                                                                          value: opcao,
                                                                          child:
                                                                          Text(
                                                                            opcao,
                                                                            style: TextStyle(
                                                                                color: textColorDrop
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ).toList(),
                                                                      );
                                                                    }),
                                                                  ),
                                                                  ElevatedButton(
                                                                      onPressed: (){
                                                                        acionarPorta(context, IP, int.parse(Porta), modeloselecionado, int.parse(Canal), Usuario, Senha, "vazio");
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: colorBtn
                                                                      ),
                                                                      child: Text(
                                                                        "Testar!",
                                                                        style: TextStyle(
                                                                            color: textColor
                                                                        ),
                                                                      )
                                                                  ),
                                                                ],
                                                              ): Container(),
                                                            ): Container(),
                                                            Container(
                                                              alignment: Alignment.bottomRight,
                                                              child: ElevatedButton(
                                                                  onPressed: inicializado == true ? (){
                                                                    FirebaseAuth.instance.signOut().whenComplete(() async {
                                                                      setStater((){
                                                                        ip = "";
                                                                        user = "";
                                                                        pass = "";
                                                                        porta = 00;
                                                                        idCondominio = "";
                                                                        anotacao = "";
                                                                        UID = "";
                                                                        deslogando = true;
                                                                        inicializado = false;
                                                                      });
                                                                      final SharedPreferences prefs = await SharedPreferences.getInstance();

                                                                      await prefs.setString('email', "");
                                                                      await prefs.setString('senha', "");

                                                                      Get.to(const login());

                                                                    });
                                                                  }: null,
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.red
                                                                  ),
                                                                  child: const Icon(
                                                                      Icons.exit_to_app,
                                                                      color: Colors.white
                                                                  )
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },);
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent
                                    ),
                                    child: Image.asset(
                                        "assets/Setting-icon.png",
                                        scale: 12
                                    )
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/fundoWidgetContainerMain.png'),
                                    fit: BoxFit.cover,
                                  ),

                                ),
                                child: Column(
                                  children: [
                                    StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                      return SizedBox(
                                        width: wid / 4,
                                        height: heig / 4,
                                        child: Stack(
                                          children: [
                                            idCondominio != "" ?
                                            SingleChildScrollView(
                                              child: StreamBuilder(
                                                stream: pesquisando2 == true ? FirebaseFirestore.instance
                                                    .collection("Pessoas")
                                                    .where("idCondominio", isEqualTo: idCondominio)
                                                    .where("Nome", isGreaterThanOrEqualTo: pesquisa2)
                                                    .where("Nome", isLessThan: "${pesquisa2}z")
                                                    .snapshots():
                                                pesquisaCPF == true ?
                                                FirebaseFirestore.instance
                                                    .collection("Pessoas")
                                                    .where("idCondominio", isEqualTo: idCondominio)
                                                    .where("CPF", isGreaterThanOrEqualTo: pesquisa2)
                                                    .where("CPF", isLessThan: "${pesquisa2}z")
                                                    .snapshots():
                                                FirebaseFirestore.instance
                                                    .collection("Pessoas")
                                                    .where("idCondominio", isEqualTo: idCondominio)
                                                    .snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                                                  if (!snapshot.hasData) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }

                                                  return Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: heig / 4,
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Center(
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  child: Stack(
                                                                    children: [
                                                                      TextField(
                                                                        cursorColor: Colors.black,
                                                                        keyboardType: TextInputType.name,
                                                                        enableSuggestions: true,
                                                                        autocorrect: true,
                                                                        onChanged: (value){
                                                                          pesquisa2 = value;

                                                                          if(value == ""){
                                                                            setStater(() {
                                                                              pesquisando2 = false;
                                                                              pesquisaCPF = false;
                                                                            });
                                                                          }
                                                                        },
                                                                        decoration: const InputDecoration(
                                                                          filled: true,
                                                                          fillColor: Colors.white,
                                                                          border: OutlineInputBorder(),
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(width: 3, color: Colors.white), //<-- SEE HERE
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width: 3,
                                                                                color: Colors.black
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        style: const TextStyle(
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                      Stack(
                                                                        children: [
                                                                          Container(
                                                                              alignment: AlignmentDirectional.centerEnd,
                                                                              child: TextButton(
                                                                                onPressed: (){
                                                                                  if(showSearchBar2 == true){
                                                                                    setStater((){
                                                                                      showSearchBar2 = false;
                                                                                    });
                                                                                  }else{
                                                                                    setStater((){
                                                                                      showSearchBar2 = true;
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: Center(
                                                                                  child: Center(
                                                                                    child: Stack(
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 50,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                        Container(
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: TextButton(
                                                                                              onPressed: null,
                                                                                              child: Image.asset(
                                                                                                  "assets/search.png",
                                                                                                  scale: 14
                                                                                              )
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                          ),
                                                                          showSearchBar2 == true ? Center(
                                                                            child: Stack(
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      padding: const EdgeInsets.all(2),
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          TextField(
                                                                                            cursorColor: Colors.black,
                                                                                            keyboardType: TextInputType.name,
                                                                                            enableSuggestions: true,
                                                                                            autocorrect: true,
                                                                                            onChanged: (value){
                                                                                              pesquisa2 = value;

                                                                                              if(value == ""){
                                                                                                setStater(() {
                                                                                                  pesquisando2 = false;
                                                                                                  pesquisaCPF = false;
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                            decoration: const InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                border: OutlineInputBorder(),
                                                                                                enabledBorder: OutlineInputBorder(
                                                                                                  borderSide: BorderSide(width: 3, color: Colors.white), //<-- SEE HERE
                                                                                                ),
                                                                                                focusedBorder: OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                      width: 3,
                                                                                                      color: Colors.black
                                                                                                  ),
                                                                                                ),
                                                                                                label: Text(
                                                                                                  'Nome',
                                                                                                  style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      backgroundColor: Colors.white
                                                                                                  ),
                                                                                                )
                                                                                            ),
                                                                                            style: const TextStyle(
                                                                                                color: Colors.black
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                              alignment: AlignmentDirectional.centerEnd,
                                                                                              padding: const EdgeInsets.only(right: 35),
                                                                                              child: TextButton(
                                                                                                onPressed: () async {

                                                                                                  if(pesquisa2 == ""){
                                                                                                    setStater(() {
                                                                                                      pesquisando2 = false;
                                                                                                      pesquisaCPF = false;
                                                                                                    });
                                                                                                  }else{
                                                                                                    //Pesquisa de nomes;
                                                                                                    QuerySnapshot snapshotNome = await FirebaseFirestore.instance.collection("Pessoas")
                                                                                                        .where("idCondominio", isEqualTo: idCondominio)
                                                                                                        .where("Nome", isGreaterThanOrEqualTo: pesquisa2)
                                                                                                        .where("Nome", isLessThan: "${pesquisa2}z")
                                                                                                        .get();

                                                                                                    if(snapshotNome.docs.isNotEmpty){
                                                                                                      for (var doc in snapshotNome.docs) {
                                                                                                        //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                                                        //print("Dados: $data");

                                                                                                        setStater((){
                                                                                                          pesquisando2 = true;
                                                                                                        });
                                                                                                      }
                                                                                                    }else{
                                                                                                      showToast("Nada foi encontrado!", context: context);
                                                                                                      setStater((){
                                                                                                        pesquisando2 = true;
                                                                                                      });
                                                                                                    }
                                                                                                  }
                                                                                                },
                                                                                                child: Image.asset(
                                                                                                    "assets/search.png",
                                                                                                    scale: 14
                                                                                                ),
                                                                                              )
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      padding: const EdgeInsets.all(2),
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          TextField(
                                                                                            cursorColor: Colors.black,
                                                                                            keyboardType: TextInputType.name,
                                                                                            enableSuggestions: true,
                                                                                            autocorrect: true,
                                                                                            onChanged: (value){
                                                                                              pesquisa2 = value;

                                                                                              if(value == ""){
                                                                                                setStater(() {
                                                                                                  pesquisando2 = false;
                                                                                                  pesquisaCPF = false;
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                            decoration: const InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                border: OutlineInputBorder(),
                                                                                                enabledBorder: OutlineInputBorder(
                                                                                                  borderSide: BorderSide(width: 3, color: Colors.white), //<-- SEE HERE
                                                                                                ),
                                                                                                focusedBorder: OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                      width: 3,
                                                                                                      color: Colors.black
                                                                                                  ),
                                                                                                ),
                                                                                                label: Text(
                                                                                                  'CPF',
                                                                                                  style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      backgroundColor: Colors.white
                                                                                                  ),
                                                                                                )
                                                                                            ),
                                                                                            style: const TextStyle(
                                                                                                color: Colors.black
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                              alignment: AlignmentDirectional.centerEnd,
                                                                                              padding: const EdgeInsets.only(right: 35),
                                                                                              child: TextButton(
                                                                                                onPressed: () async {

                                                                                                  if(pesquisa2 == ""){
                                                                                                    setStater(() {
                                                                                                      pesquisando2 = false;
                                                                                                      pesquisaCPF = false;
                                                                                                    });
                                                                                                  }else{
                                                                                                    //Pesquisa CPF
                                                                                                    QuerySnapshot snapshotCPF = await FirebaseFirestore.instance.collection("Pessoas")
                                                                                                        .where("idCondominio", isEqualTo: idCondominio)
                                                                                                        .where("CPF", isGreaterThanOrEqualTo: pesquisa2)
                                                                                                        .where("CPF", isLessThan: "${pesquisa2}z")
                                                                                                        .get();

                                                                                                    if(snapshotCPF.docs.isNotEmpty){
                                                                                                      for (var doc in snapshotCPF.docs) {
                                                                                                        //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                                                        //print("Dados: $data");

                                                                                                        setStater((){
                                                                                                          pesquisaCPF = true;
                                                                                                        });
                                                                                                      }
                                                                                                    }else{
                                                                                                      showToast("Nada foi encontrado!", context: context);
                                                                                                      setStater((){
                                                                                                        pesquisaCPF = true;
                                                                                                      });
                                                                                                    }
                                                                                                  }
                                                                                                },
                                                                                                child: Image.asset(
                                                                                                    "assets/search.png",
                                                                                                    scale: 14
                                                                                                ),
                                                                                              )
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Container(
                                                                                  alignment: Alignment.topRight,
                                                                                  child: TextButton(
                                                                                    onPressed: (){
                                                                                      showSearchBar2 = true;
                                                                                      if(showSearchBar2 == true){
                                                                                        setStater((){
                                                                                          pesquisando2 = false;
                                                                                          pesquisaCPF = false;
                                                                                          showSearchBar2 = false;
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: const Icon(
                                                                                        Icons.close,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ) : Container(),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: double.infinity,
                                                                height: heig / 7,
                                                                child: ListView(
                                                                  children: snapshot.data!.docs.map((documents){
                                                                    return InkWell(
                                                                      onTap: (){
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            String anotacaoMorador = documents["anotacao"];
                                                                            String nomeMorador = documents["Nome"];
                                                                            String RGMorador = documents["RG"];
                                                                            String CPFMorador = documents["CPF"];
                                                                            String UnidadeMorador = documents["Unidade"];
                                                                            String BlocoMorador = documents["Bloco"];
                                                                            String TelefoneMorador = documents["Telefone"];
                                                                            String CelularMorador = documents["Celular"];
                                                                            String QualificacaoMorador = documents["Qualificacao"];

                                                                            TextEditingController anotacaoControl = TextEditingController(text: anotacaoMorador);
                                                                            TextEditingController nomeMoradorController = TextEditingController(text: nomeMorador);
                                                                            TextEditingController RGMoradorController = TextEditingController(text: RGMorador);
                                                                            TextEditingController CPFMoradorController = TextEditingController(text: CPFMorador);
                                                                            TextEditingController UnidadeMoradorController = TextEditingController(text: UnidadeMorador);
                                                                            TextEditingController BlocoMoradorController = TextEditingController(text: BlocoMorador);
                                                                            TextEditingController TelefoneMoradorController = TextEditingController(text: TelefoneMorador);
                                                                            TextEditingController CelularMoradorController = TextEditingController(text: CelularMorador);
                                                                            TextEditingController QualificacaoMoradorController = TextEditingController(text: QualificacaoMorador);

                                                                            bool editarInfosMorador = false;

                                                                            double widthe = 600;
                                                                            double heighte = 660;

                                                                            return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                              if(editarInfosMorador == true){
                                                                                widthe = 600;
                                                                                heighte = 1000;
                                                                              }else{
                                                                                widthe = 600;
                                                                                heighte = 660;
                                                                              }
                                                                              return Center(
                                                                                child: Dialog(
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Positioned.fill(
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          child: Image.asset(
                                                                                            "assets/FundoMetalPreto.jpg",
                                                                                            fit: BoxFit.fill,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                          width: widthe,
                                                                                          height: heighte,
                                                                                          child: SingleChildScrollView(
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      padding: const EdgeInsets.all(16),
                                                                                                      child: const Text(
                                                                                                        'Informações do morador',
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 25,
                                                                                                            fontWeight: FontWeight.bold
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                        width: 100,
                                                                                                        height: 100,
                                                                                                        child: TextButton(onPressed: (){
                                                                                                          Navigator.pop(context);
                                                                                                        }, child: const Center(
                                                                                                          child: Icon(
                                                                                                            Icons.close,
                                                                                                            size: 40,
                                                                                                          ),
                                                                                                        )
                                                                                                        )
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                                Fluid(
                                                                                                  children: [
                                                                                                    Fluidable(
                                                                                                      fluid: 1,
                                                                                                      minWidth: 100,
                                                                                                      child: documents["imageURI"] != ""?
                                                                                                      Container(
                                                                                                          padding: const EdgeInsets.all(25),
                                                                                                          child: Image.network(
                                                                                                              height: 200,
                                                                                                              width: 200,
                                                                                                              documents["imageURI"]
                                                                                                          )
                                                                                                      ): Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          padding: const EdgeInsets.all(8),
                                                                                                          child: const Text(
                                                                                                            "Nenhuma imagem encontrada!",
                                                                                                            textAlign: TextAlign.center,
                                                                                                          )
                                                                                                      ),
                                                                                                    ),
                                                                                                    Fluidable(
                                                                                                      fluid: 1,
                                                                                                      minWidth: 200,
                                                                                                      child: Center(
                                                                                                        child: editarInfosMorador == false ? Column(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            Container(
                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                child: Text(
                                                                                                                  "Nome: ${documents["Nome"]}",
                                                                                                                  textAlign: TextAlign.start,
                                                                                                                )
                                                                                                            ),
                                                                                                            Container(
                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                child: Text("RG: ${documents["RG"]}")
                                                                                                            ),
                                                                                                            Container(
                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                child: Text("CPF: ${documents["CPF"]}",)
                                                                                                            ),
                                                                                                            Container(
                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                child: Text("Unidade: ${documents["Unidade"]}")
                                                                                                            ),
                                                                                                            Container(
                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                child: Text("Bloco: ${documents["Bloco"]}")
                                                                                                            ),
                                                                                                            Container(
                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                child: Text("Telefone: ${documents["Telefone"]}")
                                                                                                            ),
                                                                                                            Container(
                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                child: Text("Celular: ${documents["Celular"]}")
                                                                                                            ),
                                                                                                            Container(
                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                child: Text("Qualificacao: ${documents["Qualificacao"]}")
                                                                                                            ),
                                                                                                          ],
                                                                                                        ) : Column(
                                                                                                          children: [
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: nomeMoradorController,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      nomeMorador = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    labelStyle: TextStyle(
                                                                                                                        color: textAlertDialogColor,
                                                                                                                        backgroundColor: Colors.white
                                                                                                                    ),
                                                                                                                    border: const OutlineInputBorder(),
                                                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                    ),
                                                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                          width: 3,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: 'Nome',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: RGMoradorController,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      RGMorador = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    labelStyle: TextStyle(
                                                                                                                        color: textAlertDialogColor,
                                                                                                                        backgroundColor: Colors.white
                                                                                                                    ),
                                                                                                                    border: const OutlineInputBorder(),
                                                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                    ),
                                                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                          width: 3,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: 'RG',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: CPFMoradorController,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      CPFMorador = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    labelStyle: TextStyle(
                                                                                                                        color: textAlertDialogColor,
                                                                                                                        backgroundColor: Colors.white
                                                                                                                    ),
                                                                                                                    border: const OutlineInputBorder(),
                                                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                    ),
                                                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                          width: 3,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: 'CPF',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: UnidadeMoradorController,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      UnidadeMorador = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    labelStyle: TextStyle(
                                                                                                                        color: textAlertDialogColor,
                                                                                                                        backgroundColor: Colors.white
                                                                                                                    ),
                                                                                                                    border: const OutlineInputBorder(),
                                                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                    ),
                                                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                          width: 3,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: 'Unidade',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: BlocoMoradorController,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      BlocoMorador = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    labelStyle: TextStyle(
                                                                                                                        color: textAlertDialogColor,
                                                                                                                        backgroundColor: Colors.white
                                                                                                                    ),
                                                                                                                    border: const OutlineInputBorder(),
                                                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                    ),
                                                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                          width: 3,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: 'Bloco',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: TelefoneMoradorController,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      TelefoneMorador = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    labelStyle: TextStyle(
                                                                                                                        color: textAlertDialogColor,
                                                                                                                        backgroundColor: Colors.white
                                                                                                                    ),
                                                                                                                    border: const OutlineInputBorder(),
                                                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                    ),
                                                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                          width: 3,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: 'Telefone',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: CelularMoradorController,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      CelularMorador = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    labelStyle: TextStyle(
                                                                                                                        color: textAlertDialogColor,
                                                                                                                        backgroundColor: Colors.white
                                                                                                                    ),
                                                                                                                    border: const OutlineInputBorder(),
                                                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                    ),
                                                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                          width: 3,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: 'Celular',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: QualificacaoMoradorController,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      QualificacaoMorador = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    labelStyle: TextStyle(
                                                                                                                        color: textAlertDialogColor,
                                                                                                                        backgroundColor: Colors.white
                                                                                                                    ),
                                                                                                                    border: const OutlineInputBorder(),
                                                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                                    ),
                                                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                          width: 3,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: 'Qualificação',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            ElevatedButton(
                                                                                                                onPressed: (){
                                                                                                                  FirebaseFirestore.instance.collection('Pessoas').doc(documents['id']).update({
                                                                                                                    'Nome': nomeMorador,
                                                                                                                    'RG': RGMorador,
                                                                                                                    'CPF': CPFMorador,
                                                                                                                    'Unidade': UnidadeMorador,
                                                                                                                    'Bloco': BlocoMorador,
                                                                                                                    'Telefone': TelefoneMorador,
                                                                                                                    'Celular': CelularMorador,
                                                                                                                    'Qualificacao': QualificacaoMorador,
                                                                                                                  }).whenComplete((){
                                                                                                                    setStater((){
                                                                                                                      editarInfosMorador = false;
                                                                                                                    });
                                                                                                                    showToast("Informações salvas com sucesso!", context: context);
                                                                                                                  });
                                                                                                                },
                                                                                                                child: const Text('Salvar')
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Container(
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  child: TextField(
                                                                                                    keyboardType: TextInputType.multiline,
                                                                                                    enableSuggestions: true,
                                                                                                    autocorrect: true,
                                                                                                    minLines: 5,
                                                                                                    maxLines: null,
                                                                                                    controller: anotacaoControl,
                                                                                                    onChanged: (value){
                                                                                                      setStater(() {
                                                                                                        anotacaoMorador = value;
                                                                                                      });
                                                                                                    },
                                                                                                    decoration: const InputDecoration(
                                                                                                      filled: true,
                                                                                                      fillColor: Colors.white,
                                                                                                      border: OutlineInputBorder(),
                                                                                                      enabledBorder: OutlineInputBorder(
                                                                                                        borderSide: BorderSide(width: 3, color: Colors.black),
                                                                                                      ),
                                                                                                      focusedBorder: OutlineInputBorder(
                                                                                                        borderSide: BorderSide(
                                                                                                            width: 3,
                                                                                                            color: Colors.black
                                                                                                        ),
                                                                                                      ),
                                                                                                      label: Text('Anotação',
                                                                                                        style: TextStyle(
                                                                                                            color: Colors.black,
                                                                                                            backgroundColor: Colors.white
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    style: const TextStyle(
                                                                                                        color: Colors.black
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  padding: const EdgeInsets.only(bottom: 10),
                                                                                                  child: ElevatedButton(
                                                                                                      onPressed: (){
                                                                                                        FirebaseFirestore.instance.collection('Pessoas').doc(documents['id']).update({
                                                                                                          'anotacao': anotacaoMorador
                                                                                                        }).whenComplete((){
                                                                                                          showToast("Anotação salva com sucesso!", context: context);
                                                                                                        });
                                                                                                      },
                                                                                                      child: const Text('Salvar anotação')
                                                                                                  ),
                                                                                                ),
                                                                                                editarInfosMorador == false ? adicionarMoradores == true ?
                                                                                                ElevatedButton(
                                                                                                  onPressed: (){
                                                                                                    setStater((){
                                                                                                      editarInfosMorador = true;
                                                                                                    });
                                                                                                  },
                                                                                                  child: const Text('Editar informações'),
                                                                                                ): Container()
                                                                                                    : Container()
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                             }
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: SizedBox(
                                                                        width: double.infinity,
                                                                        height: 50,
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Text(
                                                                                "Nome: ${documents['Nome']}"
                                                                                    "\nCPF: ${documents['CPF']}",
                                                                                style: documents['Nome'].length >= 20 && documents['Nome'].length <= 29 ?
                                                                                TextStyle(
                                                                                    color: textColorInitBlue,
                                                                                    fontSize: 9,
                                                                                    fontWeight: FontWeight.bold
                                                                                ): documents['Nome'].length >= 30 ?
                                                                                TextStyle(
                                                                                    color: textColorInitBlue,
                                                                                    fontSize: 8,
                                                                                    fontWeight: FontWeight.bold
                                                                                ):
                                                                                TextStyle(
                                                                                    color: textColorInitBlue,
                                                                                    fontSize: 14
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            adicionarMoradores == true ?
                                                                            Container(
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: TextButton(
                                                                                onPressed: (){
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: const Text('Você tem certeza que deseja\nremover esse morador?'),
                                                                                        actions: [
                                                                                          Column(
                                                                                            children: [
                                                                                              Container(
                                                                                                padding: const EdgeInsets.all(3),
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    Text("Nome: ${documents['Nome']}"),
                                                                                                    Text("CPF: ${documents['CPF']}"),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                padding: const EdgeInsets.all(3),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                  children: [
                                                                                                    ElevatedButton(
                                                                                                        onPressed: (){
                                                                                                            Navigator.pop(context);
                                                                                                        },
                                                                                                        child: const Text('Não')
                                                                                                    ),
                                                                                                    ElevatedButton(
                                                                                                        onPressed: (){
                                                                                                          FirebaseFirestore.instance.collection('Pessoas').doc("${documents['id']}").delete().whenComplete((){
                                                                                                            Navigator.pop(context);
                                                                                                            showToast("Deletado com sucesso!", context: context);
                                                                                                            }
                                                                                                          );
                                                                                                      },
                                                                                                        child: const Text('Sim')
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: const Icon(
                                                                                  Icons.delete,
                                                                                  color: Colors.red
                                                                                ),
                                                                              ),
                                                                            ) : Container()
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ):  Center(
                                              child: Center(
                                                  child: Container(
                                                      width: wid / 4,
                                                      height: heig / 4,
                                                      padding: const EdgeInsets.all(16),
                                                      child: Text(
                                                        'Selecione algum cliente',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: textColorWidgets
                                                        ),
                                                      )
                                                  )
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              padding: const EdgeInsets.all(16),
                                              child: adicionarMoradores == false ?
                                              Container():
                                              TextButton(
                                                  onPressed: idCondominio == "" ? null : (){
                                                    String NomeV = "";
                                                    String CPFV = "";
                                                    String RGV = "";
                                                    String Unidade = "";
                                                    String Bloco = "";
                                                    String modeloPikado = "Control iD";

                                                    int portaAc = 8080;

                                                    String usuarioAc = "";
                                                    String senhAc = "";
                                                    String ipAcionamento = "";
                                                    String Telefone = "";
                                                    String Celular = "";
                                                    String Qualificacao = "";
                                                    String Observacoes = "";
                                                    String modeloAcionamento = '';

                                                    File? _imageFile;

                                                    final picker = ImagePicker();

                                                    var dropValue2 = ValueNotifier('Control iD');

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                          return Center(
                                                            child: SingleChildScrollView(
                                                              child: Dialog(
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned.fill(
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        child: Image.asset(
                                                                          "assets/FundoMetalPreto.jpg",
                                                                          fit: BoxFit.fill,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 600,
                                                                      padding: const EdgeInsets.all(16),
                                                                      child: Column(
                                                                        children: [
                                                                          Center(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                const Text(
                                                                                  'Cadastre um morador',
                                                                                  style: TextStyle(
                                                                                    fontSize: 30,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 100,
                                                                                  height: 100,
                                                                                  child: TextButton(onPressed: (){
                                                                                    Navigator.pop(context);
                                                                                  }, child: const Center(
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 40,
                                                                                    ),
                                                                                  )
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: ElevatedButton(
                                                                                onPressed: (){
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return Center(
                                                                                        child: SingleChildScrollView(
                                                                                          child: Dialog(
                                                                                            child: Stack(
                                                                                              children: [
                                                                                                Positioned.fill(
                                                                                                  child: ClipRRect(
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    child: Image.asset(
                                                                                                      "assets/FundoMetalPreto.jpg",
                                                                                                      fit: BoxFit.fill,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  width: 600,
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          Container(
                                                                                                            padding: const EdgeInsets.all(10),
                                                                                                            child: const Text(
                                                                                                              'Importar usuarios diretamente do equipamento',
                                                                                                              style: TextStyle(
                                                                                                                fontSize: 20,
                                                                                                                fontWeight: FontWeight.bold
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            width: 80,
                                                                                                            height: 80,
                                                                                                            child: TextButton(onPressed: (){
                                                                                                              Navigator.pop(context);
                                                                                                            },
                                                                                                                child: const Center(
                                                                                                                  child: Icon(
                                                                                                                    Icons.close,
                                                                                                                    size: 35,
                                                                                                                  ),
                                                                                                                )
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        width: 600,
                                                                                                        height: 500,
                                                                                                        child: StreamBuilder(
                                                                                                          stream: FirebaseFirestore.instance
                                                                                                              .collection('acionamentos')
                                                                                                              .where("idCondominio", isEqualTo: idCondominio)
                                                                                                              .where("modelo", whereIn: ["Control iD", "Hikvision"])
                                                                                                              .snapshots(),
                                                                                                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                                            if (snapshot.hasError) {
                                                                                                              return const Center(child:
                                                                                                              Text('Algo deu errado!')
                                                                                                              );
                                                                                                            }

                                                                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                              return const Center(child: CircularProgressIndicator());
                                                                                                            }

                                                                                                            if (snapshot.hasData) {
                                                                                                              return GridView.count(
                                                                                                                  childAspectRatio: 1.2,
                                                                                                                  crossAxisCount: 3,
                                                                                                                  children: snapshot.data!.docs.map((documents) {
                                                                                                                    double tamanhotext = 14;
                                                                                                                    bool isBolded = false;

                                                                                                                    if(documents["nome"].length >= 16){
                                                                                                                      tamanhotext = 12;
                                                                                                                    }

                                                                                                                    if(documents["nome"].length >= 20){
                                                                                                                      tamanhotext = 9;
                                                                                                                      isBolded = true;
                                                                                                                    }

                                                                                                                    return Container(
                                                                                                                      padding: const EdgeInsets.all(16),
                                                                                                                      child: Column(
                                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                        children: [
                                                                                                                          SizedBox(
                                                                                                                            height: 50,
                                                                                                                            child: TextButton(
                                                                                                                                onPressed: () async {

                                                                                                                                  showDialog(
                                                                                                                                    context: context,
                                                                                                                                    builder: (BuildContext context) {
                                                                                                                                      return const AlertDialog(
                                                                                                                                        title: Text('Aguarde!'),
                                                                                                                                        actions: [
                                                                                                                                          Center(
                                                                                                                                            child: CircularProgressIndicator(),
                                                                                                                                          )
                                                                                                                                        ],
                                                                                                                                      );
                                                                                                                                    },
                                                                                                                                  );
                                                                                                                                  if(documents['modelo'] == 'Control iD'){
                                                                                                                                    Map<String, dynamic> usuarios = await pushPessoas(context, documents['ip'], documents['porta'], documents['usuario'], documents['senha'], documents['modelo']);

                                                                                                                                    String ImageURL = "";

                                                                                                                                    int lent = usuarios['users'].length - 1;

                                                                                                                                    for (int i = 0; i < lent; i++) {

                                                                                                                                      cadastrarPs(){
                                                                                                                                        FirebaseFirestore.instance.collection('Pessoas').doc("${usuarios['users'][i]["id"]}$idCondominio").set({
                                                                                                                                          "id": "${usuarios['users'][i]["id"]}$idCondominio",
                                                                                                                                          "idCondominio": idCondominio,
                                                                                                                                          "Nome": usuarios['users'][i]["name"],
                                                                                                                                          "CPF": "",
                                                                                                                                          "RG": "",
                                                                                                                                          "imageURI": ImageURL,
                                                                                                                                          "placa": "",
                                                                                                                                          "Unidade":"",
                                                                                                                                          "Bloco": "",
                                                                                                                                          "Celular": "",
                                                                                                                                          "anotacao": "",
                                                                                                                                          "Telefone": '',
                                                                                                                                          "Qualificacao": '',
                                                                                                                                        });
                                                                                                                                      }

                                                                                                                                      cadastrarSemFoto(){
                                                                                                                                        FirebaseFirestore.instance.collection('Pessoas').doc("${usuarios['users'][i]["id"]}$idCondominio").set({
                                                                                                                                          "id": "${usuarios['users'][i]["id"]}$idCondominio",
                                                                                                                                          "idCondominio": idCondominio,
                                                                                                                                          "Nome": usuarios['users'][i]["name"],
                                                                                                                                          "CPF": "",
                                                                                                                                          "RG": "",
                                                                                                                                          "imageURI": '',
                                                                                                                                          "placa": "",
                                                                                                                                          "Unidade":"",
                                                                                                                                          "Bloco": "",
                                                                                                                                          "Telefone": "",
                                                                                                                                          "Celular": "",
                                                                                                                                          "anotacao": "",
                                                                                                                                          "Qualificacao": '',
                                                                                                                                        });
                                                                                                                                      }

                                                                                                                                      File image;

                                                                                                                                      if(await ImagemEquipamentoCotroliD(documents['ip'], documents['porta'], usuarios['Season'], usuarios['users'][i]["id"]) == null){
                                                                                                                                        cadastrarSemFoto();
                                                                                                                                      }else{
                                                                                                                                        image = await ImagemEquipamentoCotroliD(documents['ip'], documents['porta'], usuarios['Season'], usuarios['users'][i]["id"]);

                                                                                                                                        ImageURL = await carregarImagem(context, image, "$i", idCondominio);
                                                                                                                                        cadastrarPs();

                                                                                                                                      }
                                                                                                                                    }
                                                                                                                                    Navigator.pop(context);
                                                                                                                                    Navigator.pop(context);
                                                                                                                                    Navigator.pop(context);
                                                                                                                                    showToast("Importado com sucesso!", context: context);
                                                                                                                                  }
                                                                                                                                  if(documents['modelo'] == 'Hikvision'){
                                                                                                                                    Map userInfo = await pushPessoas(context, documents['ip'], documents['porta'], documents['usuario'], documents['senha'], documents['modelo']);

                                                                                                                                    List<dynamic> Tratado = userInfo['UserInfoSearch']['UserInfo'];

                                                                                                                                    int lent = Tratado.length - 1;

                                                                                                                                    for (int i = 0; i < lent; i++) {
                                                                                                                                      FirebaseFirestore.instance.collection('Pessoas').doc("${userInfo['UserInfoSearch']['UserInfo'][i]['employeeNo']}$idCondominio").set({
                                                                                                                                        "id": "${userInfo['UserInfoSearch']['UserInfo'][i]['employeeNo']}$idCondominio",
                                                                                                                                        "idCondominio": idCondominio,
                                                                                                                                        "Nome": userInfo['UserInfoSearch']['UserInfo'][i]['name'],
                                                                                                                                        "CPF": "",
                                                                                                                                        "RG": "",
                                                                                                                                        "imageURI": '',
                                                                                                                                        "placa": "",
                                                                                                                                        "Unidade":"",
                                                                                                                                        "Bloco": "",
                                                                                                                                        "Telefone": "",
                                                                                                                                        "Celular": "",
                                                                                                                                        "anotacao": "",
                                                                                                                                        "Qualificacao": '',
                                                                                                                                      });
                                                                                                                                    }
                                                                                                                                    Navigator.pop(context);
                                                                                                                                    Navigator.pop(context);
                                                                                                                                    Navigator.pop(context);
                                                                                                                                    showToast("Importado com sucesso!", context: context);
                                                                                                                                  }
                                                                                                                                },
                                                                                                                                child: Stack(
                                                                                                                                  alignment: Alignment.center,
                                                                                                                                  children: [
                                                                                                                                    Image.asset(
                                                                                                                                      documents["deuErro"] == true ?
                                                                                                                                      "assets/btnIsNotAbleToConnect.png":
                                                                                                                                      documents["prontoParaAtivar"] == false ?
                                                                                                                                      "assets/btnInactive.png" :
                                                                                                                                      "assets/btnIsAbleToAction.png",
                                                                                                                                      scale: 5,
                                                                                                                                    ),
                                                                                                                                    Image.asset(
                                                                                                                                        documents["iconeSeleciondo"],
                                                                                                                                        scale: 45
                                                                                                                                    ),
                                                                                                                                  ],
                                                                                                                                )
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          Text(
                                                                                                                            documents["nome"],
                                                                                                                            style: isBolded == true?
                                                                                                                            TextStyle(
                                                                                                                                color: textAlertDialogColorReverse,
                                                                                                                                fontSize: tamanhotext,
                                                                                                                                fontWeight: FontWeight.bold
                                                                                                                            )
                                                                                                                                :
                                                                                                                            TextStyle(
                                                                                                                              color: textAlertDialogColorReverse,
                                                                                                                              fontSize: tamanhotext,
                                                                                                                            ),
                                                                                                                            textAlign: TextAlign.center,
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    );
                                                                                                                  }).toList().reversed.toList()
                                                                                                              );
                                                                                                            }
                                                                                                            return const Center(
                                                                                                                child: Text('Sem dados!',)
                                                                                                            );
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.blue
                                                                                ),
                                                                                child: const Text(
                                                                                  "Importar",
                                                                                  style: TextStyle(
                                                                                      color: Colors.white
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(16),
                                                                              child: TextField(
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                enableSuggestions: false,
                                                                                autocorrect: false,
                                                                                onChanged: (value){
                                                                                  setStater(() {
                                                                                    NomeV = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  filled: true,
                                                                                  fillColor: Colors.white,
                                                                                  labelStyle: TextStyle(
                                                                                      color: textAlertDialogColor,
                                                                                      backgroundColor: Colors.white
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                  labelText: 'Nome',
                                                                                ),
                                                                                style: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(16),
                                                                              child: TextField(
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                enableSuggestions: false,
                                                                                autocorrect: false,
                                                                                onChanged: (value){
                                                                                  setStater(() {
                                                                                    CPFV = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  filled: true,
                                                                                  fillColor: Colors.white,
                                                                                  labelStyle: TextStyle(
                                                                                      color: textAlertDialogColor,
                                                                                      backgroundColor: Colors.white
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                  labelText: 'CPF',
                                                                                ),
                                                                                style: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(16),
                                                                              child: TextField(
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                enableSuggestions: false,
                                                                                autocorrect: false,
                                                                                onChanged: (value){
                                                                                  setStater(() {
                                                                                    RGV = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  filled: true,
                                                                                  fillColor: Colors.white,
                                                                                  labelStyle: TextStyle(
                                                                                      color: textAlertDialogColor,
                                                                                      backgroundColor: Colors.white
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                  labelText: 'RG',
                                                                                ),
                                                                                style: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(16),
                                                                              child: TextField(
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                enableSuggestions: false,
                                                                                autocorrect: false,
                                                                                onChanged: (value){
                                                                                  setStater(() {
                                                                                    Unidade = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  filled: true,
                                                                                  fillColor: Colors.white,
                                                                                  labelStyle: TextStyle(
                                                                                      color: textAlertDialogColor,
                                                                                      backgroundColor: Colors.white
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                  labelText: 'Unidade',
                                                                                ),
                                                                                style: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(16),
                                                                              child: TextField(
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                enableSuggestions: false,
                                                                                autocorrect: false,
                                                                                onChanged: (value){
                                                                                  setStater(() {
                                                                                    Bloco = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  filled: true,
                                                                                  fillColor: Colors.white,
                                                                                  labelStyle: TextStyle(
                                                                                      color: textAlertDialogColor,
                                                                                      backgroundColor: Colors.white
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                  labelText: 'Bloco',
                                                                                ),
                                                                                style: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(16),
                                                                              child: TextField(
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                enableSuggestions: false,
                                                                                autocorrect: false,
                                                                                onChanged: (value){
                                                                                  setStater(() {
                                                                                    Telefone = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  filled: true,
                                                                                  fillColor: Colors.white,
                                                                                  labelStyle: TextStyle(
                                                                                      color: textAlertDialogColor,
                                                                                      backgroundColor: Colors.white
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                  labelText: 'Telefone',
                                                                                ),
                                                                                style: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(16),
                                                                              child: TextField(
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                enableSuggestions: false,
                                                                                autocorrect: false,
                                                                                onChanged: (value){
                                                                                  setStater(() {
                                                                                    Celular = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  filled: true,
                                                                                  fillColor: Colors.white,
                                                                                  labelStyle: TextStyle(
                                                                                      color: textAlertDialogColor,
                                                                                      backgroundColor: Colors.white
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                  labelText: 'Celular',
                                                                                ),
                                                                                style: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(16),
                                                                              child: TextField(
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                enableSuggestions: false,
                                                                                autocorrect: false,
                                                                                onChanged: (value){
                                                                                  setStater(() {
                                                                                    Qualificacao = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  filled: true,
                                                                                  fillColor: Colors.white,
                                                                                  labelStyle: TextStyle(
                                                                                      color: textAlertDialogColor,
                                                                                      backgroundColor: Colors.white
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                  ),
                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  ),
                                                                                  labelText: 'Qualificacao',
                                                                                ),
                                                                                style: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding: const EdgeInsets.all(16),
                                                                            child: TextField(
                                                                              keyboardType: TextInputType.multiline,
                                                                              enableSuggestions: true,
                                                                              autocorrect: true,
                                                                              minLines: 5,
                                                                              maxLines: null,
                                                                              onChanged: (value){
                                                                                setStater(() {
                                                                                  Observacoes = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor,
                                                                                    backgroundColor: Colors.white
                                                                                ),
                                                                                border: const OutlineInputBorder(),
                                                                                enabledBorder: const OutlineInputBorder(
                                                                                  borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                ),
                                                                                focusedBorder: const OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                ),
                                                                                labelText: 'Observações',
                                                                              ),
                                                                              style: TextStyle(
                                                                                  color: textAlertDialogColor
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
                                                                              return DropdownButton(
                                                                                hint: Text(
                                                                                  'Selecione o modelo da Facial',
                                                                                  style: TextStyle(
                                                                                      color: textColorDrop
                                                                                  ),
                                                                                ),
                                                                                value: (value.isEmpty)? null : value,
                                                                                onChanged: (escolha) async {
                                                                                  dropValue2.value = escolha.toString();
                                                                                  setStater(() {
                                                                                    modeloPikado = escolha.toString();
                                                                                  });
                                                                                },
                                                                                items: ImportarUsuarios.map((opcao) => DropdownMenuItem(
                                                                                  value: opcao,
                                                                                  child:
                                                                                  Text(
                                                                                    opcao,
                                                                                    style: TextStyle(
                                                                                        color: textColorDrop
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                ).toList(),
                                                                              );
                                                                            }),
                                                                          ),
                                                                          modeloPikado == "Outros" ?
                                                                          Container()
                                                                              :
                                                                          SizedBox(
                                                                            width: 600,
                                                                            height: 500,
                                                                            child: StreamBuilder(
                                                                              stream: FirebaseFirestore.instance
                                                                                  .collection('acionamentos')
                                                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                                                  .where("modelo", isEqualTo: modeloPikado)
                                                                                  .snapshots(),
                                                                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                if (snapshot.hasError) {
                                                                                  return const Center(child:
                                                                                  Text('Algo deu errado!')
                                                                                  );
                                                                                }

                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                  return const Center(child: CircularProgressIndicator());
                                                                                }

                                                                                if (snapshot.hasData) {
                                                                                  return GridView.count(
                                                                                      childAspectRatio: 1.2,
                                                                                      crossAxisCount: 3,
                                                                                      children: snapshot.data!.docs.map((documents) {
                                                                                        double tamanhotext = 14;
                                                                                        bool isBolded = false;

                                                                                        if(documents["nome"].length >= 16){
                                                                                          tamanhotext = 12;
                                                                                        }

                                                                                        if(documents["nome"].length >= 20){
                                                                                          tamanhotext = 9;
                                                                                          isBolded = true;
                                                                                        }

                                                                                        return Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: 50,
                                                                                                child: TextButton(
                                                                                                    onPressed: () async {

                                                                                                      setStater((){
                                                                                                        ipAcionamento = documents['ip'];
                                                                                                        portaAc = documents['porta'];
                                                                                                        usuarioAc = documents['usuario'];
                                                                                                        senhAc = documents['senha'];
                                                                                                        modeloAcionamento = documents['modelo'];
                                                                                                      });
                                                                                                      showToast("Dados selecionados", context: context);
                                                                                                    },
                                                                                                    child: Stack(
                                                                                                      alignment: Alignment.center,
                                                                                                      children: [
                                                                                                        Image.asset(
                                                                                                          documents["deuErro"] == true ?
                                                                                                          "assets/btnIsNotAbleToConnect.png":
                                                                                                          documents["prontoParaAtivar"] == false ?
                                                                                                          "assets/btnInactive.png" :
                                                                                                          "assets/btnIsAbleToAction.png",
                                                                                                          scale: 5,
                                                                                                        ),
                                                                                                        Image.asset(
                                                                                                            documents["iconeSeleciondo"],
                                                                                                            scale: 45
                                                                                                        ),
                                                                                                      ],
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                documents["nome"],
                                                                                                style: isBolded == true?
                                                                                                TextStyle(
                                                                                                    color: textAlertDialogColorReverse,
                                                                                                    fontSize: tamanhotext,
                                                                                                    fontWeight: FontWeight.bold
                                                                                                )
                                                                                                    :
                                                                                                TextStyle(
                                                                                                  color: textAlertDialogColorReverse,
                                                                                                  fontSize: tamanhotext,
                                                                                                ),
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      }).toList().reversed.toList()
                                                                                  );
                                                                                }
                                                                                return const Center(
                                                                                    child: Text('Sem dados!',)
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                          _imageFile != null ? Center(
                                                                            child: SizedBox(
                                                                              width: 300,
                                                                              height: 300,
                                                                              child: Image.file(_imageFile!),
                                                                            ),
                                                                          ): Container(),
                                                                          Container(
                                                                            padding: const EdgeInsets.all(5),
                                                                            child: Center(
                                                                              child: ElevatedButton(
                                                                                onPressed: () async {
                                                                                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
                                                                                  setStater(() {
                                                                                    if (pickedFile != null) {
                                                                                      _imageFile = File(pickedFile.path);
                                                                                    } else {
                                                                                      showToast("Imagem não selecionada!",context:context);
                                                                                    }
                                                                                  });
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: colorBtn
                                                                                ),
                                                                                child: Text(
                                                                                  'Selecione uma Imagem de perfil',
                                                                                  style: TextStyle(
                                                                                      color: textColor
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding: const EdgeInsets.all(10),
                                                                            child: ElevatedButton(onPressed: () async {
                                                                              if(NomeV == ""){
                                                                                showToast("O nome está vazio!",context:context);
                                                                              }else{
                                                                                if(CPFV == ""){
                                                                                  showToast("O CPF está vazio!",context:context);
                                                                                }else{
                                                                                  if(RGV == ""){
                                                                                    showToast("O RG está vazio!",context:context);
                                                                                  }else{
                                                                                    if(Unidade == ""){
                                                                                      showToast("A unidade está vazia!",context:context);
                                                                                    }else{
                                                                                      if(Bloco  == ""){
                                                                                        showToast("O bloco está vazio!!",context:context);
                                                                                      }else{
                                                                                        String ID = "";
                                                                                        Cadastrar(String DocID) async {
                                                                                          String DownloadURL = '';
                                                                                          if(_imageFile != null){
                                                                                            DownloadURL = await carregarImagem(context, _imageFile!, DocID, idCondominio).getDownloadURL();
                                                                                          }else{
                                                                                            DownloadURL = '';
                                                                                          }
                                                                                          FirebaseFirestore.instance.collection('Pessoas').doc(DocID).set({
                                                                                            "id": DocID,
                                                                                            "idCondominio": idCondominio,
                                                                                            "Nome": NomeV,
                                                                                            "CPF": CPFV,
                                                                                            "RG": RGV,
                                                                                            "imageURI": DownloadURL,
                                                                                            "Unidade":Unidade,
                                                                                            "Bloco": Bloco,
                                                                                            "anotacao": Observacoes,
                                                                                            "Telefone": Telefone,
                                                                                            "Celular": Celular,
                                                                                            "Qualificacao": Qualificacao,
                                                                                          }).whenComplete(() {
                                                                                            print('completo!');
                                                                                            Navigator.of(context).pop();
                                                                                            Navigator.of(context).pop();
                                                                                          });
                                                                                        }

                                                                                        showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return const AlertDialog(
                                                                                              title: Text('Aguarde!'),
                                                                                              actions: [
                                                                                                Center(
                                                                                                  child: CircularProgressIndicator(),
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        );

                                                                                        if(modeloPikado == "Control iD"){
                                                                                          if(ipAcionamento == '' || usuarioAc == '' || senhAc == ""){
                                                                                            Navigator.of(context).pop();
                                                                                            showToast("Selecione um acionamento! Caso não exista acionamentos, use a opção Outros!",context:context);
                                                                                          }else{
                                                                                            Map<String, dynamic> id = await cadastronoEquipamento(context, ipAcionamento, portaAc, usuarioAc, senhAc, modeloAcionamento, NomeV, 0);
                                                                                            setStater((){
                                                                                              ID = "${id["ids"][0]}$idCondominio";
                                                                                            });
                                                                                            Cadastrar(ID);
                                                                                          }
                                                                                        }

                                                                                        if(modeloPikado == "Hikvision"){
                                                                                          int id = gerarNumero();
                                                                                          setStater((){
                                                                                            ID = "$id$idCondominio";
                                                                                          });
                                                                                          await cadastronoEquipamento(context, ipAcionamento, portaAc, usuarioAc, senhAc, modeloAcionamento, NomeV, id);
                                                                                          Cadastrar(ID);
                                                                                        }

                                                                                        if(modeloPikado == "Outros"){
                                                                                          Uuid uuid = const Uuid();

                                                                                          setStater((){
                                                                                            ID = "${uuid.v4()}$idCondominio";
                                                                                          });
                                                                                          Cadastrar(ID);
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                }
                                                                              }
                                                                            },style: ElevatedButton.styleFrom(
                                                                                backgroundColor: colorBtn
                                                                            ),
                                                                                child: Text(
                                                                                  'Registrar novo cadastro',
                                                                                  style: TextStyle(
                                                                                      color: textColor
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },);
                                                      },
                                                    );
                                                  },
                                                  child: Image.asset(
                                                      "assets/fab.png",
                                                      scale: 45
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    ),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                        return SizedBox(
                                            width: wid / 4,
                                            height: heig / 3,
                                            child: Center(
                                              child: SingleChildScrollView(
                                                child: Stack(
                                                  children: [
                                                    idCondominio == "" ?
                                                    Center(
                                                        child: Text('Selecione um cliente!',
                                                          style: TextStyle(
                                                              color: textColorWidgets
                                                          ),
                                                        )
                                                    )
                                                        : Column(
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                            padding: const EdgeInsets.all(5),
                                                            child: Stack(
                                                              children: [
                                                                TextField(
                                                                  cursorColor: Colors.black,
                                                                  keyboardType: TextInputType.name,
                                                                  enableSuggestions: true,
                                                                  autocorrect: true,
                                                                  onChanged: (value){
                                                                    setStater(() {
                                                                      pesquisa7 = value;
                                                                    });

                                                                    if(value == ""){
                                                                      setStater(() {
                                                                        pesquisando7 = false;
                                                                      });
                                                                    }else{
                                                                      setStater(() {
                                                                        pesquisando7 = true;
                                                                      });
                                                                    }
                                                                  },
                                                                  decoration: const InputDecoration(
                                                                    filled: true,
                                                                    fillColor: Colors.white,
                                                                    border: OutlineInputBorder(),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width: 3,
                                                                          color: Colors.black
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  style: const TextStyle(
                                                                      color: Colors.black
                                                                  ),
                                                                ),
                                                                Container(
                                                                  alignment: Alignment.centerRight,
                                                                  child: TextButton(
                                                                    onPressed: () async {
                                                                      //Pesquisa nome
                                                                      QuerySnapshot snapshotNome = await FirebaseFirestore.instance
                                                                          .collection("Visitantes")
                                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                                          .where("Nome", isGreaterThanOrEqualTo: pesquisa7)
                                                                          .where("Nome", isLessThan: "${pesquisa7}z")
                                                                          .get();

                                                                      if(snapshotNome.docs.isNotEmpty){
                                                                        for (var doc in snapshotNome.docs) {
                                                                          //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                          //print("Dados: $data");

                                                                          setStater((){
                                                                            pesquisando7 = true;
                                                                          });
                                                                        }
                                                                      }else{
                                                                        showToast("Nada foi encontrado!", context: context);
                                                                        setStater((){
                                                                          pesquisando7 = true;
                                                                        });
                                                                      }

                                                                      //Pesquisa CPF
                                                                      QuerySnapshot snapshotCPF = await FirebaseFirestore.instance
                                                                          .collection("Visitantes")
                                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                                          .where("CPFVist", isGreaterThanOrEqualTo: pesquisa8)
                                                                          .where("CPFVist", isLessThan: "${pesquisa8}9")
                                                                          .get();

                                                                      if(snapshotCPF.docs.isNotEmpty){
                                                                        for (var doc in snapshotNome.docs) {
                                                                          //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                          //print("Dados: $data");

                                                                          setStater((){
                                                                            pesquisando8 = true;
                                                                          });
                                                                        }
                                                                      }else{
                                                                        showToast("Nada foi encontrado!", context: context);
                                                                        setStater((){
                                                                          pesquisando8 = true;
                                                                        });
                                                                      }

                                                                    },
                                                                    child: Image.asset(
                                                                        "assets/search.png",
                                                                        scale: 14
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        StreamBuilder(
                                                            stream: pesquisando7 == true ?
                                                            FirebaseFirestore.instance
                                                                .collection("Visitantes")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .where("Nome", isGreaterThanOrEqualTo: pesquisa7)
                                                                .where("Nome", isLessThan: "${pesquisa7}z")
                                                                .snapshots() :
                                                            pesquisando8 == true?
                                                            FirebaseFirestore.instance
                                                                .collection("Visitantes")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .where("CPFVist", isGreaterThanOrEqualTo: pesquisa8)
                                                                .where("CPFVist", isLessThan: "${pesquisa8}9")
                                                                .snapshots():
                                                            pesquisando9 == true ? FirebaseFirestore.instance
                                                                .collection("Visitantes")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .where("Unidade", isGreaterThanOrEqualTo: pesquisa9)
                                                                .where("Unidade", isLessThan: "${pesquisa9}9")
                                                                .snapshots():
                                                            pesquisando10 == true ? FirebaseFirestore.instance
                                                                .collection("Visitantes")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .where("Placa", isGreaterThanOrEqualTo: pesquisa10)
                                                                .where("Placa", isLessThan: "${pesquisa10}z")
                                                                .snapshots():
                                                            FirebaseFirestore.instance
                                                                .collection("Visitantes")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .snapshots(),
                                                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                                                              if (!snapshot.hasData) {
                                                                return const Center(
                                                                  child: CircularProgressIndicator(),
                                                                );
                                                              }

                                                              return Container(
                                                                width: wid,
                                                                height: heig / 4.5,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Colors.blue,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                child: ListView(
                                                                  children: snapshot.data!.docs.map((documents){
                                                                    return Container(
                                                                        padding: const EdgeInsets.all(6),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              "Nome: ${documents["Nome"]}\nCPF: ${documents["CPFVist"]}\nEmpresa: ${documents["Empresa"]}",
                                                                              style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 13
                                                                              ),
                                                                            ),
                                                                            TextButton(
                                                                                onPressed: (){
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: const Text('Deseja deletar esse visitante?'),
                                                                                        actions: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              ElevatedButton(
                                                                                                  onPressed: (){
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: const Text("Não")
                                                                                              ),
                                                                                              ElevatedButton(
                                                                                                  onPressed: (){
                                                                                                    FirebaseFirestore.instance
                                                                                                        .collection("Visitantes")
                                                                                                        .doc(documents["ID"])
                                                                                                        .delete().
                                                                                                        whenComplete((){
                                                                                                              Navigator.pop(context);
                                                                                                                  }
                                                                                                                );
                                                                                                  },
                                                                                                  child: const Text("Sim")
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: const Icon(
                                                                                    Icons.delete,
                                                                                    color: Colors.red,
                                                                                )
                                                                            )
                                                                          ],
                                                                        )
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              );
                                                            }
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: wid / 4,
                                                      height: heig / 3,
                                                      padding: const EdgeInsets.all(16),
                                                      alignment: Alignment.bottomRight,
                                                      child: adicionarVisitante == false ?
                                                      Container() :
                                                      TextButton(
                                                          onPressed: idCondominio == "" ? null : (){
                                                            var dropValue2 = ValueNotifier('Sem Previsão');

                                                            List Permanencia = [
                                                              'Sem Previsão',
                                                              '5 minutos',
                                                              '7 minutos',
                                                              '15 minutos',
                                                              '30 minutos',
                                                              '1 hora',
                                                              '2 horas',
                                                              '3 horas',
                                                              '4 horas',
                                                              '5 horas',
                                                              '6 horas',
                                                              '7 horas',
                                                              '8 horas',
                                                              '9 horas',
                                                              '10 horas',
                                                              '11 horas',
                                                              '12 horas',
                                                              '24 horas',
                                                            ];

                                                            //Não obrigatórios
                                                            String Unidade = "";
                                                            String Bloco = "";
                                                            String Rua = "";
                                                            String obs = "";
                                                            String Empresa = "";
                                                            String Veiculo = "";
                                                            String Cracha = "";
                                                            String Placa = "";
                                                            String Telefone = "";
                                                            String Celular = "";
                                                            String Qualificacao = "";
                                                            String Previsao = "Sem Previsão";

                                                            //Campos obrigatórios
                                                            String Nome = "";
                                                            String CPFVist = "";
                                                            File? _imageFile;


                                                            final picker = ImagePicker();

                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                  return SingleChildScrollView(
                                                                    child: Dialog(
                                                                      child: Stack(
                                                                        children: [
                                                                          Positioned.fill(
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              child: Image.asset(
                                                                                "assets/FundoMetalPreto.jpg",
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width: 600,
                                                                            padding: const EdgeInsets.all(20),
                                                                            child: Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    const Text(
                                                                                      'Cadastrar novo visitante',
                                                                                      style: TextStyle(
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 80,
                                                                                      height: 80,
                                                                                      child: TextButton(onPressed: (){
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                          child: const Center(
                                                                                            child: Icon(
                                                                                              Icons.close,
                                                                                              size: 35,
                                                                                            ),
                                                                                          )
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                Center(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Center(
                                                                                        child: Container(
                                                                                            padding: const EdgeInsets.all(16),
                                                                                            child: const Text('Qual será a unidade que será visitada?')
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Unidade = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Unidade',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Bloco = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Bloco',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Rua = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Rua',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Nome = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Nome',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                CPFVist = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'CPF',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Telefone = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Telefone',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Celular = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Celular',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Qualificacao = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Qualificação',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Cracha = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Crachá',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Empresa = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Empresa',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Veiculo = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Veiculo',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(16),
                                                                                          child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            enableSuggestions: false,
                                                                                            autocorrect: false,
                                                                                            onChanged: (value){
                                                                                              setStater(() {
                                                                                                Placa = value;
                                                                                              });
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: Colors.white,
                                                                                              labelStyle: TextStyle(
                                                                                                  color: textAlertDialogColor,
                                                                                                  backgroundColor: Colors.white
                                                                                              ),
                                                                                              border: const OutlineInputBorder(),
                                                                                              enabledBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                              ),
                                                                                              focusedBorder: const OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                    width: 3,
                                                                                                    color: Colors.black
                                                                                                ),
                                                                                              ),
                                                                                              labelText: 'Placa',
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                color: textAlertDialogColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
                                                                                          return DropdownButton(
                                                                                            hint: Text(
                                                                                              'Permanência',
                                                                                              style: TextStyle(
                                                                                                  color: textColorDrop
                                                                                              ),
                                                                                            ),
                                                                                            value: (value.isEmpty)? null : value,
                                                                                            onChanged: (escolha) async {
                                                                                              dropValue2.value = escolha.toString();
                                                                                              setStater(() {
                                                                                                Previsao = escolha.toString();
                                                                                              });
                                                                                            },
                                                                                            items: Permanencia.map((opcao) => DropdownMenuItem(
                                                                                              value: opcao,
                                                                                              child:
                                                                                              Text(
                                                                                                opcao,
                                                                                                style: TextStyle(
                                                                                                    color: textColorDrop
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            ).toList(),
                                                                                          );
                                                                                        }),
                                                                                      ),
                                                                                      _imageFile != null ? Center(
                                                                                        child: SizedBox(
                                                                                          width: 300,
                                                                                          height: 300,
                                                                                          child: Image.file(_imageFile!),
                                                                                        ),
                                                                                      ): const Center(
                                                                                        child: Text("Sem imagem selecionada!"),
                                                                                      ),
                                                                                      Center(
                                                                                        child: ElevatedButton(
                                                                                          onPressed: () async {
                                                                                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                                                                                            setStater(() {
                                                                                              if (pickedFile != null) {
                                                                                                _imageFile = File(pickedFile.path);
                                                                                              } else {
                                                                                                showToast("Imagem não selecionada!",context:context);
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: colorBtn
                                                                                          ),
                                                                                          child: Text(
                                                                                            'Selecione a imagem do documento da pessoa!',
                                                                                            style: TextStyle(
                                                                                                color: textColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: const EdgeInsets.all(16),
                                                                                        child: TextField(
                                                                                          keyboardType: TextInputType.multiline,
                                                                                          enableSuggestions: true,
                                                                                          autocorrect: true,
                                                                                          minLines: 5,
                                                                                          maxLines: null,
                                                                                          onChanged: (value){
                                                                                            setStater(() {
                                                                                              obs = value;
                                                                                            });
                                                                                          },
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.white,
                                                                                            labelStyle: TextStyle(
                                                                                                color: textAlertDialogColor,
                                                                                                backgroundColor: Colors.white
                                                                                            ),
                                                                                            border: const OutlineInputBorder(),
                                                                                            enabledBorder: const OutlineInputBorder(
                                                                                              borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                            ),
                                                                                            focusedBorder: const OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                  width: 3,
                                                                                                  color: Colors.black
                                                                                              ),
                                                                                            ),
                                                                                            labelText: 'Observações',
                                                                                          ),
                                                                                          style: TextStyle(
                                                                                              color: textAlertDialogColor
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Center(
                                                                                        child: ElevatedButton(
                                                                                          onPressed: () async {
                                                                                            if(Nome == ""){
                                                                                              showToast("O campo de nome está vazio!",context:context);
                                                                                            }else{
                                                                                              if(CPFVist == ""){
                                                                                                showToast("O campo de CPF está vazio!",context:context);
                                                                                              }else{
                                                                                                if(_imageFile == null){
                                                                                                  showToast("O documento não foi passado!",context:context);
                                                                                                }else{
                                                                                                  showDialog(
                                                                                                    context: context,
                                                                                                    builder: (BuildContext context) {
                                                                                                      return const AlertDialog(
                                                                                                        title: Text('Aguarde!'),
                                                                                                        actions: [
                                                                                                          Center(
                                                                                                            child: CircularProgressIndicator(),
                                                                                                          )
                                                                                                        ],
                                                                                                      );
                                                                                                    },
                                                                                                  );
                                                                                                  Uuid uuid = const Uuid();
                                                                                                  String UUID = uuid.v4();

                                                                                                  var ref = carregarImagem(context, _imageFile!, UUID, idCondominio);

                                                                                                  FirebaseFirestore.instance.collection('Visitantes').doc(UUID).set({
                                                                                                    "ID": UUID,
                                                                                                    "Unidade": Unidade,
                                                                                                    "Bloco": Bloco,
                                                                                                    "Rua": Rua,
                                                                                                    "obs": obs,
                                                                                                    "Empresa": Empresa,
                                                                                                    "Veiculo": Veiculo,
                                                                                                    "Cracha": Cracha,
                                                                                                    "Placa": Placa,
                                                                                                    "Telefone": Telefone,
                                                                                                    "Celular": Celular,
                                                                                                    "Qualificacao": Qualificacao,
                                                                                                    "Previsao": Previsao,
                                                                                                    "Nome": Nome,
                                                                                                    "CPFVist": CPFVist,
                                                                                                    "idCondominio": idCondominio,
                                                                                                    "imageURI": await ref,
                                                                                                  }).whenComplete((){
                                                                                                    Navigator.pop(context);
                                                                                                    Navigator.pop(context);
                                                                                                  });
                                                                                                }
                                                                                              }
                                                                                            }
                                                                                          },style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: colorBtn
                                                                                        ),
                                                                                          child: Text(
                                                                                            "Salvar",
                                                                                            style: TextStyle(
                                                                                                color: textColor
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },);
                                                              },
                                                            );
                                                          },
                                                          child: Image.asset(
                                                              "assets/fab.png",
                                                              scale: 45
                                                          )
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      }
                                    ),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                      return SizedBox(
                                          width: wid / 4,
                                          height: heig / 3.3,
                                          child: Center(
                                            child: Center(
                                              child: SizedBox(
                                                width: wid / 4,
                                                height: heig / 3.3,
                                                child: SingleChildScrollView(
                                                  child: Stack(
                                                    children: [
                                                      if (idCondominio == "")
                                                        Center(child:
                                                        Text('Selecione um cliente!',
                                                          style: TextStyle(
                                                              color: textColorWidgets
                                                          ),
                                                        )
                                                        )
                                                      else Column(
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              TextButton(
                                                                onPressed: (){
                                                                  if(showSearchBar == true){
                                                                    setStater((){
                                                                      showSearchBar = false;
                                                                    });
                                                                  }else{
                                                                    setStater((){
                                                                      showSearchBar = true;
                                                                    });
                                                                  }
                                                                },
                                                                child: Center(
                                                                  child: Center(
                                                                    child: Stack(
                                                                      children: [
                                                                        Container(
                                                                          height: 50,
                                                                          color: Colors.white,
                                                                        ),
                                                                        Container(
                                                                          alignment: Alignment.centerRight,
                                                                          child: TextButton(
                                                                              onPressed: null,
                                                                              child: Image.asset(
                                                                                  "assets/search.png",
                                                                                  scale: 14
                                                                              )
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              showSearchBar == true ? Stack(
                                                                children: [
                                                                  Column(
                                                                      children: [
                                                                        //Placa
                                                                        Center(
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(6),
                                                                            child: Stack(
                                                                              children: [
                                                                                TextField(
                                                                                  cursorColor: Colors.black,
                                                                                  keyboardType: TextInputType.name,
                                                                                  enableSuggestions: true,
                                                                                  autocorrect: true,
                                                                                  onChanged: (value){
                                                                                    pesquisa3 = value;

                                                                                    if(value == ""){
                                                                                      setStater(() {
                                                                                        pesquisando6 = false;
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    filled: true,
                                                                                    fillColor: Colors.white,
                                                                                    border: const OutlineInputBorder(),
                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                      borderSide: BorderSide(
                                                                                          width: 3,
                                                                                          color: Colors.black
                                                                                      ),
                                                                                    ),
                                                                                    labelStyle: TextStyle(
                                                                                        color: textAlertDialogColor,
                                                                                        backgroundColor: Colors.white
                                                                                    ),
                                                                                    labelText: 'Placa',
                                                                                  ),
                                                                                  style: const TextStyle(
                                                                                      color: Colors.black
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  alignment: Alignment.centerRight,
                                                                                  padding: const EdgeInsets.only(right: 35),
                                                                                  child: TextButton(
                                                                                      onPressed: () async {
                                                                                        //Pesquisa de nomes;
                                                                                        QuerySnapshot snapshotNome = await FirebaseFirestore.instance
                                                                                            .collection("Veiculos")
                                                                                            .where("idCondominio", isEqualTo: idCondominio)
                                                                                            .where("PlacaV", isGreaterThanOrEqualTo: pesquisa6)
                                                                                            .where("PlacaV", isLessThan: "${pesquisa6}z")
                                                                                            .get();

                                                                                        if(snapshotNome.docs.isNotEmpty){
                                                                                          for (var doc in snapshotNome.docs) {
                                                                                            //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                                            //print("Dados: $data");

                                                                                            setStater((){
                                                                                              pesquisando6 = true;
                                                                                            });
                                                                                          }
                                                                                        }else{
                                                                                          showToast("Nada foi encontrado!", context: context);
                                                                                          setStater((){
                                                                                            pesquisando6 = true;
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      child: Image.asset(
                                                                                          "assets/search.png",
                                                                                          scale: 14
                                                                                      )
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        //Bloco
                                                                        Center(
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(6),
                                                                            child: Stack(
                                                                              children: [
                                                                                TextField(
                                                                                  cursorColor: Colors.black,
                                                                                  keyboardType: TextInputType.name,
                                                                                  enableSuggestions: true,
                                                                                  autocorrect: true,
                                                                                  onChanged: (value){
                                                                                    pesquisa3 = value;

                                                                                    if(value == ""){
                                                                                      setStater(() {
                                                                                        pesquisando4 = false;
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    filled: true,
                                                                                    fillColor: Colors.white,
                                                                                    border: const OutlineInputBorder(),
                                                                                    labelStyle: TextStyle(
                                                                                        color: textAlertDialogColor,
                                                                                        backgroundColor: Colors.white
                                                                                    ),
                                                                                    labelText: 'Bloco',
                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                      borderSide: BorderSide(
                                                                                          width: 3,
                                                                                          color: Colors.black
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  style: const TextStyle(
                                                                                      color: Colors.black
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  alignment: Alignment.centerRight,
                                                                                  padding: const EdgeInsets.only(right: 35),
                                                                                  child: TextButton(
                                                                                      onPressed: () async {
                                                                                        //Pesquisa de nomes;
                                                                                        QuerySnapshot snapshotNome = await FirebaseFirestore.instance
                                                                                            .collection("Veiculos")
                                                                                            .where("idCondominio", isEqualTo: idCondominio)
                                                                                            .where("blocoV", isGreaterThanOrEqualTo: pesquisa6)
                                                                                            .where("blocoV", isLessThan: "${pesquisa6}z")
                                                                                            .get();

                                                                                        if(snapshotNome.docs.isNotEmpty){
                                                                                          for (var doc in snapshotNome.docs) {
                                                                                            //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                                            //print("Dados: $data");

                                                                                            setStater((){
                                                                                              pesquisando4 = true;
                                                                                            });
                                                                                          }
                                                                                        }else{
                                                                                          showToast("Nada foi encontrado!", context: context);
                                                                                          setStater((){
                                                                                            pesquisando4 = true;
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      child: Image.asset(
                                                                                          "assets/search.png",
                                                                                          scale: 14
                                                                                      )
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        //Unidade
                                                                        Center(
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(6),
                                                                            child: Stack(
                                                                              children: [
                                                                                TextField(
                                                                                  cursorColor: Colors.black,
                                                                                  keyboardType: TextInputType.name,
                                                                                  enableSuggestions: true,
                                                                                  autocorrect: true,
                                                                                  onChanged: (value){
                                                                                    pesquisa3 = value;

                                                                                    if(value == ""){
                                                                                      setStater(() {
                                                                                        pesquisando3 = false;
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    filled: true,
                                                                                    fillColor: Colors.white,
                                                                                    border: const OutlineInputBorder(),
                                                                                    labelStyle: TextStyle(
                                                                                        color: textAlertDialogColor,
                                                                                        backgroundColor: Colors.white
                                                                                    ),
                                                                                    labelText: 'Unidade',
                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                      borderSide: BorderSide(
                                                                                          width: 3,
                                                                                          color: Colors.black
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  style: const TextStyle(
                                                                                      color: Colors.black
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  alignment: Alignment.centerRight,
                                                                                  padding: const EdgeInsets.only(right: 35),
                                                                                  child: TextButton(
                                                                                      onPressed: () async {
                                                                                        //Pesquisa de nomes;
                                                                                        QuerySnapshot snapshotNome = await FirebaseFirestore.instance
                                                                                            .collection("Veiculos")
                                                                                            .where("idCondominio", isEqualTo: idCondominio)
                                                                                            .where("Unidade", isGreaterThanOrEqualTo: pesquisa6)
                                                                                            .where("Unidade", isLessThan: "${pesquisa6}z")
                                                                                            .get();

                                                                                        if(snapshotNome.docs.isNotEmpty){
                                                                                          for (var doc in snapshotNome.docs) {
                                                                                            //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                                            //print("Dados: $data");

                                                                                            setStater((){
                                                                                              pesquisando3 = true;
                                                                                            });
                                                                                          }
                                                                                        }else{
                                                                                          showToast("Nada foi encontrado!", context: context);
                                                                                          setStater((){
                                                                                            pesquisando3 = true;
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      child: Image.asset(
                                                                                          "assets/search.png",
                                                                                          scale: 14
                                                                                      )
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]
                                                                  ),
                                                                  Container(
                                                                    alignment: Alignment.topRight,
                                                                    child: TextButton(
                                                                      onPressed: (){
                                                                        showSearchBar = true;
                                                                        if(showSearchBar == true){
                                                                          setStater((){
                                                                            showSearchBar = false;
                                                                            pesquisando6 = false;
                                                                            pesquisando4 = false;
                                                                            pesquisando3 = false;
                                                                          });
                                                                        }
                                                                      },
                                                                      child: const Icon(
                                                                          Icons.close,
                                                                          color: Colors.black
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ): Container()
                                                            ],
                                                          ),
                                                          StreamBuilder(
                                                              stream: pesquisando3 == true ?
                                                              FirebaseFirestore.instance
                                                                  .collection("Veiculos")
                                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                                  .where("Unidade", isGreaterThanOrEqualTo: pesquisa3)
                                                                  .where("Unidade", isLessThan: "${pesquisa3}9")
                                                                  .snapshots() :
                                                              pesquisando4 == true ?
                                                              FirebaseFirestore.instance
                                                                  .collection("Veiculos")
                                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                                  .where("blocoV", isGreaterThanOrEqualTo: pesquisa4)
                                                                  .where("blocoV", isLessThan: "${pesquisa4}z")
                                                                  .snapshots() :
                                                              pesquisando5 == true ? FirebaseFirestore.instance
                                                                  .collection("Veiculos")
                                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                                  .where("IdentificacaoModeloV", isGreaterThanOrEqualTo: pesquisa5)
                                                                  .where("IdentificacaoModeloV", isLessThan: "${pesquisa5}z")
                                                                  .snapshots():
                                                              pesquisando6 == true ? FirebaseFirestore.instance
                                                                  .collection("Veiculos")
                                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                                  .where("PlacaV", isGreaterThanOrEqualTo: pesquisa6)
                                                                  .where("PlacaV", isLessThan: "${pesquisa6}z")
                                                                  .snapshots():
                                                              FirebaseFirestore.instance
                                                                  .collection("Veiculos")
                                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                                  .snapshots(),
                                                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                                                                if (!snapshot.hasData) {
                                                                  return const Center(
                                                                    child: CircularProgressIndicator(),
                                                                  );
                                                                }

                                                                return Container(
                                                                  width: wid,
                                                                  height: 100,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color: Colors.blue,
                                                                      width: 1.0,
                                                                    ),
                                                                  ),
                                                                  child: ListView(
                                                                    children: snapshot.data!.docs.map((documents){
                                                                      return Center(
                                                                        child: Container(
                                                                            padding: const EdgeInsets.all(6),
                                                                            child: Text(
                                                                              "Placa: ${documents["PlacaV"]}",
                                                                              style: TextStyle(
                                                                                  color: textColorWidgets
                                                                              ),
                                                                            )
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                );
                                                              }
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        alignment: Alignment.bottomRight,
                                                        child: adicionarVeiculo == false ?
                                                        Container():
                                                        Container(
                                                          padding: const EdgeInsets.all(16),
                                                          alignment: Alignment.bottomRight,
                                                          width: wid / 4,
                                                          height: heig / 3.3,
                                                          child: TextButton(
                                                              onPressed: idCondominio == "" ? null : (){

                                                                String Unidade = "";
                                                                String blocoV = "";
                                                                String IdentificacaoModeloV = "";
                                                                String MarcaV = "";
                                                                String corV = "";
                                                                String PlacaV = "";

                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
                                                                      return Center(
                                                                        child: SingleChildScrollView(
                                                                          child: Dialog(
                                                                            child: Stack(
                                                                              children: [
                                                                                Positioned.fill(
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    child: Image.asset(
                                                                                      "assets/FundoMetalPreto.jpg",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: 600,
                                                                                  padding: const EdgeInsets.all(20),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          const Text(
                                                                                            'Cadastrar novo veiculo',
                                                                                            style: TextStyle(
                                                                                              fontSize: 30,
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 100,
                                                                                            height: 100,
                                                                                            child: TextButton(onPressed: (){
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                                child: const Center(
                                                                                                  child: Icon(
                                                                                                    Icons.close,
                                                                                                    size: 40,
                                                                                                  ),
                                                                                                )
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      Column(
                                                                                        children: [
                                                                                          Center(
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.all(16),
                                                                                              child: TextField(
                                                                                                keyboardType: TextInputType.emailAddress,
                                                                                                enableSuggestions: false,
                                                                                                autocorrect: false,
                                                                                                onChanged: (value){
                                                                                                  setStater(() {
                                                                                                    Unidade = value;
                                                                                                  });
                                                                                                },
                                                                                                decoration: InputDecoration(
                                                                                                  filled: true,
                                                                                                  fillColor: Colors.white,
                                                                                                  labelStyle: TextStyle(
                                                                                                      color: textAlertDialogColor,
                                                                                                      backgroundColor: Colors.white
                                                                                                  ),
                                                                                                  border: const OutlineInputBorder(),
                                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                  ),
                                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(
                                                                                                        width: 3,
                                                                                                        color: Colors.black
                                                                                                    ),
                                                                                                  ),
                                                                                                  labelText: 'Unidade',
                                                                                                ),
                                                                                                style: TextStyle(
                                                                                                    color: textAlertDialogColor
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Center(
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.all(16),
                                                                                              child: TextField(
                                                                                                keyboardType: TextInputType.emailAddress,
                                                                                                enableSuggestions: false,
                                                                                                autocorrect: false,
                                                                                                onChanged: (value){
                                                                                                  setStater(() {
                                                                                                    blocoV = value;
                                                                                                  });
                                                                                                },
                                                                                                decoration: InputDecoration(
                                                                                                  filled: true,
                                                                                                  fillColor: Colors.white,
                                                                                                  labelStyle: TextStyle(
                                                                                                      color: textAlertDialogColor,
                                                                                                      backgroundColor: Colors.white
                                                                                                  ),
                                                                                                  border: const OutlineInputBorder(),
                                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                  ),
                                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(
                                                                                                        width: 3,
                                                                                                        color: Colors.black
                                                                                                    ),
                                                                                                  ),
                                                                                                  labelText: 'Bloco',
                                                                                                ),
                                                                                                style: TextStyle(
                                                                                                    color: textAlertDialogColor
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Center(
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.all(16),
                                                                                              child: TextField(
                                                                                                keyboardType: TextInputType.emailAddress,
                                                                                                enableSuggestions: false,
                                                                                                autocorrect: false,
                                                                                                onChanged: (value){
                                                                                                  setStater(() {
                                                                                                    MarcaV = value;
                                                                                                  });
                                                                                                },
                                                                                                decoration: InputDecoration(
                                                                                                  filled: true,
                                                                                                  fillColor: Colors.white,
                                                                                                  labelStyle: TextStyle(
                                                                                                      color: textAlertDialogColor,
                                                                                                      backgroundColor: Colors.white
                                                                                                  ),
                                                                                                  border: const OutlineInputBorder(),
                                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                  ),
                                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(
                                                                                                        width: 3,
                                                                                                        color: Colors.black
                                                                                                    ),
                                                                                                  ),
                                                                                                  labelText: 'Marca',
                                                                                                ),
                                                                                                style: TextStyle(
                                                                                                    color: textAlertDialogColor
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Center(
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.all(16),
                                                                                              child: TextField(
                                                                                                keyboardType: TextInputType.emailAddress,
                                                                                                enableSuggestions: false,
                                                                                                autocorrect: false,
                                                                                                onChanged: (value){
                                                                                                  setStater(() {
                                                                                                    IdentificacaoModeloV = value;
                                                                                                  });
                                                                                                },
                                                                                                decoration: InputDecoration(
                                                                                                  filled: true,
                                                                                                  fillColor: Colors.white,
                                                                                                  labelStyle: TextStyle(
                                                                                                      color: textAlertDialogColor,
                                                                                                      backgroundColor: Colors.white
                                                                                                  ),
                                                                                                  border: const OutlineInputBorder(),
                                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                  ),
                                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(
                                                                                                        width: 3,
                                                                                                        color: Colors.black
                                                                                                    ),
                                                                                                  ),
                                                                                                  labelText: 'Modelo',
                                                                                                ),
                                                                                                style: TextStyle(
                                                                                                    color: textAlertDialogColor
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Center(
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.all(16),
                                                                                              child: TextField(
                                                                                                keyboardType: TextInputType.emailAddress,
                                                                                                enableSuggestions: false,
                                                                                                autocorrect: false,
                                                                                                onChanged: (value){
                                                                                                  setStater(() {
                                                                                                    PlacaV = value;
                                                                                                  });
                                                                                                },
                                                                                                decoration: InputDecoration(
                                                                                                  filled: true,
                                                                                                  fillColor: Colors.white,
                                                                                                  labelStyle: TextStyle(
                                                                                                      color: textAlertDialogColor,
                                                                                                      backgroundColor: Colors.white
                                                                                                  ),
                                                                                                  border: const OutlineInputBorder(),
                                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                  ),
                                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(
                                                                                                        width: 3,
                                                                                                        color: Colors.black
                                                                                                    ),
                                                                                                  ),
                                                                                                  labelText: 'Placa',
                                                                                                ),
                                                                                                style: TextStyle(
                                                                                                    color: textAlertDialogColor
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Center(
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.all(16),
                                                                                              child: TextField(
                                                                                                keyboardType: TextInputType.emailAddress,
                                                                                                enableSuggestions: false,
                                                                                                autocorrect: false,
                                                                                                onChanged: (value){
                                                                                                  setStater(() {
                                                                                                    corV = value;
                                                                                                  });
                                                                                                },
                                                                                                decoration: InputDecoration(
                                                                                                  filled: true,
                                                                                                  fillColor: Colors.white,
                                                                                                  labelStyle: TextStyle(
                                                                                                      color: textAlertDialogColor,
                                                                                                      backgroundColor: Colors.white
                                                                                                  ),
                                                                                                  border: const OutlineInputBorder(),
                                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                                  ),
                                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                                    borderSide: BorderSide(
                                                                                                        width: 3,
                                                                                                        color: Colors.black
                                                                                                    ),
                                                                                                  ),
                                                                                                  labelText: 'Cor',
                                                                                                ),
                                                                                                style: TextStyle(
                                                                                                    color: textAlertDialogColor
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Center(
                                                                                            child: ElevatedButton(
                                                                                              onPressed: (){
                                                                                                if(Unidade == ""){
                                                                                                  showToast("A unidade está vazia!",context:context);
                                                                                                }else{
                                                                                                  if(blocoV == ""){
                                                                                                    showToast("O Bloco está vazio!",context:context);
                                                                                                  }else{
                                                                                                    if(MarcaV == ""){
                                                                                                      showToast("A Marca está vazia!",context:context);
                                                                                                    }else{
                                                                                                      if(IdentificacaoModeloV == ""){
                                                                                                        showToast("A Identificação está vazia!",context:context);
                                                                                                      }else{
                                                                                                        if(PlacaV == ""){
                                                                                                          showToast("A Placa está vazia!",context:context);
                                                                                                        }else{
                                                                                                          if(corV == ""){
                                                                                                            showToast("A Cor não foi definida!",context:context);
                                                                                                          }else{
                                                                                                            Uuid uuid = const Uuid();
                                                                                                            String UUID = uuid.v4();
                                                                                                            FirebaseFirestore.instance.collection('Veiculos').doc(UUID).set({
                                                                                                              "Unidade": Unidade,
                                                                                                              "blocoV": blocoV,
                                                                                                              "IdentificacaoModeloV": IdentificacaoModeloV,
                                                                                                              "MarcaV": MarcaV,
                                                                                                              "corV": corV,
                                                                                                              "PlacaV": PlacaV,
                                                                                                              "idCondominio": idCondominio
                                                                                                            }).whenComplete((){
                                                                                                              Navigator.pop(context);
                                                                                                            });
                                                                                                          }
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              },
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                  backgroundColor: colorBtn
                                                                                              ),
                                                                                              child: const Text(
                                                                                                "Salvar",
                                                                                                style: TextStyle(
                                                                                                    color: Colors.white
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Image.asset(
                                                                  "assets/fab.png",
                                                                  scale: 45
                                                              )
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
