<!-- Clearing the tree, adding a depth attribute to node and a maxdepth attribute to racine -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Identity template to copy racine -->
  <xsl:template match="racine">
    <xsl:text>&#xa;</xsl:text>
    <xsl:copy>
      <xsl:attribute name="maxdepth">
        <xsl:value-of select="max(//node()[not(node())]/count(ancestor::node()))-2" />
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Identity template to copy nodes without attributes and add depth attribute -->
  <xsl:template match="node">
    <xsl:param name="depth" select="0" />
    <xsl:copy>
      <!-- Add depth attribute with value equal to the current depth -->
      <xsl:attribute name="depth">
        <xsl:value-of select="$depth" />
      </xsl:attribute>
      <!-- Apply templates to child nodes with incremented depth parameter -->
      <xsl:apply-templates>
        <xsl:with-param name="depth" select="$depth + 1" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
