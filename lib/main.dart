import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

// ============================================================
// APLICATIVO
// ============================================================

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A896),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF5F7F7),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF172121),
          elevation: 0,
          centerTitle: false,
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      home: const TelaLista(),
    );
  }
}

// ============================================================
// MODELO ITEM
// ============================================================

class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

// ============================================================
// TELA PRINCIPAL
// ============================================================

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  // Lista que armazena os produtos
  final List<Item> _itens = [
    Item(
      nome: 'Arroz',
      quantidade: 2,
    ),
    Item(
      nome: 'Leite',
      quantidade: 3,
    ),
    Item(
      nome: 'Pão',
      quantidade: 1,
    ),
    Item(
      nome: 'Ovos',
      quantidade: 12,
      comprado: true,
    ),
  ];

  // ==========================================================
  // CONTADOR DE ITENS COMPRADOS
  // ==========================================================

  int get _itensComprados {
    return _itens.where((item) => item.comprado).length;
  }

  // ==========================================================
  // ABRIR TELA DE ADICIONAR
  // ==========================================================

  Future<void> abrirTelaAdicionar() async {
    final Item? novoItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAdicionarItem(),
      ),
    );

    if (novoItem != null) {
      setState(() {
        _itens.add(novoItem);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${novoItem.nome} adicionado à lista',
          ),
          backgroundColor: const Color(0xFF00A896),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  // ==========================================================
  // REMOVER ITEM
  // ==========================================================

  void removerItem(int indice) {
    final Item itemRemovido = _itens[indice];

    setState(() {
      _itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${itemRemovido.nome} removido da lista',
        ),
        backgroundColor: const Color(0xFF172121),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ==========================================================
  // ALTERAR STATUS DO ITEM
  // ==========================================================

  void alterarCompra(int indice, bool valor) {
    setState(() {
      _itens[indice].comprado = valor;
    });
  }

  // ==========================================================
  // CARD DO ITEM
  // ==========================================================

  Widget _buildItem(int indice) {
    final Item item = _itens[indice];

    return Dismissible(
      key: ObjectKey(item),

      direction: DismissDirection.endToStart,

      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        padding: const EdgeInsets.only(right: 24),

        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),

        alignment: Alignment.centerRight,

        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),

      onDismissed: (_) {
        removerItem(indice);
      },

      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),

          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),

            // Checkbox
            leading: Checkbox(
              value: item.comprado,

              activeColor: const Color(0xFF00A896),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),

              onChanged: (valor) {
                alterarCompra(
                  indice,
                  valor ?? false,
                );
              },
            ),

            // Nome
            title: Text(
              item.nome,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,

                color: item.comprado
                    ? Colors.grey.shade500
                    : const Color(0xFF172121),

                decoration: item.comprado
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),

            // Quantidade
            subtitle: Row(
              children: [
                Icon(
                  Icons.shopping_basket_outlined,
                  size: 15,
                  color: item.comprado
                      ? Colors.grey
                      : const Color(0xFF00A896),
                ),

                const SizedBox(width: 5),

                Text(
                  'Quantidade: ${item.quantidade}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            // Ícone de lixeira
            trailing: IconButton(
              onPressed: () {
                removerItem(indice);
              },

              icon: const Icon(
                Icons.delete_outline,
              ),

              color: Colors.red.shade400,

              tooltip: 'Remover item',
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // TELA
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 82,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minha Lista',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 3),

            Text(
              'Lista de compras',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        // Contador
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),

          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              12,
            ),

            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 9,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFFE2F5F2),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: Color(0xFF008F7A),
                ),

                const SizedBox(width: 8),

                Text(
                  '$_itensComprados de ${_itens.length} comprados',

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF008F7A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ========================================================
      // LISTA
      // ========================================================

      body: _itens.isEmpty
          ? _buildListaVazia()
          : ListView.builder(
              padding: const EdgeInsets.only(
                top: 14,
                bottom: 100,
              ),

              itemCount: _itens.length,

              itemBuilder: (context, indice) {
                return _buildItem(indice);
              },
            ),

      // ========================================================
      // BOTÃO ADICIONAR
      // ========================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirTelaAdicionar,

        backgroundColor: const Color(0xFF00A896),
        foregroundColor: Colors.white,

        elevation: 4,

        icon: const Icon(Icons.add),

        label: const Text(
          'Adicionar item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // LISTA VAZIA
  // ==========================================================

  Widget _buildListaVazia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                color: const Color(0xFFE2F5F2),
                borderRadius: BorderRadius.circular(28),
              ),

              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 45,
                color: Color(0xFF00A896),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Sua lista está vazia',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172121),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Adicione produtos para começar\n'
              'a organizar suas compras.',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TELA DE ADICIONAR ITEM
// ============================================================

class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() =>
      _TelaAdicionarItemState();
}

class _TelaAdicionarItemState
    extends State<TelaAdicionarItem> {
  // Controllers
  final TextEditingController _nomeController =
      TextEditingController();

  final TextEditingController _quantidadeController =
      TextEditingController();

  // ==========================================================
  // SALVAR ITEM
  // ==========================================================

  void salvar() {
    final String nome =
        _nomeController.text.trim();

    final String quantidadeTexto =
        _quantidadeController.text.trim();

    // Verifica nome
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite o nome do item.',
          ),
        ),
      );

      return;
    }

    // Converte quantidade
    final int quantidade =
        int.tryParse(quantidadeTexto) ?? 1;

    // Cria item
    final Item novoItem = Item(
      nome: nome,
      quantidade: quantidade <= 0 ? 1 : quantidade,
    );

    // Volta para a tela anterior
    Navigator.pop(
      context,
      novoItem,
    );
  }

  // ==========================================================
  // INTERFACE
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),

      appBar: AppBar(
        title: const Text(
          'Novo Item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // Cabeçalho
            const Text(
              'Adicionar produto',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172121),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Informe o produto e a quantidade que deseja comprar.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // NOME
            // ==================================================

            const Text(
              'Nome do produto',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _nomeController,

              textCapitalization:
                  TextCapitalization.sentences,

              decoration: InputDecoration(
                hintText: 'Ex.: Arroz',

                prefixIcon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF00A896),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),

                  borderSide: const BorderSide(
                    color: Color(0xFF00A896),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // QUANTIDADE
            // ==================================================

            const Text(
              'Quantidade',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _quantidadeController,

              keyboardType:
                  TextInputType.number,

              decoration: InputDecoration(
                hintText: 'Ex.: 2',

                prefixIcon: const Icon(
                  Icons.numbers,
                  color: Color(0xFF00A896),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),

                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),

                  borderSide: const BorderSide(
                    color: Color(0xFF00A896),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ==================================================
            // BOTÃO SALVAR
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: salvar,

                icon: const Icon(
                  Icons.check,
                ),

                label: const Text(
                  'Salvar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF00A896),

                  foregroundColor: Colors.white,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();

    super.dispose();
  }
} 