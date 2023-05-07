<!-- Adding a maxposition attribute to racine -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math">

  <!-- Define constant values -->
  <xsl:variable name="rectWidth" select="500" />
  <xsl:variable name="rectHeight" select="500" />
  <xsl:variable name="vertical" select="min(($rectWidth, $rectHeight)) div 2 div //racine/@maxdepth" />

  <xsl:variable name="cx" select="$rectWidth div 2" />
  <xsl:variable name="cy" select="$rectHeight div 2" />

  <!-- Match the racine element -->
  <xsl:template match="racine">
    <xsl:text>&#xa;</xsl:text>
    <svg:svg width="100%" height="100%" viewBox="-50 -50 {$rectWidth + 50} {$rectHeight + 50}">
      <xsl:text>&#xa;</xsl:text>
      <xsl:apply-templates />
    </svg:svg>
  </xsl:template>


  <xsl:template match="node[@position]">
    <xsl:variable name="maxdepth" select="//racine/@maxdepth" />
    <xsl:variable name="depth" select="@depth" />
    <xsl:variable name="maxposition" select="//racine/@maxposition" />
    <xsl:variable name="position" select="@position" />
    <xsl:variable name="theta" select="$position div $maxposition * 2 * math:pi()" />
    <xsl:variable name="radius" select="($depth +1) * $vertical" />
    <xsl:variable name="radius2" select="$depth * $vertical" />
    <xsl:variable name="X" select="$cx + $radius * math:cos($theta)" />
    <xsl:variable name="Y" select="$cy + $radius * math:sin($theta)" />
    <xsl:variable name="X2" select="$cx + $radius2 * math:cos($theta)" />
    <xsl:variable name="Y2" select="$cy + $radius2 * math:sin($theta)" />
    <svg:line x1="{$X}" y1="{$Y}" x2="{$X2}" y2="{$Y2}" stroke="red" />

  </xsl:template>

  <xsl:template match="node[@position]" mode="calculate">
    <xsl:variable name="maxdepth" select="//racine/@maxdepth" />
    <xsl:variable name="depth" select="@depth" />
    <xsl:variable name="maxposition" select="//racine/@maxposition" />
    <xsl:variable name="position" select="@position" />

    <xsl:variable name="theta" select="$position div $maxposition * 2 * math:pi()" />

    <xsl:variable name="radius" select="$depth * $vertical" />

    <xsl:variable name="X" select="$cx + $radius * math:cos($theta)" />
    <xsl:variable name="Y" select="$cy + $radius * math:sin($theta)" />

    <xsl:sequence select="$X, $Y, $theta" />
  </xsl:template>

  <xsl:template match="node[not(@position)]">
    <xsl:variable name="depth" select="@depth" />
    <xsl:variable name="radius" select="($depth + 1) * $vertical" />
    <xsl:variable name="radius2" select="$depth * $vertical" />
    <xsl:variable name="child1">
      <xsl:apply-templates select="child::*[1]" mode="calculate" />
    </xsl:variable>
    <xsl:variable name="child2">
      <xsl:apply-templates select="child::*[last()]" mode="calculate" />
    </xsl:variable>
    <!-- <xsl:message select="tokenize($child1, ' ')[2]"/>  -->
    <xsl:if test="count(child::*) > 1">
      <svg:path d="M {tokenize($child1, ' ')[1]},{tokenize($child1, ' ')[2]} A {$radius},{$radius} 0 0 1 {tokenize($child2, ' ')[1]},{tokenize($child2, ' ')[2]}" stroke="black" fill="none"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(child::*) > 1">
        <xsl:variable name="theta" select="(tokenize($child2, ' ')[3] + tokenize($child1, ' ')[3]) div 2" />
        <xsl:variable name="X" select="$cx + $radius * math:cos($theta)" />
        <xsl:variable name="Y" select="$cy + $radius * math:sin($theta)" />
        <xsl:variable name="X2" select="$cx + $radius2 * math:cos($theta)" />
        <xsl:variable name="Y2" select="$cy + $radius2 * math:sin($theta)" />
        <svg:line x1="{$X}" y1="{$Y}" x2="{$X2}" y2="{$Y2}" stroke="black" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="theta" select="tokenize($child1, ' ')[3]" />
        <xsl:variable name="X" select="tokenize($child1, ' ')[1]" />
        <xsl:variable name="Y" select="tokenize($child1, ' ')[2]" />
        <xsl:variable name="X2" select="$cx + $radius2 * math:cos($theta)" />
        <xsl:variable name="Y2" select="$cy + $radius2 * math:sin($theta)" />
        <svg:line x1="{$X}" y1="{$Y}" x2="{$X2}" y2="{$Y2}" stroke="black" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="node[not(@position)]" mode="calculate">
    <xsl:variable name="depth" select="@depth" />
    <xsl:variable name="radius" select="$depth * $vertical" />
    <xsl:variable name="XYT">
      <xsl:variable name="child1">
        <xsl:apply-templates select="child::*[1]" mode="calculate" />
      </xsl:variable>
      <xsl:variable name="child2">
        <xsl:apply-templates select="child::*[last()]" mode="calculate" />
      </xsl:variable>
      <!-- <xsl:message select="tokenize($child1, ' ')[2]"/>  -->
      <xsl:choose>
        <xsl:when test="count(child::*) > 1">
          <xsl:variable name="theta" select="(tokenize($child2, ' ')[3] + tokenize($child1, ' ')[3]) div 2" />
          <xsl:variable name="X" select="$cx + $radius * math:cos($theta)" />
          <xsl:variable name="Y" select="$cy + $radius * math:sin($theta)" />
          <xsl:sequence select="$X, $Y, $theta" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="tokenize($child1, ' ')[1], tokenize($child1, ' ')[2], tokenize($child1, ' ')[3]" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="$XYT[1], $XYT[2], $XYT[3]" />
  </xsl:template>


</xsl:stylesheet>