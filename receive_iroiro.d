import std.concurrency, std.stdio, core.thread, core.time;

void handle_string(string s) {
  writeln( "catch!; ", s );
}

void receiver() {
  for ( bool running = true; running; ) {
    receive(
      &handle_string,
      (int x) { writeln( "catch!: ", x ); },
      (int i, string s) { writeln( "catch!: ", i, "-", s ); },
      (OwnerTerminated o) { writeln("Bye!"); running = false; }
    );
    Thread.sleep(dur!"seconds"(3));
  }
}

void main() {
  auto tid = spawn(&receiver);
  send(tid, "Hello!");
  send(tid, 3);
  send(tid, 1, "one");
}
