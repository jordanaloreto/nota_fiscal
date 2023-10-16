import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nota_fiscal/database/objectbox_database.dart';
import 'package:nota_fiscal/modules/cliente/models/cliente_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_extend/share_extend.dart';

class ClienteListPage extends StatefulWidget {
  const ClienteListPage({super.key});

  @override
  State<ClienteListPage> createState() => _ClienteListPageState();
}

class _ClienteListPageState extends State<ClienteListPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _cnpjCpfController = TextEditingController();
  final _valorController = TextEditingController();

  Future<Box> getBox() async {
    final store = await ObjectBoxDatabase.getStore();
    return store.box<Cliente>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Cliente>>(
          future: getAll(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final clientes = snapshot.data as List<Cliente>;
                return clientes.isEmpty
                    ? const Center(
                        child: Text('Nenhum Cliente encontrado...'),
                      )
                    : ListView.builder(
                        itemCount: clientes.length,
                        itemBuilder: (ctx, index) => Card(
                          child: InkWell(
                            onDoubleTap: () => _editar(clientes[index]),
                            child: ListTile(
                              onLongPress: () => _delete(clientes[index]),
                              onTap: () => _visualizarCliente(clientes[index]),

                              title: Text(
                                clientes[index].nomeCliente,
                              ),
                              subtitle: Text(
                                '${clientes[index].cnpjCpf ?? ''}\n${clientes[index].valor.toStringAsFixed(2)}',
                                textAlign: TextAlign.justify,
                              ),

                              // trailing: clientes[index].
                              //     ? const Icon(
                              //         Icons.check,
                              //         color: Colors.green,
                              //       )
                              //     : const Icon(
                              //         Icons.radio_button_unchecked,
                              //         color: Colors.red,
                              //       ),
                            ),
                          ),
                        ),
                      );
              } else {
                const Center(
                  child: Text('Erro ao buscar clientes...'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _create() {
    // Limpar campos para garantir que não estará preenchido ao clicar para criar
    _titleController.clear();
    _cnpjCpfController.clear();
    _valorController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nova Cliente',
            ),
          ],
        ),
        content: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        label: Text('Título'),
                        hintText: 'Digite o título da Cliente...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      }),
                  TextFormField(
                    controller: _cnpjCpfController,
                    decoration: const InputDecoration(
                      label: Text('CNPJ/CPF'),
                      hintText: 'Digite os dados do cliente...',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfOuCnpjFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _valorController,
                    decoration: const InputDecoration(
                      label: Text('Valor do Serviço'),
                      hintText: 'Digite o valor...',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('SALVAR'),
          ),
        ],
      ),
    );
  }

  _editar(Cliente cliente) {
    // Limpar campos para garantir que não estará preenchido ao clicar para criar
    _titleController.text = cliente.nomeCliente;
    _cnpjCpfController.text = cliente.cnpjCpf;
    _valorController.text = cliente.valor.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Editar Cliente',
            ),
          ],
        ),
        content: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        label: Text('Nome'),
                        hintText: 'Digite o Nome da Cliente...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      }),
                  TextFormField(
                    controller: _cnpjCpfController,
                    decoration: const InputDecoration(
                      label: Text('CNPJ/CPF'),
                      hintText: 'Digite os dados do cliente...',
                    ),
                  ),
                  TextFormField(
                    controller: _valorController,
                    decoration: const InputDecoration(
                      label: Text('Valor do Serviço'),
                      hintText: 'Digite o valor...',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () => _edit(cliente),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('SALVAR'),
          ),
        ],
      ),
    );
  }

  Future<List<Cliente>> getAll() async {
    final box = await getBox();
    return box.getAll() as List<Cliente>;
  }

  void _visualizarCliente(Cliente cliente) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Visualizar Cliente',
            ),
          ],
        ),
        content: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Text('Nome: ${cliente.nomeCliente}'),
                    Text('Dados: ${cliente.cnpjCpf}'),
                    Text('Valor: ${cliente.valor}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('FECHAR'),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white70),
                foregroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () async {
              String? path = await gerarPdf(cliente);
              await _shareStorageFile(path);
            },
            child: Text("share file"),
          ),
        ],
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final cliente = Cliente(
          nomeCliente: _titleController.text,
          cnpjCpf: _cnpjCpfController.text,
          valor: double.parse(_valorController.text));
      final box = await getBox();

      setState(() {
        box.put(cliente);
        // clientes.add(Cliente);
      });

      Navigator.of(context).pop();
    }
  }

  _edit(Cliente cliente) async {
    if (_formKey.currentState?.validate() ?? false) {
      final box = await getBox();
      setState(() {
        box.put(cliente.copyWith(
          nomeCliente: _titleController.text,
          cnpjCpf: _cnpjCpfController.text,
          valor: double.parse(_valorController.text),
        ));
      });

      Navigator.of(context).pop();

      //   return cliente.copyWith(
      //     nomeCliente: _titleController.text,
      //     cnpjCpf: _cnpjCpfController.text,
      //     valor: double.parse(_valorController.text),
      //   );
      // }
      // return cliente;
    }
  }

  void _delete(Cliente cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Confirma a exclusão da Cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('NÃO'),
          ),
          ElevatedButton(
            onPressed: () async {
              final box = await getBox();

              setState(() {
                box.remove(cliente.id!);
              });

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('SIM'),
          ),
        ],
      ),
    );
  }

  Future<String?> gerarPdf(Cliente cliente) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [ 
                    pw.Text('Nome: ${cliente.nomeCliente}'),
                    pw.Text('Dados: ${cliente.cnpjCpf}'),
                    pw.Text('Valor: ${cliente.valor}'),
                  ],)
                   

          ),
        ),
      );
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/example.pdf');
      await file.writeAsBytes(await pdf.save());
      return file.path;
    } on Exception catch (e) {
      return null;
    }
  }

  _shareStorageFile(String? path) async {
    if (path == null) return;
    Directory? dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    File testFile = File(path);
    if (!await testFile.exists()) {
      await testFile.create(recursive: true);
      testFile.writeAsStringSync("test for share documents file");
    }
    ShareExtend.share(testFile.path, "file");
  }
}
