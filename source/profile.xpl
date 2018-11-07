<p:declare-step version="1.0" name="main"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:mets="http://www.loc.gov/METS/">

  <p:documentation xmlns="http://www.w3.org/1999/xhtml">
    <p>Validiert eine METS-Datei gegen die Regeln des Anwendungsprofils</p>
  </p:documentation>

  <p:input  port="source" primary="true"/>

  <p:validate-with-xml-schema assert-valid="true" name="validate-xsd">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="schema">
      <p:document href="../schema/mets.xsd"/>
    </p:input>
  </p:validate-with-xml-schema>

  <p:viewport match="rdf:Description[ancestor::mets:rightsMD]" name="validate-rightsMD">
    <p:viewport-source>
      <p:pipe step="validate-xsd" port="result"/>
    </p:viewport-source>
    <p:validate-with-relax-ng assert-valid="true">
      <p:input port="schema">
        <p:data href="http://uri.hab.de/instance/schema/diglib-rightsmd.rnc" content-type="text/plain"/>
      </p:input>
    </p:validate-with-relax-ng>
  </p:viewport>

  <p:viewport match="rdf:Description[ancestor::mets:dmdSec]">
    <p:viewport-source>
      <p:pipe step="validate-rightsMD" port="result"/>
    </p:viewport-source>
    <p:validate-with-relax-ng assert-valid="true">
      <p:input port="schema">
        <p:data href="http://uri.hab.de/instance/schema/diglib-structmd.rnc" content-type="text/plain"/>
      </p:input>
    </p:validate-with-relax-ng>
  </p:viewport>

  <p:sink/>

</p:declare-step>
