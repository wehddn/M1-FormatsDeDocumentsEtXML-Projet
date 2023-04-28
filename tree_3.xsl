<!-- Adding a maxposition attribute to racine -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema">

  <!-- Define constant value for hauteur -->
  <xsl:variable name="hauteur" select="500"/>
  <xsl:variable name="largeur" select="500"/>

  <!-- Match the racine element -->
  <xsl:template match="racine">
    <xsl:variable name="maxdepth" select="@maxdepth"/>
    <xsl:variable name="maxposition" select="@maxposition"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node[@position]">
    <xsl:variable name="maxdepth" select="//racine/@maxdepth"/>
    <xsl:variable name="depth" select="@depth"/>
    <xsl:variable name="Y" select="$hauteur div $maxdepth * $depth"/>
    <xsl:variable name="maxposition" select="//racine/@maxposition"/>
    <xsl:variable name="position" select="@position"/>
    <xsl:variable name="X" select="$largeur div $maxposition * $position"/>
    <xsl:copy>
      <xsl:attribute name="X">
        <xsl:value-of select="$X"/>
      </xsl:attribute>
      <xsl:attribute name="Y">
        <xsl:value-of select="$Y"/>
      </xsl:attribute>
    </xsl:copy>
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
    <xsl:copy>
      <xsl:variable name="X">
        <xsl:apply-templates select="." mode="calculate"/>
      </xsl:variable>
      <xsl:attribute name="X">
        <xsl:value-of select="$X"/>
      </xsl:attribute>
      <xsl:attribute name="Y">
        <xsl:value-of select="$Y"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
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
            <xsl:value-of select="(sum(for $i in $child-X-nodes return number($i))) div 2"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="sum(for $i in $child-X-nodes return number($i))"/>
            </xsl:otherwise>
          </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$X"/>
  </xsl:template>



</xsl:stylesheet>