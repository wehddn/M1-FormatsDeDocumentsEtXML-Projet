<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:param name="path" as="xsd:string" select="''"/>
    <xsl:value-of select="concat($path, @node_name, '&#10;')"/>
    <xsl:apply-templates select="node">
          <xsl:with-param name="path" select="concat($path, '* ')"/>
        </xsl:apply-templates>
    
  </xsl:template>

</xsl:transform>
