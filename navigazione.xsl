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

 <xsl:variable   name = "empty_string" select="''"/>
 <xsl:variable   name = "place_margin" select="'margin'"/>
 <xsl:variable   name = "groupSize" select="1"/>
 <xsl:variable   name = "totRcrdNr" select="count(//tei:div/tei:div)"/>
 <xsl:variable   name = "pagNumbrs" select="ceiling($totRcrdNr div $groupSize)"/>
 
 <xsl:param      name = "crrntPag" select="1" />

 <xsl:strip-space elements = "*"/>

 <xsl:template match = "tei:TEI">
  <xsl:element name="div">
   <xsl:choose>
    <xsl:when test="$crrntPag&gt;1">
     <input type="button" onclick="init({$crrntPag - 1}, 1, 1)" value="⏪" id="inPrev"></input>
    <input type="button" onclick="init({1}, 1, 1)" value="⏮" id="inFrst"></input>
    </xsl:when>
    <xsl:otherwise>
     <input value="⏪" type="button"><xsl:attribute name="disabled"></xsl:attribute></input>
     <input value="⏮" type="button"><xsl:attribute name="disabled"></xsl:attribute></input>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:element>
  <xsl:value-of select="$crrntPag"/>/<xsl:value-of select="$pagNumbrs"/>
  <xsl:element name="div">
   <xsl:choose>
    <xsl:when test="$crrntPag&lt;$pagNumbrs">
     <input type="button" onclick="init({$pagNumbrs}, 1, 1)" value="⏭" id="inLast"></input>
    <input type="button" onclick="init({$crrntPag + 1}, 1, 1)" value="⏩" id="inNext"></input>
    </xsl:when>
    <xsl:otherwise>
     <input value="⏭" type="button"><xsl:attribute name="disabled"></xsl:attribute></input>
     <input value="⏩" type="button"><xsl:attribute name="disabled"></xsl:attribute></input>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:element>
   
 </xsl:template>

 <xsl:template match="text()"/>

</xsl:stylesheet>
