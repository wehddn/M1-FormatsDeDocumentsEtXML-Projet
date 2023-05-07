<!-- Adding a maxposition attribute to racine -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math">

  <!-- Define constant values -->
  <xsl:variable name="rectWidth" select="500" />
  <xsl:variable name="rectHeight" select="500" />
  <!-- Node line length -->
  <xsl:variable name="lineLength" select="min(($rectWidth, $rectHeight)) div 2 div //racine/@maxdepth" />

  <!-- Coordinates of the center -->
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
    <xsl:variable name="theta" select="$position div $maxposition * 2 * math:pi() * (-1)" />
    <xsl:variable name="radius" select="($depth +1) * $lineLength" />
    <xsl:variable name="radius2" select="$depth * $lineLength" />
    <xsl:variable name="X" select="$cx + $radius * math:cos($theta)" />
    <xsl:variable name="Y" select="$cy + $radius * math:sin($theta)" />
    <xsl:variable name="X2" select="$cx + $radius2 * math:cos($theta)" />
    <xsl:variable name="Y2" select="$cy + $radius2 * math:sin($theta)" />
    <svg:line x1="{$X}" y1="{$Y}" x2="{$X2}" y2="{$Y2}" stroke="black" />
  </xsl:template>

  <xsl:template match="node[@position]" mode="calculate">
    <xsl:variable name="maxdepth" select="//racine/@maxdepth" />
    <xsl:variable name="depth" select="@depth" />
    <xsl:variable name="maxposition" select="//racine/@maxposition" />
    <xsl:variable name="position" select="@position" />
    <xsl:variable name="theta" select="$position div $maxposition * 2 * math:pi() * (-1)" />
    <xsl:variable name="radius" select="$depth * $lineLength" />
    <xsl:variable name="X" select="$cx + $radius * math:cos($theta)" />
    <xsl:variable name="Y" select="$cy + $radius * math:sin($theta)" />
    <xsl:sequence select="$X, $Y, $theta" />
  </xsl:template>

  <xsl:template match="node[not(@position)]">
    <xsl:variable name="depth" select="@depth" />
    <xsl:variable name="radius" select="($depth + 1) * $lineLength" />
    <xsl:variable name="radius2" select="$depth * $lineLength" />

    <xsl:variable name="child1">
      <xsl:apply-templates select="child::*[1]" mode="calculate" />
    </xsl:variable>

    <xsl:variable name="child2">
      <xsl:apply-templates select="child::*[last()]" mode="calculate" />
    </xsl:variable>

    <xsl:variable name="child1Theta" select="tokenize($child1, ' ')[3]" />
    <xsl:variable name="child2Theta" select="tokenize($child2, ' ')[3]" />
    <xsl:variable name="child1X" select="tokenize($child1, ' ')[1]"/>
    <xsl:variable name="child1Y" select="tokenize($child1, ' ')[2]"/>
    <xsl:variable name="child2X" select="tokenize($child2, ' ')[1]"/>
    <xsl:variable name="child2Y" select="tokenize($child2, ' ')[2]"/>

    <xsl:choose>
      <xsl:when test="count(child::*) > 1">
        <xsl:variable name="theta" select="($child2Theta + $child1Theta) div 2" />
        <xsl:variable name="X" select="$cx + $radius * math:cos($theta)" />
        <xsl:variable name="Y" select="$cy + $radius * math:sin($theta)" />
        <xsl:variable name="X2" select="$cx + $radius2 * math:cos($theta)" />
        <xsl:variable name="Y2" select="$cy + $radius2 * math:sin($theta)" />
        <svg:line x1="{$X}" y1="{$Y}" x2="{$X2}" y2="{$Y2}" stroke="black" />

        <xsl:variable name="direction" select="if (abs($child2Theta - $child1Theta) &lt; math:pi()) then 0 else 1" />
        <svg:path d="M {$child1X},{$child1Y} A {$radius},{$radius} 0 {$direction} 0 {$child2X},{$child2Y}" stroke="black" fill="none"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="theta" select="$child1Theta" />
        <xsl:variable name="X" select="$child1X" />
        <xsl:variable name="Y" select="$child1Y" />
        <xsl:variable name="X2" select="$cx + $radius2 * math:cos($theta)" />
        <xsl:variable name="Y2" select="$cy + $radius2 * math:sin($theta)" />
        <svg:line x1="{$X}" y1="{$Y}" x2="{$X2}" y2="{$Y2}" stroke="black" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates />
  </xsl:template>


  <xsl:template match="node[not(@position)]" mode="calculate">
    <xsl:variable name="depth" select="@depth" />
    <xsl:variable name="radius" select="$depth * $lineLength" />

    <xsl:variable name="child1">
      <xsl:apply-templates select="child::*[1]" mode="calculate" />
    </xsl:variable>

    <xsl:variable name="child2">
      <xsl:apply-templates select="child::*[last()]" mode="calculate" />
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="count(child::*) > 1">
        <xsl:variable name="theta" select="(tokenize($child2, ' ')[3] + tokenize($child1, ' ')[3]) div 2" />
        <xsl:variable name="X" select="$cx + $radius * math:cos($theta)" />
        <xsl:variable name="Y" select="$cy + $radius * math:sin($theta)" />
        <xsl:sequence select="$X, $Y, $theta" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="child1" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>