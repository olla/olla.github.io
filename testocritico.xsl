<?xml version="1.0" encoding="UTF-8" standalone="yes"?>

<xsl:stylesheet  version   = "2.0" 
                 xmlns:tei = "http://www.tei-c.org/ns/1.0"
                 xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
                 exclude-result-prefixes = "a">
                 
 <xsl:output     version  = "1.0"
                 encoding = "utf-8"
                 method   = "html"
                 indent   = "yes"
                 omit-xml-declaration = "yes"/>

 <xsl:variable   name   = "empty_string" 
                 select = "''"/>
 <xsl:variable   name   = "place_margin" 
                 select = "'margin'"/>
 <xsl:variable   name   = "groupSize" 
                 select = "1"/>
 <xsl:variable   name   = "totRcrdNr" 
                 select = "count(//tei:div/tei:div)"/>
 <xsl:variable   name   = "pagNumbrs" 
                 select = "ceiling($totRcrdNr div $groupSize)"/>
 
 <xsl:param      name = "crrntPag" select="1" />

 <xsl:strip-space elements = "*"/>

 <xsl:template   match = "tei:TEI">
  <xsl:apply-templates 
                 select ="//tei:div/tei:div[position() mod $groupSize = 0]"/>     
 </xsl:template>

 <xsl:template match="tei:div/tei:div">
  <xsl:if test="position()=$crrntPag">
   <xsl:for-each select=". | following-sibling::tei:div[position() &lt; $groupSize]">
    <xsl:element name="section">
     <xsl:attribute name="id">
      <xsl:value-of select="@n"/>
     </xsl:attribute>
     <xsl:element name="header">
      <xsl:element name="h2">
       <xsl:attribute name="id">
        <xsl:value-of select="@n"/>
       </xsl:attribute>
       <xsl:choose test="tei:head">
        <xsl:when test="tei:head">
         <xsl:apply-templates select="tei:head"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:call-template name="space"></xsl:call-template>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:element>
     </xsl:element>
     <xsl:element name="article">
      <xsl:attribute name="id">
       <xsl:value-of select="@n"/>
      </xsl:attribute>
      <xsl:apply-templates select="tei:p[@n]"/>
     </xsl:element>
    </xsl:element>
   </xsl:for-each>
  </xsl:if>
 </xsl:template>

 <xsl:template match="tei:app">
  <xsl:variable name="app_number" select="count( preceding::tei:app ) + count( ancestor::tei:app ) + 1"/>
  <xsl:element name="details">
  <xsl:attribute name="class"><xsl:value-of select="'visible'"/></xsl:attribute>
   <xsl:call-template name="reading">
    <xsl:with-param name="number" select="$app_number"/>
   </xsl:call-template>
  </xsl:element>
  <xsl:call-template name="space"></xsl:call-template>
 </xsl:template>
 
 <!--TODO: fattorizzare con apparato.xsl-->
 
 <xsl:template name="reading">
  <xsl:param name="number"/>
  <xsl:element name="summary">
   <xsl:attribute name="class"><xsl:value-of select="'visible'"/></xsl:attribute>
   <xsl:for-each select="tei:lem">
    <xsl:apply-templates/>
   </xsl:for-each>
   <xsl:element name="sup">
    <xsl:attribute name="class"><xsl:value-of select="'visible'"/></xsl:attribute>
    <xsl:element name="a">
     <xsl:attribute name="href">
      <xsl:value-of select="concat( '#apparato' , $number )"/>
     </xsl:attribute>
     <xsl:attribute name="id">
      <xsl:value-of select="concat( '#testocritico' , $number )"/>
     </xsl:attribute>
     <xsl:copy>
      <xsl:value-of select="$number"/>
     </xsl:copy>
    </xsl:element>
   </xsl:element>
  </xsl:element>
  <xsl:for-each select="tei:rdg">
   <xsl:element name="div">
    <xsl:element name="span">
     <xsl:attribute name="class">
      <xsl:value-of select="'reading'"/>
     </xsl:attribute>
     <xsl:apply-templates/>
     <xsl:if test="normalize-space(.) = $empty_string">
      <xsl:call-template name="cursive">
       <xsl:with-param name="class" select="'OM'"/>
       <xsl:with-param name="text" select="'om.'"/>
       <xsl:call-template name="space"></xsl:call-template>
      </xsl:call-template>
     </xsl:if>
    </xsl:element>
    <xsl:call-template name="witnesses"> 
     <xsl:with-param name="witstring" select="@wit"/> 
    </xsl:call-template>
    <xsl:call-template name="witnesses"> 
     <xsl:with-param name="witstring" select="@hand"/> 
    </xsl:call-template>
   </xsl:element>
  </xsl:for-each>
 </xsl:template>

 <xsl:template name="witnesses">
  <xsl:param name="witstring"/>
  <xsl:variable name="parsedwit" select="normalize-space( substring-before( concat( $witstring, ' '), ' ') )"/>
  <xsl:if test="$parsedwit">
   <xsl:call-template name="space"></xsl:call-template>
   <xsl:variable name="thiswit" select="substring( string( $parsedwit ) , 2 )"/>
   <xsl:call-template name="cursive">
    <xsl:with-param name="class" select="$thiswit"/>
    <xsl:with-param name="text" select="$thiswit"/>
   </xsl:call-template>
   <xsl:call-template name="witnesses"> 
    <xsl:with-param name="witstring" select="substring-after($witstring,' ')"/> 
   </xsl:call-template>    
  </xsl:if>
 </xsl:template>

 <xsl:template match="tei:add">
  <xsl:copy-of select="./text()"/>
  <xsl:if test="normalize-space(@place) = $place_margin">
   <xsl:element name="section">
   <xsl:attribute name="marg">
     <xsl:value-of select="'a marg.'"/>
   </xsl:attribute>
   </xsl:element>
  </xsl:if>
 </xsl:template>

 <xsl:template match="tei:div/tei:head//text()">
  <xsl:copy-of select="."/>
 </xsl:template>

 <xsl:template match="tei:p[@n]//text()">
   <xsl:copy-of select="."/>
 </xsl:template>
 
 <xsl:template match="tei:lem//text()">
  <xsl:element name="span">
   <xsl:attribute name="class">
     <xsl:value-of select="'lemma'"/>
   </xsl:attribute>
   <xsl:copy-of select="."/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="tei:formula">
  <xsl:element name="span">
   <xsl:attribute name="class">
     <xsl:value-of select="'formula'"/>
   </xsl:attribute>
   <xsl:copy-of select="."/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="tei:rdg//text()">
   <xsl:copy-of select="."/>
 </xsl:template>
 
 <xsl:template match="tei:rdg//tei:formula">
  <xsl:element name="span">
   <xsl:attribute name="class">
     <xsl:value-of select="'formula reading'"/>
   </xsl:attribute>
   <xsl:copy-of select="."/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template name="cursive">
  <xsl:param name="class"/>
  <xsl:param name="text"/>
  <xsl:element name ="i">
   <xsl:attribute name="class">
    <xsl:value-of select="$class"/>
   </xsl:attribute>
   <xsl:value-of select="$text"/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template name="space">
  <xsl:element name="span">
   <xsl:value-of select="'&#160;'"/>
  </xsl:element>
 </xsl:template>

 <xsl:template match="text()"/>

</xsl:stylesheet>
