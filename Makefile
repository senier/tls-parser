DUMMY := $(shell grep --exclude-dir .git --color --recursive --line-number 'FIXME' . | grep -v DUMMY 1>&2)

GNATMAKE_ARGS += -p
GNATMAKE_ARGS += -s
GNATMAKE_ARGS += --create-map-file

# For coverage analysis
GNATMAKE_ARGS += -fpreserve-control-flow

# Debugging information
GNATMAKE_ARGS += -g

# Treat all warnings as errors
GNATMAKE_ARGS += -we

# Assertions enabled
GNATMAKE_ARGS += -gnata

# Aliasing checks on subprogram parameters
GNATMAKE_ARGS += -gnateA

# Extra information in exception messages
GNATMAKE_ARGS += -gnateE

# Full source path in brief error messages
GNATMAKE_ARGS += -gnatef

# Write target dependent information file
GNATMAKE_ARGS += -gnatet=tdb

# Validity checks on subprogram parameters
GNATMAKE_ARGS += -gnateV

# Full errors. Verbose details, all undefined references
GNATMAKE_ARGS += -gnatf

# Enable overflow checking mode to CHECKED
GNATMAKE_ARGS += -gnato

# List rep info to file.rep instead of standard output
GNATMAKE_ARGS += -gnatR2s

# Turn on all validity checking options
GNATMAKE_ARGS += -gnatVa

# turn on all info/warnings marked below with +
GNATMAKE_ARGS += -gnatwa

# Enable default style checks (same as -gnaty3abcefhiklmnprst)
GNATMAKE_ARGS += -gnaty

# Check for indentation of 4 chars
GNATMAKE_ARGS += -gnaty4

# Check line length of 130 chars
GNATMAKE_ARGS += -gnatyM130

all:: parser

parser: *.ad?  tls-parameters.ads
	gnatmake $(GNATMAKE_ARGS) $@

tls-parameters.ads: tls-parameters.xml

tls-parameters.xml:
	#FIXME: Pin server certificate
	curl --silent --ssl-reqd --time-cond $@ -o $@ https://www.iana.org/assignments/tls-parameters/tls-parameters.xml

tls-parameters.ads: scripts/parameters.xsl tls-parameters.xml
	xsltproc -o $@ $^


clean:
	@gnatclean parser
	@rm -f tls-parameters.ads tdb parser.map

.PHONY: clean all
