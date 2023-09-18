<!-- Adding a maxposition attribute to racine -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Identity template to copy all nodes -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!-- Match the racine element -->
<xsl:template match="racine">
  <xsl:variable name="maxpos">
    <xsl:for-each select="//node()[@position]">
      <xsl:sort select="@position" data-type="number" order="descending"/>
      <xsl:if test="position() = 1">
        <xsl:value-of select="@position"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:text>&#xa;</xsl:text>
  <xsl:copy>
    <xsl:attribute name="maxposition">
      <xsl:value-of select="$maxpos"/>
    </xsl:attribute>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
