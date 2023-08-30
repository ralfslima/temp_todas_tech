// Importação do material
import 'package:flutter/material.dart';

// Importação do http
import 'package:http/http.dart' as http;

// Importação do convert
import 'dart:convert';

class Produto {
  int? codigo;
  String? nome;
  String? imagem;
}

// Inicialização
void main() {
  runApp(const MyApp());
}

// Stateless
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
        ),
      ),
      home: const Pagina(),
    );
  }
}

// StatefulWidget
class Pagina extends StatefulWidget {
  const Pagina({super.key});

  @override
  State<StatefulWidget> createState() {
    return ConteudoPagina();
  }
}

class Pessoa {
  int? id;
  String? nome;
  String? cidade;
}

// CADASTRAR
Future<Pessoa> cadastrarPessoa(String nome, String cidade) async {
  var response = await http.post(
    Uri.parse('http://localhost:3000/pessoas'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'nome': nome, 'cidade': cidade}),
  );

  var pessoa = jsonDecode(response.body);
  Pessoa p = Pessoa();
  p.id = pessoa["id"];
  p.nome = pessoa["nome"];
  p.cidade = pessoa["cidade"];
  return p;
}

// SELECIONAR
Future<List<Pessoa>> selecionarPessoas() async {
  // URL da API
  String url = "http://localhost:3000/pessoas";

  // Realizar a requisição
  var requisicao = await http.get(Uri.parse(url));

  // Converter a requisição em um objeto JSON
  var dados = json.decode(requisicao.body);

  // Criar uma lista de postagens
  List<Pessoa> pessoas = [];

  // Laço de repetição
  for (var objeto in dados) {
    // Criar objeto do tipo Postagem
    Pessoa p = Pessoa();

    // Atribuindo características ao objeto
    p.id = objeto["id"];
    p.nome = objeto["nome"];
    p.cidade = objeto["cidade"];

    // Adicionar o objeto no vetor de postagens
    pessoas.add(p);
  }

  return pessoas;
}

// State
class ConteudoPagina extends State {
  String? nome;
  String? cidade;
  List<Pessoa> pessoas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selecionarPessoas().then((value) => pessoas = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("9ª aula de Flutter"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 400,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      nome = value;
                    });
                  },
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      cidade = value;
                    });
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Future<Pessoa> retorno =
                            cadastrarPessoa(nome!, cidade!);

                        retorno.then((value) => pessoas.add(value));
                      });
                    },
                    child: const Text("Cadastrar"))
              ],
            ),
          ),
          FutureBuilder(
            future: selecionarPessoas(),
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // Card
                  return Card(
                    // Padding
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      // Coluna
                      child: Column(
                        // Alinhar os conteúdos a esquerda
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Componentes filhos
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                                "Código da Postagem: ${snapshot.data![index].id}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child:
                                Text("Título: ${snapshot.data![index].nome}"),
                          ),
                          Text("Texto: ${snapshot.data![index].cidade}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
