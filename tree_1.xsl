<!-- Clearing the tree, adding a depth attribute to node, a maxdepth attribute to racine,
      a position attribute to children without -->

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

  <!-- Identity template to copy nodes without children without attributes and add depth and position attributes -->
  <xsl:template match="*[not(*)]">
    <xsl:param name="depth" select="0" />
    <xsl:variable name="pos" select="count(preceding::*[not(*)])+1"/>
    <xsl:copy>
      <xsl:attribute name="depth">
        <xsl:value-of select="$depth" />
      </xsl:attribute>
      <xsl:attribute name="position">
        <xsl:value-of select="$pos"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
