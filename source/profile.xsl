<xsl:transform version="1.0"
               exclude-result-prefixes="mets"
               xmlns:html="http://www.w3.org/1999/xhtml"
               xmlns:profile="http://www.loc.gov/METS_Profile/v2"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="profile:METS_Profile">
    <html>
      <head>
        <title><xsl:value-of select="profile:title"/></title>
        <style type="text/css">
          body { max-width: 60em; margin: 0 auto; font-size: 14px; font-family: "Open Sans", sans; }
          ul { list-style: none; padding: 0; }
          ul.styled { list-style: disc; padding-left: 2em; }
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
        <xsl:apply-templates select="profile:profile_context/profile:resource_model/node()"/>
        <p>Es deckt folgende Anwendungsfälle ab:</p>
        <ul class="styled">
          <xsl:for-each select="profile:profile_context/profile:uses/profile:use">
            <li><xsl:apply-templates/></li>
          </xsl:for-each>
        </ul>
        <h2>Externe Schemata</h2>
        <xsl:for-each select="profile:external_schema">
          <h3><xsl:value-of select="profile:name"/></h3>
          <xsl:if test="profile:URL">
            <dl>
              <dt>URL</dt>
              <dd><xsl:value-of select="profile:URL"/></dd>
            </dl>
          </xsl:if>
          <p><xsl:value-of select="profile:context"/></p>
        </xsl:for-each>
        <h2>Kontrolliertes Vokabular</h2>
        <xsl:for-each select="profile:controlled_vocabularies/profile:vocabulary">
          <h3>
            <xsl:value-of select="profile:name"/>
            <xsl:if test="profile:maintenance_agency">
              <small> (<xsl:value-of select="profile:maintenance_agency"/>)</small>
            </xsl:if>
          </h3>
          <xsl:if test="profile:URI">
            <dl>
              <dt>URL</dt>
              <dd><xsl:value-of select="profile:URI"/></dd>
            </dl>
          </xsl:if>
          <p><xsl:value-of select="profile:context"/></p>
        </xsl:for-each>
        <h2>Strukturelle Anforderungen</h2>
        <xsl:apply-templates select="profile:structural_requirements"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="profile:requirement">
    <h3>
      Anforderung <xsl:number level="any"/>
      <small> (<xsl:value-of select="@REQLEVEL"/>)</small>
    </h3>
    <xsl:apply-templates select="profile:description/html:*"/>
    <xsl:apply-templates select="profile:tests"/>
  </xsl:template>

  <xsl:template match="profile:test[@TESTLANGUAGE = 'Schematron']">
    <h4>Schematron</h4>
    <dl>
      <xsl:for-each select="profile:testWrap/profile:testXML/sch:rule">
        <dt><xsl:value-of select="@context"/></dt>
        <xsl:if test="sch:let">
          <dd>
            <p>
              <xsl:for-each select="sch:let">
                $<xsl:value-of select="@name"/> = <xsl:value-of select="@value"/>
                <xsl:if test="position() != last()">
                  <br/>
                </xsl:if>
              </xsl:for-each>
            </p>
          </dd>
        </xsl:if>
        <xsl:for-each select="sch:assert">
          <dd>⊦ <xsl:value-of select="@test"/></dd>
        </xsl:for-each>
      </xsl:for-each>
    </dl>
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

</xsl:transform>
