<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" 
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="a">
                 
 <xsl:output version="1.0"
             encoding="utf-8"
             method="html"
             indent="yes"
             omit-xml-declaration="yes"/>

 <xsl:variable name="empty_string" select="''"/>
 <xsl:variable name="place_margin" select="'margin'"/>
 <xsl:variable name="groupSize" select="1"/>
 <xsl:variable name="totRcrdNr" select="count( //tei:div/tei:div )"/>
 <xsl:variable name="pagNumbrs" select="ceiling( $totRcrdNr div $groupSize )"/>
 
 <xsl:param name="crrntPag" select="1"/>

 <xsl:template match="tei:TEI">
  <xsl:element name="ol">
   <xsl:apply-templates select="//tei:div/tei:div[ position() mod $groupSize=0 ]"/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="//tei:div/tei:div">
  <xsl:if test="position()=$crrntPag">
   <xsl:for-each select=". | following-sibling::tei:div[ position() &lt; $groupSize ]">
    <xsl:apply-templates/>
   </xsl:for-each>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="tei:app">
  <xsl:variable name="app_number" select="count( preceding::tei:app ) + 1"/>
  <xsl:call-template name="reading">
   <xsl:with-param name="number" select="$app_number"/>
  </xsl:call-template>
 </xsl:template>
 
 <xsl:template name="reading">
  <xsl:param name="number"/>
  <xsl:element name="li">
   <xsl:attribute name="id">
    <xsl:value-of select="concat( '#apparato' , $number )"/>
   </xsl:attribute>
   <xsl:element name="sup">
    <xsl:attribute name="class">
      <xsl:value-of select="'visible'"/>
     </xsl:attribute>
    <xsl:element name="a">
     <xsl:attribute name="href">
      <xsl:value-of select="concat( '#testocritico' , $number )"/>
     </xsl:attribute>
     <xsl:copy>
      <xsl:value-of select="$number"/>
     </xsl:copy>
    </xsl:element>
   </xsl:element>
   <xsl:for-each select="tei:lem">
    <xsl:element name="span">
     <xsl:attribute name="class">
      <xsl:value-of select="'lemma'"/>
     </xsl:attribute>
     <xsl:choose>
      <xsl:when test="text() != 0">
       <xsl:value-of select="text() | tei:formula"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="..//text()"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:element>
   </xsl:for-each>
   <xsl:copy-of select="':'"/>
   <xsl:element name="span">
    <xsl:attribute name="class">
     <xsl:value-of select="'sintagma'"/>
    </xsl:attribute>
    <xsl:for-each select="*[@wit or @hand]">
     <xsl:call-template name="space"></xsl:call-template>
     <xsl:element name="span">
      <xsl:attribute name="class">
       <xsl:value-of select="'reading'"/>
      </xsl:attribute>
      <xsl:choose>
       <xsl:when test="normalize-space(.)=$empty_string">
       <xsl:call-template name="cursive">
        <xsl:with-param name="class" select="'OM'"/>
        <xsl:with-param name="text" select="'om.'"/>
        <xsl:call-template name="space"></xsl:call-template>
       </xsl:call-template>
       </xsl:when>
       <xsl:when test="text() != 0">
        <xsl:value-of select="text() | tei:formula"/>
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="..//text()"/>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:element>
     <xsl:if test="string-length( @wit ) > 0">
      <xsl:call-template name="witnesses">
       <xsl:with-param name="wit" select="@wit"/>
      </xsl:call-template>
     </xsl:if>
     <xsl:if test="string-length( @hand ) > 0">
      <xsl:call-template name="witnesses">
       <xsl:with-param name="wit" select="@hand"/>
      </xsl:call-template>
     </xsl:if>
    </xsl:for-each>
   </xsl:element>
   <xsl:for-each select="*//tei:app">
    <xsl:call-template name="reading">
     <xsl:with-param name="number" select="$number+1"/>
    </xsl:call-template>
   </xsl:for-each>
  </xsl:element>
 </xsl:template>
 
 <xsl:template name="witnesses">
  <xsl:param name="wit"/>
  <xsl:variable name="first-wit" select="normalize-space( 
   substring-before( concat( $wit , ' '), ' ') )"/>
  <xsl:if test="$first-wit">
   <xsl:call-template name="space"></xsl:call-template>
   <xsl:element name="i">
    <xsl:attribute name="class">
     <xsl:value-of select="substring( string( $first-wit ) , 2 )"/>
    </xsl:attribute>
    <xsl:value-of select="substring( string( $first-wit ) , 2 )"/>
   </xsl:element>
   <xsl:call-template name="witnesses">
    <xsl:with-param name="wit" select="substring-after( $wit , ' ' )"/>
   </xsl:call-template>
  </xsl:if>
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


