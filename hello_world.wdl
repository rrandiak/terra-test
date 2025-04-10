version 1.0

workflow hello_world {

	call say_hello
}

task say_hello {

	input {
        String greeting
        String name
    }

	command {
		echo "Hello, world!"
	}

	output {
		String message = read_string(stdout())
	}

	requirements {
		container: "alpine:latest"
    }
}

