<xsl:transform version="1.0"
               exclude-result-prefixes="mets"
               xmlns:html="http://www.w3.org/1999/xhtml"
               xmlns:profile="http://www.loc.gov/METS_Profile/v2"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="profile:METS_Profile">
    <html>
      <head>
        <title><xsl:value-of select="profile:title"/></title>
        <style type="text/css">
          body { max-width: 60em; margin: 0 auto; font-size: 14px; font-family: "Open Sans", sans; }
          dt { font-weight: bold; }
          dt:after { content: ": "; }
          dd, dt { display: inline-block;  }
          dd { margin-left: 1em; }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="profile:title"/></h1>
        <dl>
          <dt>Status</dt>
          <dd><xsl:value-of select="@STATUS"/>, <xsl:value-of select="@REGISTRATION"/></dd>
        </dl>
        <p>
          <xsl:value-of select="profile:abstract"/>
        </p>
        <xsl:apply-templates select="profile:contact"/>
        <h2>Strukturelle Anforderungen</h2>
        <xsl:apply-templates select="profile:structural_requirements"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="profile:requirement">
    <h3>Anforderung <xsl:number level="any"/></h3>
    <xsl:apply-templates select="profile:description/html:*"/>
    <xsl:apply-templates select="profile:tests"/>
  </xsl:template>

  <xsl:template match="html:*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="html:*/text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="profile:contact">
    <address>
      <xsl:for-each select="profile:*">
        <xsl:if test="position() > 1">
          <br/>
        </xsl:if>
        <xsl:value-of select="."/>
      </xsl:for-each>
    </address>
  </xsl:template>

  <xsl:template match="text()"/>

  <xsl:template match="profile:test[@TESTLANGUAGE = 'Schematron']">
    <code>
      <xsl:apply-templates select="profile:testWrap/profile:testXML/*" mode="copy-verbatim"/>
    </code>
  </xsl:template>

  <xsl:template match="*" mode="copy-verbatim">
    <xsl:call-template name="indent"/>
    <xsl:value-of select="concat('&lt;', name())"/>
    <xsl:for-each select="@*">
      <xsl:value-of select="concat(' ', name(), '=&quot;', ., '&quot;')"/>
    </xsl:for-each>
    <xsl:text>></xsl:text>
    <br/>
    <xsl:apply-templates mode="copy-verbatim"/>
    <br/>
    <xsl:call-template name="indent"/>
    <xsl:value-of select="concat('&lt;/', name(), '&gt;')"/>
    <xsl:if test="following-sibling::*">
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()[normalize-space()]" mode="copy-verbatim">
    <xsl:call-template name="indent"/>
    <xsl:value-of select="normalize-space()"/>
  </xsl:template>

  <xsl:template name="indent">
    <xsl:param name="n" select="count(ancestor::*) - 8"/>
    <xsl:if test="$n > 0">
      <xsl:text>  </xsl:text>
      <xsl:call-template name="indent">
        <xsl:with-param name="n" select="$n - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:transform>
