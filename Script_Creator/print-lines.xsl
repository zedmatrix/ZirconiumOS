<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
    <xsl:template name="print-lines">
    <xsl:param name="text"/>
    <xsl:param name="inHereDoc" select="false()"/>

        <xsl:choose>
            <xsl:when test="contains($text, '&#10;')">
            <xsl:variable name="line" select="substring-before($text, '&#10;')"/>
            <xsl:variable name="nline" select="normalize-space($line)"/>
            <xsl:variable name="last2" select="substring($nline, string-length($nline) - 1, 2)"/>
            
            <xsl:text>  </xsl:text>
            <xsl:value-of select="$line" disable-output-escaping="yes"/>

            <!-- Detect here-doc start -->
            <xsl:variable name="newInHereDoc" select="($inHereDoc or contains($nline, '&lt;&lt;'))"/>

            <!-- Append && only if not in here-doc and line doesn't end with '\' or '&&' -->
            <xsl:if test="not($newInHereDoc) and not(substring($nline, string-length($nline), 1) = '\') and not($last2 = '&amp;&amp;')">
                <xsl:text> &amp;&amp;</xsl:text>
            </xsl:if>

            <xsl:text>&#10;</xsl:text>

            <!-- Continue recursion; exit here-doc when line is 'EOF' -->
            <xsl:call-template name="print-lines">
                <xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
                <xsl:with-param name="inHereDoc" select="($newInHereDoc and not($nline = 'EOF'))"/>
            </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>
            <xsl:text>  </xsl:text>
            <xsl:value-of select="$text" disable-output-escaping="yes"/>
            <xsl:text>&#10;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
