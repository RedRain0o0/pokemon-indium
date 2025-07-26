class Pokemon {
  int id;
  String name;
  boolean shiny;
  Pokemon(int id, String name, boolean shiny) {
    id = id;
    name = name;
    shiny = shiny;
  }
  void test() {
    println(id,name,shiny);
  }
}
