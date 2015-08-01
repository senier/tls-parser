all:: parser

parser: parser.adb tls.ad? tls-debug.ad? tls_parameters.ads
	gnatmake $@

tls_parameters.ads: tls-parameters.xml

tls-parameters.xml:
	#FIXME: Pin server certificate
	curl --silent --ssl-reqd -o $@ https://www.iana.org/assignments/tls-parameters/tls-parameters.xml

clean:
	@gnatclean parser
	@rm -f tls-parameters.xml

.PHONY: clean all
