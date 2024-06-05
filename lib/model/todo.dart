class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Treinar', isDone: true),
      ToDo(id: '02', todoText: 'Ir ao mercado', isDone: true),
      ToDo(id: '03', todoText: 'Checar E-Mails'),
      ToDo(id: '04', todoText: 'Estudar Flutter'),
      ToDo(id: '05', todoText: 'Jogar Futebol'),
      ToDo(id: '06', todoText: 'Fazer uma lasanha'),
    ];
  }
}
