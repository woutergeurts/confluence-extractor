<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ab="http://example.com/ab" exclude-result-prefixes="ab">
    
    <!-- Identiteitstransformatie: behoudt alles zoals het is -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Vervang <ab:code> door <code> -->
    <xsl:template match="ab:code">
        <code>
            <xsl:apply-templates select="@*|node()"/>
        </code>
    </xsl:template>
    
</xsl:stylesheet>
