ifeq ($(OS),Windows_NT)
	SAXON=transform.cmd
	XSPEC=xspec.cmd
else
	SAXON=saxon9-transform
	XSPEC=xspec
endif

.PHONY: test
test: schematron
	${XSPEC} -s tests/restrictions.xspec

schematron: source/profile.xml
	${SAXON} -xsl:utils/schematron.xsl -o:source/profile.sch source/profile.xml
