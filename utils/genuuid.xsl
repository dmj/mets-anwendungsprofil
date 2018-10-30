<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xmlns:mets="http://www.loc.gov/METS/"
               xmlns:uuid="tag:maus@hab.de,2018:uuid"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- ADMID, DMDID, STRUCTID, FILEID, TRANSFORMBEHAVIOR -->
  <xsl:template match="node() | @*">
    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
  </xsl:template>

  <xsl:template match="mets:*/@ADMID | mets:*/@DMDID | mets:*/@STRUCTID | mets:*/@FILEID | mets:*/@TRANSFORMBEHAVIOR | mets:*/@xlink:to | mets:*/@xlink:from">
    <xsl:attribute name="{name()}">
      <xsl:value-of select="uuid:add-prefix(//mets:*[@ID = tokenize(current(), ' ')]/@uuid:uuid)"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="mets:*/@ID">
    <xsl:attribute name="{name()}" select="uuid:add-prefix(../@uuid:uuid)"/>
  </xsl:template>

  <xsl:template match="@uuid:uuid"/>

  <xsl:function name="uuid:add-prefix" as="xs:string+">
    <xsl:param name="uuid" as="xs:string+"/>
    <xsl:for-each select="$uuid">
      <xsl:value-of select="concat('id.', .)"/>
    </xsl:for-each>
  </xsl:function>

</xsl:transform>
