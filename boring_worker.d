import std.concurrency, std.stdio, core.thread, core.time;

void handle_string(string s) {
  writeln( "catch!; ", s );
}

void receiver() {
  for ( bool running = true; running; ) {
    auto worked = receiveTimeout(
      dur!"msecs"(500),
      &handle_string,
      (int x) { writeln( "catch!: ", x ); },
      (int i, string s) { writeln( "catch!: ", i, "-", s ); },
      (OwnerTerminated o) { writeln("Bye!"); running = false; }
    );
    if (!worked) {
      writeln("boring...");
    }
  }
}

void main() {
  auto tid = spawn(&receiver);
  send(tid, "Hello!");
  Thread.sleep(dur!"seconds"(3));
  send(tid, 3);
  Thread.sleep(dur!"seconds"(3));
  send(tid, 1, "one");
}
