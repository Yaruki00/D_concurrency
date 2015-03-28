import std.concurrency, std.stdio;

void worker( Tid tid ) {
  for (;;) {
    auto num = receiveOnly!(int)();
    writeln( "Worker", thisTid, ": ", num );
    tid.send( num + 1 );
  }
}

void main() {
  auto low = 0, high = 100;
  auto tid1 = spawn( &worker, thisTid );
  auto tid0 = spawn( &worker, tid1 );
  auto num = low;
  while ( num < high ) {
    writeln( "Main: ", num );
    tid0.send( num + 1 );
    num = receiveOnly!(int)();
  }
}
