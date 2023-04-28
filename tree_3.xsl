<!-- Adding a maxposition attribute to racine -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:svg="http://www.w3.org/2000/svg">

  <!-- Define constant value for hauteur -->
  <xsl:variable name="hauteur" select="500"/>
  <xsl:variable name="largeur" select="500"/>
  <xsl:variable name="vertical" select="$hauteur div //racine/@maxdepth"/>

  <!-- Match the racine element -->
  <xsl:template match="racine">
    <xsl:text>&#xa;</xsl:text>
    <svg:svg width="100%" height="100%" viewBox="20 20 {$largeur} {$hauteur}">
      <xsl:variable name="horizontal" select="$largeur div @maxposition"/>
      <xsl:text>&#xa;</xsl:text>
      <xsl:apply-templates/>
    </svg:svg>
  </xsl:template>

  <xsl:template match="node[@position]">
    <xsl:variable name="maxdepth" select="//racine/@maxdepth"/>
    <xsl:variable name="depth" select="@depth"/>
    <xsl:variable name="Y" select="$hauteur div $maxdepth * $depth"/>
    <xsl:variable name="maxposition" select="//racine/@maxposition"/>
    <xsl:variable name="position" select="@position"/>
    <xsl:variable name="X" select="$largeur div $maxposition * $position"/>
    <svg:line x1="{$X}" y1="{$Y}" x2="{$X}" y2="{$Y + $vertical}" stroke="black"/>
  </xsl:template>

  <xsl:template match="node[@position]" mode="calculate">
    <xsl:variable name="position" select="@position"/>
    <xsl:variable name="maxposition" select="//racine/@maxposition"/>
    <xsl:variable name="X" select="$largeur div $maxposition * $position"/>
    <xsl:value-of select="$X"/>
  </xsl:template>

  <xsl:template match="node[not(@position)]">
    <xsl:variable name="maxdepth" select="//racine/@maxdepth"/>
    <xsl:variable name="depth" select="@depth"/>
    <xsl:variable name="Y" select="$hauteur div $maxdepth * $depth"/>
    <xsl:variable name="X">
      <xsl:apply-templates select="." mode="calculate"/>
    </xsl:variable>
    <svg:line x1="{$X}" y1="{$Y}" x2="{$X}" y2="{$Y + $vertical}" stroke="black"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="node[not(@position)]" mode="calculate">
    <xsl:variable name="X">
      <xsl:variable name="child-X-nodes" as="xsd:string*">
        <xsl:apply-templates select="child::*[1]" mode="calculate"/>
        <xsl:if test="count(child::*) > 1">
          <xsl:variable name="last-child" select="child::*[last()]" />
          <xsl:apply-templates select="$last-child" mode="calculate"/>
        </xsl:if>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="count(child::*) > 1">
          <xsl:value-of select="(number($child-X-nodes[1]) + number($child-X-nodes[2])) div 2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$child-X-nodes[1]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$X"/>
  </xsl:template>



</xsl:stylesheet>