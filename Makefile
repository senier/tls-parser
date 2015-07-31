all:: parser
	#socat EXEC:./parser TCP:192.168.100.1:443

clean:
	gnatclean parser

parser: parser.adb tls.ads tls.adb
	gnatmake $@
