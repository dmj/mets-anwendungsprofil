<xsl:transform version="2.0"
               xmlns:profile="http://www.loc.gov/METS_Profile/v2"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes"/>

  <xsl:template match="profile:METS_Profile">
    <xsl:variable name="root" select="."/>
    <sch:schema queryBinding="xslt2">
      <sch:title><xsl:value-of select="profile:title"/></sch:title>
      <xsl:for-each select="in-scope-prefixes(.)[not( . = ('xml', 'sch', ''))]">
        <sch:ns prefix="{.}" uri="{namespace-uri-for-prefix(., $root)}"/>
      </xsl:for-each>
      <xsl:apply-templates/>
    </sch:schema>
  </xsl:template>

  <xsl:template match="profile:test[@TESTLANGUAGE = 'Schematron']">
    <sch:pattern id="{generate-id()}">
      <xsl:apply-templates select="profile:testWrap/profile:testXML/sch:*" mode="copy"/>
    </sch:pattern>
  </xsl:template>

  <xsl:template match="@* | node()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sch:assert | sch:report" mode="copy">
    <xsl:copy>
      <xsl:attribute name="role" select="if (ancestor::profile:requirement/@REQLEVEL eq 'MUST') then 'error' else 'warn'"/>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
