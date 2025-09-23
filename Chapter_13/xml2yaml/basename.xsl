<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Template to get the last path segment -->
    <xsl:template name="basename-from-url">
    <xsl:param name="path"/>
    <xsl:choose>
        <!-- if there's still a slash, recurse on substring after the first slash -->
        <xsl:when test="contains($path, '/')">
        <xsl:call-template name="basename-from-url">
            <xsl:with-param name="path" select="substring-after($path, '/')"/>
        </xsl:call-template>
        </xsl:when>
        <!-- otherwise return what's left -->
        <xsl:otherwise>
        <xsl:value-of select="$path"/>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:template>

    <xsl:template name="last-dash">
    <xsl:param name="text"/>
    <xsl:choose>
        <xsl:when test="contains($text, '-')">
        <xsl:call-template name="last-dash">
            <xsl:with-param name="text" select="substring-after($text, '-')"/>
        </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="$text"/>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:template>

    <xsl:template name="all-but-last-dash">
    <xsl:param name="text"/>
    <xsl:choose>
        <xsl:when test="contains($text, '-')">
        <xsl:variable name="head" select="substring-before($text, '-')"/>
        <xsl:variable name="tail" select="substring-after($text, '-')"/>
        <xsl:choose>
            <!-- recurse if tail still has a dash -->
            <xsl:when test="contains($tail, '-')">
            <xsl:value-of select="$head"/>
            <xsl:text>-</xsl:text>
            <xsl:call-template name="all-but-last-dash">
                <xsl:with-param name="text" select="$tail"/>
            </xsl:call-template>
            </xsl:when>
            <!-- otherwise, tail is the version, so return just the head -->
            <xsl:otherwise>
            <xsl:value-of select="$head"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="$text"/>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
