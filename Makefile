ifeq ($(OS),Windows_NT)
	SAXON=transform.cmd
else
	SAXON=saxon9-transform
endif

schematron: source/profile.xml
	${SAXON} -xsl:source/tools/extract-schematron.xsl -o:source/profile.sch source/profile.xml
