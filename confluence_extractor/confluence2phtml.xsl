<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/"
  xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/"
  exclude-result-prefixes="">
   
    <!-- Macros -->
    <xsl:template match="ac:macro">
      <xsl:variable name="macro" select="@ac:name"/>
      <xsl:choose>
        <xsl:when test="$macro='code'">
          <pre><code><xsl:apply-templates/></code></pre>
      </xsl:when> 
      <xsl:otherwise>
        <xsl:comment> removed macro: name=<xsl:value-of select="@ac:name"/></xsl:comment>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template match="ac:link[child::ri:page]">
    <xsl:choose>
      <xsl:when test="ac:plain-text-link-body">
        <xsl:value-of select="ac:plain-text-link-body"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="ri:page/@ri:content-title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- remove untreated parameters -->    
  <xsl:template match="ac:parameter"/>
      
     <!-- deal with drawio: insert the png attachement -->
    <xsl:template name="ac:structured-macro-drawio">
    <img>
      <xsl:attribute name="src">
        <xsl:value-of select="concat(ac:parameter[@ac:name='diagramName'],'.png')"/>
      </xsl:attribute>
    </img>
    </xsl:template>

    <!-- status: only take 'title'-->
    <xsl:template name="ac:structured-macro-status">
    <xsl:value-of select="ac:parameter[@ac:name='title']"/>
    </xsl:template>

    <xsl:template match="ac:structured-macro">
    <xsl:choose>
      <xsl:when test="@ac:name='code'">
        <pre><code><xsl:apply-templates/></code></pre>
      </xsl:when> 
      <xsl:when test="@ac:name='drawio'">
        <xsl:call-template name="ac:structured-macro-drawio"></xsl:call-template>
      </xsl:when>
      <xsl:when test="@ac:name='drawio-sketch'">
        <xsl:call-template name="ac:structured-macro-drawio"></xsl:call-template>
      </xsl:when>
      <xsl:when test="@ac:name='status'">
        <xsl:call-template name="ac:structured-macro-status"></xsl:call-template>
      </xsl:when> 
      <xsl:when test="@ac:name='info' or @ac:name='warning' or @ac:name='jira'">
        <xsl:comment>info, worning, or jira removed</xsl:comment> 
      </xsl:when>

      <xsl:otherwise>
        <xsl:comment> BEGIN structured-macro: name=<xsl:value-of select="@ac:name"/></xsl:comment>
        <xsl:apply-templates/>
        <xsl:comment> END structured-macro: name=<xsl:value-of select="@ac:name"/></xsl:comment>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- keep everything else -->
  <xsl:template match="@*|node()">
      <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
  </xsl:template>
</xsl:stylesheet>