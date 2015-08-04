DUMMY := $(shell grep --exclude-dir .git --color --recursive --line-number 'FIXME' . | grep -v DUMMY 1>&2)

all:: parser

parser: *.ad?  tls-parameters.ads
	gnatmake $@

tls-parameters.ads: tls-parameters.xml

tls-parameters.xml:
	#FIXME: Pin server certificate
	curl --silent --ssl-reqd --time-cond $@ -o $@ https://www.iana.org/assignments/tls-parameters/tls-parameters.xml

tls-parameters.ads: scripts/parameters.xsl tls-parameters.xml
	xsltproc -o $@ $^


clean:
	@gnatclean parser
	@rm -f tls-parameters.ads

.PHONY: clean all
