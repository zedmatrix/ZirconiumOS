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
<!-- Start of URL-Filename Parser -->

      <!-- tarball (from URL) -->
      <xsl:variable name="tarball">
        <xsl:call-template name="basename-from-url">
          <xsl:with-param name="path" select="$pkgurl"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:text>tarball=(</xsl:text><xsl:value-of select="$tarball"/><xsl:text>)&#10;</xsl:text>

      <!-- filename = tarball -->
      <xsl:variable name="filename" select="$tarball"/>
      <xsl:text>filename=(</xsl:text><xsl:value-of select="$filename"/><xsl:text>)&#10;</xsl:text>

      <!-- strip extension -->
      <xsl:variable name="namever" select="substring-before($filename, '.tar')"/>

      <!-- basename = everything but last dash part -->
      <xsl:variable name="basename">
        <xsl:call-template name="all-but-last-dash">
          <xsl:with-param name="text" select="$namever"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:text>basename=(</xsl:text><xsl:value-of select="$basename"/><xsl:text>)&#10;</xsl:text>

      <!-- version = last dash part -->
      <xsl:variable name="version">
        <xsl:call-template name="last-dash">
          <xsl:with-param name="text" select="$namever"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:text>version=(</xsl:text><xsl:value-of select="$version"/><xsl:text>)&#10;</xsl:text>


<!-- End of URL-File Parser -->
      <xsl:variable name="pkgname" select="$basename"/>
      <xsl:variable name="pkgver" select="$version"/>
      <xsl:variable name="pkgdir" select="substring-before($filename, '.tar')"/>

      <xsl:variable name="required" select=".//para[@role='required']//xref/@linkend"/>
      <xsl:variable name="recommended" select=".//para[@role='recommended']//xref/@linkend"/>
      <xsl:variable name="optional" select=".//para[@role='optional']//xref/@linkend"/>

<!-- Package Definitions -->
      <xsl:text>&#10;-- Separation --&#10;</xsl:text>
      <xsl:text>package:&#10;</xsl:text>
      <xsl:text>    name: </xsl:text><xsl:value-of select="$pkgname"/><xsl:text>&#10;</xsl:text>
      <xsl:text>    version: </xsl:text><xsl:value-of select="$pkgver"/><xsl:text>&#10;</xsl:text>
      <xsl:text>    rel: 1&#10;</xsl:text>
      <xsl:text>    archive: false&#10;</xsl:text>
      <xsl:text>    delete: true&#10;&#10;</xsl:text>

      <xsl:text>sources: &#10;</xsl:text>
      <xsl:text>    - url: </xsl:text><xsl:value-of select="$pkgurl"/><xsl:text>&#10;</xsl:text>
      <xsl:text>      md5: </xsl:text><xsl:value-of select="normalize-space($md5)"/><xsl:text>&#10;&#10;</xsl:text>

<!-- Find the Additional Downloads itemizedlist -->
      <xsl:variable name="additional"
          select=".//bridgehead[normalize-space(.)='Additional Downloads']/following-sibling::itemizedlist[1]"/>

<!-- Iterate through each listitem -->
      <xsl:for-each select="$additional/listitem">
        <xsl:variable name="text" select="normalize-space(para)"/>

        <!-- Case: a patch or download link -->
        <xsl:if test="para/ulink">
          <xsl:text>    - url: </xsl:text>
          <xsl:value-of select="para/ulink/@url"/>
          <xsl:text>&#10;</xsl:text>

          <!-- Look ahead for MD5 and size in following siblings -->
          <xsl:if test="following-sibling::listitem[1]/para[contains(., 'MD5')]">
            <xsl:text>      md5: </xsl:text>
            <xsl:value-of select="normalize-space(substring-after(following-sibling::listitem[1]/para, 'MD5 sum:'))"/>
            <xsl:text>&#10;</xsl:text>
          </xsl:if>

          <xsl:if test="following-sibling::listitem[2]/para[contains(., 'size')]">
            <xsl:text>  size: </xsl:text>
            <xsl:value-of select="normalize-space(substring-after(following-sibling::listitem[2]/para, 'Download size:'))"/>
            <xsl:text>&#10;&#10;</xsl:text>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>

      <xsl:text>prepare: &#124;&#10;&#10;</xsl:text>

      <xsl:text>build: &#124;&#10;    </xsl:text>
      <xsl:for-each select="$build">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last()"><xsl:text> &amp;&#10; </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>

      <xsl:text>check: &#124;&#10;    </xsl:text>
      <xsl:for-each select="$check">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last()"><xsl:text> &amp;&#10; </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>

      <xsl:text>install: &#124;&#10;    </xsl:text>
      <xsl:for-each select="$install">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last()"><xsl:text> &amp;&#10; </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>&#10;&#10;</xsl:text>

      <xsl:text>final: &#124;&#10;    </xsl:text>

      <xsl:text>&#10;-- Separation --&#10;</xsl:text>
      <xsl:if test="$required">
        <xsl:text>required:&#10;</xsl:text>
        <xsl:for-each select="$required">
          <xsl:text>    - </xsl:text>
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">&#10;</xsl:if>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
      </xsl:if>

      <xsl:if test="$recommended">
        <xsl:text>recommended:&#10;</xsl:text>
        <xsl:for-each select="$recommended">
          <xsl:text>    - </xsl:text>
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">&#10;</xsl:if>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
      </xsl:if>

      <xsl:if test="$optional">
        <xsl:text>optional:</xsl:text>
        <xsl:for-each select="$optional">
          <xsl:text>    - </xsl:text>
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">&#10;</xsl:if>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
      </xsl:if>

    </xsl:for-each>
    <!-- Find the Additional Downloads itemizedlist -->
    <xsl:variable name="additional" select=".//bridgehead[.='Additional Downloads']/following-sibling::itemizedlist[1]"/>

    <!-- Iterate through all HTTP additional downloads -->
    <xsl:for-each select="$additional//para[contains(., 'Download (HTTP)')]/ulink">
      <xsl:text>    - url: </xsl:text><xsl:value-of select="@url"/><xsl:text>&#10;</xsl:text>
    </xsl:for-each>

    <!-- Iterate through all MD5 sums -->
    <xsl:for-each select="$additional//para[contains(., 'MD5 sum')]">
      <xsl:text>       md5: </xsl:text>
      <xsl:value-of select="normalize-space(substring-after(., 'MD5 sum: '))"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>
