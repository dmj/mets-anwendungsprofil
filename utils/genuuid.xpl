<p:declare-step version="1.0"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:uuid="tag:maus@hab.de,2018:uuid"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source"/>
  <p:output port="result"/>

  <p:add-attribute match="mets:*[@ID]" attribute-name="uuid:uuid" attribute-value=""/>
  <p:viewport match="mets:*[@ID]">
    <p:uuid match="@uuid:uuid" version="4"/>
  </p:viewport>

  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="genuuid.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

</p:declare-step>
