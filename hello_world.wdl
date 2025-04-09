version 1.0

workflow hello_world {
  call say_hello
}

task say_hello {
  command {
    echo "Hello, world!"
  }
  output {
    String message = read_string(stdout())
  }
}

