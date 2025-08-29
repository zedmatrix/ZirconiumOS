<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:include href="basename.xsl"/>

  <!-- Match each top-level package -->
  <xsl:template match="/">
    <xsl:for-each select="//sect1[@id]">
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="pkgtitle" select="title"/>
      <xsl:text>title=(</xsl:text><xsl:value-of select="$pkgtitle"/><xsl:text>)&#10;</xsl:text>

      <xsl:variable name="md5full" select=".//para[contains(., 'MD5')]/text()"/>
      <xsl:variable name="md5" select="normalize-space(substring-after($md5full, 'MD5 sum: '))"/>
      <xsl:variable name="build" select=".//screen[not(@role) and not(@remap)]/userinput"/>
      <xsl:variable name="install" select=".//screen[@role='root']/userinput"/>
      <xsl:variable name="check" select=".//screen[@remap='test']/userinput"/>

      <!-- Capture full HTTP URL -->
      <xsl:variable name="pkgurl" select=".//ulink[contains(@url, 'http')]/@url"/>

<!-- Start of URL File Parser -->
      <!-- tarball (from URL) -->
      <xsl:variable name="tarball">
        <xsl:call-template name="basename-from-url">
          <xsl:with-param name="path" select="$pkgurl"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:text>tarball="</xsl:text><xsl:value-of select="$tarball"/><xsl:text>"&#10;</xsl:text>

      <!-- filename = tarball -->
      <xsl:variable name="filename" select="$tarball"/>
      <xsl:text>filename="</xsl:text><xsl:value-of select="$filename"/><xsl:text>"&#10;</xsl:text>

      <!-- strip extension -->
      <xsl:variable name="namever" select="substring-before($filename, '.tar')"/>

      <!-- basename = everything but last dash part -->
      <xsl:variable name="basename">
        <xsl:call-template name="all-but-last-dash">
          <xsl:with-param name="text" select="$namever"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:text>basename="</xsl:text><xsl:value-of select="$basename"/><xsl:text>"&#10;</xsl:text>

      <!-- version = last dash part -->
      <xsl:variable name="version">
        <xsl:call-template name="last-dash">
          <xsl:with-param name="text" select="$namever"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:text>version="</xsl:text><xsl:value-of select="$version"/><xsl:text>"&#10;</xsl:text>

<!-- End of URL File Parser -->
      <xsl:variable name="pkgname" select="$basename"/>
      <xsl:variable name="pkgver" select="$version"/>
      <xsl:variable name="pkgdir" select="substring-before($filename, '.tar')"/>

      <xsl:variable name="required" select=".//para[@role='required']//xref/@linkend"/>
      <xsl:variable name="recommended" select=".//para[@role='recommended']//xref/@linkend"/>
      <xsl:variable name="optional" select=".//para[@role='optional']//xref/@linkend"/>

      <xsl:text>&#10;-- Separation --&#10;</xsl:text>
      <xsl:text>pkgdir=[</xsl:text><xsl:value-of select="$pkgdir"/><xsl:text>]&#10;</xsl:text>
      <xsl:text>pkgname=[</xsl:text><xsl:value-of select="$pkgname"/><xsl:text>]&#10;</xsl:text>
      <xsl:text>pkgver=[</xsl:text><xsl:value-of select="$pkgver"/><xsl:text>]&#10;</xsl:text>
      <xsl:text>pkgrel=[1]&#10;</xsl:text>
      <xsl:text>zarchive=[false]&#10;</xsl:text>

      <xsl:text>pkgurl=[</xsl:text><xsl:value-of select="$pkgurl"/><xsl:text>]&#10;</xsl:text>
      <xsl:text>md5sum=[</xsl:text><xsl:value-of select="normalize-space($md5)"/><xsl:text>]&#10;&#10;</xsl:text>

      <xsl:text>preconfig=[]&#10;</xsl:text>
      <xsl:text>prepare=[]&#10;</xsl:text>

      <xsl:text>build=[</xsl:text>
      <xsl:for-each select="$build">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last()"><xsl:text> &amp;&#10; </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]&#10;</xsl:text>

      <xsl:text>check=[]&#10;</xsl:text>
      <xsl:text>check=[</xsl:text>
      <xsl:for-each select="$check">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last()"><xsl:text> &amp;&#10; </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]&#10;</xsl:text>

      <xsl:text>install=[</xsl:text>
      <xsl:for-each select="$install">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last()"><xsl:text> &amp;&#10; </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]&#10;</xsl:text>

      <xsl:text>&#10;# Optional execution order&#10;</xsl:text>
      <xsl:text>post=[]&#10;</xsl:text>
      <xsl:text>postconfig=[]&#10;</xsl:text>

      <xsl:text>&#10;-- Separation --&#10;</xsl:text>
      <xsl:if test="$required">
        <xsl:text>DEPEND=(</xsl:text>
        <xsl:for-each select="$required">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">&#xA0;</xsl:if>
        </xsl:for-each>
        <xsl:text>)&#10;</xsl:text>
      </xsl:if>

      <xsl:if test="$recommended">
        <xsl:text>recommended=(</xsl:text>
        <xsl:for-each select="$recommended">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">&#xA0;</xsl:if>
        </xsl:for-each>
        <xsl:text>)&#10;</xsl:text>
      </xsl:if>

      <xsl:if test="$optional">
        <xsl:text>optional=(</xsl:text>
        <xsl:for-each select="$optional">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">&#xA0;</xsl:if>
        </xsl:for-each>
        <xsl:text>)&#10;</xsl:text>
      </xsl:if>

    </xsl:for-each>
    <!-- Find the Additional Downloads itemizedlist -->
    <xsl:variable name="additional" select=".//bridgehead[.='Additional Downloads']/following-sibling::itemizedlist[1]"/>

    <!-- Iterate through all HTTP additional downloads -->
    <xsl:for-each select="$additional//para[contains(., 'Download (HTTP)')]/ulink">
      <xsl:text>pkgurl=[</xsl:text><xsl:value-of select="@url"/><xsl:text>]&#10;</xsl:text>
    </xsl:for-each>

    <!-- Iterate through all MD5 sums -->
    <xsl:for-each select="$additional//para[contains(., 'MD5 sum')]">
      <xsl:text>md5sum=[</xsl:text>
      <xsl:value-of select="normalize-space(substring-after(., 'MD5 sum: '))"/>
      <xsl:text>]&#10;</xsl:text>
    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>
