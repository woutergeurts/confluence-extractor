<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/"
  xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/"
  xmlns:acxhtml="http://www.atlassian.com/schema/confluence/4/"
  xmlns:lookup="http://www.fundi.com.au/">

<!--

XSLT 1.0 stylesheet.

Transforms Confluence XML into wiki markup.

Last updated 2012-06-01.

Developed by Graham Hannington <graham_hannington@fundi.com.au>
(Confluence user; no other affiliation with Atlassian).

Distributed under the BSD 2-Clause license
(also known as the Simplified BSD license):

Copyright (c) 2012, Fundi Software.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

-  Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
-  Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 -->

  <xsl:output method="text"/>

  <xsl:strip-space elements="acxhtml:div acxhtml:table acxhtml:tbody acxhtml:th acxhtml:td acxhtml:tr acxhtml:ol acxhtml:ul ac:* ri:*"/>
  <xsl:preserve-space elements="acxhtml:p"/>

  <xsl:variable name="spaces" select="'                                                            '"/>
  <xsl:variable name="indentStep" select="2"/>

  
  <xsl:template match="/*">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Headings -->

    <!-- Template for acxhtml:h1 to h6 -->
    <xsl:template match="acxhtml:h1">
        <xsl:text>&#xa;&#xa;# </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="acxhtml:h2">
        <xsl:text>&#xa;&#xa;## </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="acxhtml:h3">
        <xsl:text>&#xa;&#xa;### </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="acxhtml:h4">
        <xsl:text>&#xa;&#xa;#### </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="acxhtml:h5">
        <xsl:text>&#xa;&#xa;##### </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="acxhtml:h6">
        <xsl:text>&#xa;&#xa;###### </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

  <!-- Text effects -->

  <xsl:template match="acxhtml:strong | acxhtml:b">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>**</xsl:text>
  </xsl:template>

  <!-- Emphasis and italics -->
  <xsl:template match="acxhtml:em | acxhtml:i">
    <xsl:text>*</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>*</xsl:text>
  </xsl:template>

  <!-- TODO -->
  <!-- Citation -->
  <xsl:template match="acxhtml:cite">
    <xsl:text>??</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>??</xsl:text>
  </xsl:template>

  <!-- Strikethrough -->
  <xsl:template match="acxhtml:s | acxhtml:del | acxhtml:span[@style='text-decoration: line-through;']">
    <xsl:text>~~</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>~~</xsl:text>
  </xsl:template>

  <!-- Underlined -->
  <xsl:template match="acxhtml:u">
    <xsl:text>&lt;u&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/u&gt;</xsl:text>
  </xsl:template>

  <!-- Superscript -->
  <xsl:template match="acxhtml:sup">
    <xsl:text>^</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>^</xsl:text>
  </xsl:template>

  <!-- Subscript -->
  <xsl:template match="acxhtml:sub">
    <xsl:text>~</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>~</xsl:text>
  </xsl:template>

  <!-- Code -->
  <xsl:template match="acxhtml:code">
    <xsl:text>&lt;pre&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/pre&gt;</xsl:text>
  </xsl:template>

  <!-- Preformatted -->
  <xsl:template match="acxhtml:pre">
    <xsl:choose>
      <xsl:when test="parent::*=/*">
        <xsl:text>&#xa;&#xa;```text&#xa;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;```&#xa;&#xa;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
      <xsl:text>&lt;pre&gt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&lt;/pre&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Quote -->
  <xsl:template match="acxhtml:blockquote">
    <xsl:text>{quote}</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;{quote}&#xa;</xsl:text>
  </xsl:template>

    <!-- Text breaks -->

  <!-- Line break nested in pre element -->
  <xsl:template match="acxhtml:br">
  <xsl:choose>
    <xsl:when test="ancestor::acxhtml:code/*"/>
    <xsl:otherwise>
      <xsl:text>&lt;br&gt;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

  <!-- Paragraph -->
  <xsl:template match="acxhtml:p">
      <xsl:choose> <!-- ::*[parent::p[parent::td]]" -->
      <xsl:when test="parent::*[local-name()='acxhtml:th'] and .=parent::*/*[position()=last()]"/>
      <xsl:when test="parent::*[local-name()='acxhtml:td'] and .=parent::*/*[position()=last()]"/>
      <xsl:when test="ancestor::acxhtml:td/*"/>
      <xsl:when test="ancestor::acxhtml:td/acxhtml:div/*"/>
      <xsl:when test="parent::acxhtml:th/*"/>
      <xsl:otherwise>
        <xsl:text>&#xa;&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/> 
  </xsl:template>

  
  <!-- Horizontal rules -->
  <xsl:template match="acxhtml:hr">
    <xsl:text>&#xa;----&#xa;</xsl:text>
  </xsl:template>

  <!-- helper: produce (python) repeat_string*count -->
  <xsl:template name="repeat-repeat_string">
    <xsl:param name="count" />
    <xsl:param name="repeat_string" />

    <xsl:param name="result" select="''" />
    <xsl:choose>
      <xsl:when test="$count > 0">
        <xsl:call-template name="repeat-repeat_string">
        <xsl:with-param name="count" select="$count - 1" />
        <xsl:with-param name="repeat_string" select="$repeat_string"/>
        <xsl:with-param name="result" select="concat($result, $repeat_string)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- helper: replace newlines with <br> in text -->
  <xsl:template name="replace-newlines">
    <xsl:param name="text"/>
    <xsl:choose>
        <xsl:when test="contains($text, '&#10;')">
            <xsl:value-of select="substring-before($text, '&#10;')"/>
            <xsl:text>&lt;br&gt;</xsl:text>
            <xsl:call-template name="replace-newlines">
                <xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$text"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
  
  <!-- Lists -->
   <xsl:template match="acxhtml:ol|acxhtml:ul">
      <xsl:text>&#xa;&#xa;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>

  <!-- List items -->
  <xsl:template match="acxhtml:ol/acxhtml:li | acxhtml:ul/acxhtml:li">
    <!-- Insert newline before list item, unless it is the first item of a list that is the first child of a table cell -->
    <xsl:if test="not(.=parent::*/acxhtml:ul[1] and .=parent::*/acxhtml:li[1] and parent::*=parent::*/parent::acxhtml:td/*[1])">
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>    
    <xsl:variable name="prefix">
      <xsl:choose>
        <xsl:when test="parent::acxhtml:ul">* </xsl:when>
        <xsl:when test="parent::acxhtml:ol">1. </xsl:when>
     </xsl:choose>
    </xsl:variable>
    <xsl:variable name="level" select="count(ancestor::acxhtml:ul | ancestor::acxhtml:ol)"/>
    <xsl:call-template name="repeat-repeat_string">
      <xsl:with-param name="count" select="$level" />
      <!-- 2 spaces per level -->
      <xsl:with-param name="repeat_string" select="'  '"/>
    </xsl:call-template>
    <xsl:value-of select="$prefix"/>
    <xsl:apply-templates/>
  </xsl:template>


  <!-- Insert newline after list (that are not nested) 
  <xsl:template match="acxhtml:ol[parent::*=/*] | acxhtml:ul[parent::*=/*]">
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  -->

  <!-- Links -->

  <!-- Link to Confluence page -->
  <xsl:template match="ac:link[child::ri:page]">
    <xsl:text>[</xsl:text>
    <xsl:choose>
      <xsl:when test="ac:plain-text-link-body">
        <xsl:value-of select="ac:plain-text-link-body"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="ri:page/@ri:content-title"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>](</xsl:text>
    <xsl:if test="@ri:space-key">
      <xsl:value-of select="@ri:space-key"/>
      <xsl:text>:</xsl:text>
    </xsl:if>
    <xsl:value-of select="ri:page/@ri:content-title"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- User TODO: what to do with this
  <xsl:template match="ac:link[child::ri:user]">
    <xsl:text>[</xsl:text>
    <xsl:if test="ac:plain-text-link-body">
      <xsl:value-of select="ac:plain-text-link-body"/>
      <xsl:text>|</xsl:text>
    </xsl:if>
    <xsl:text>~</xsl:text>
    <xsl:value-of select="ri:user/@ri:username"/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  -->

  <!-- Attachment -->
  <xsl:template match="ac:link[child::ri:attachment]">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="ri:attachment/@ri:filename"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- Web link -->
  <xsl:template match="acxhtml:a">
    <xsl:text>[</xsl:text>
    <xsl:if test=".">
      <xsl:apply-templates/>
    <xsl:text>](</xsl:text>
    </xsl:if>
    <xsl:value-of select="@href"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- Table first data cell (withoud header) 
  now hard coded: needs to detect the number of td's

  -->

   <xsl:template match="acxhtml:tbody/acxhtml:tr[position()=1]/acxhtml:td[position()=1]">
     <!-- |    |    | * nr of colums -->
     <xsl:text>&#xa;&#xa;|</xsl:text>
      <xsl:call-template name="repeat-repeat_string">
        <xsl:with-param name="count" select="count(../acxhtml:td)" />
        <xsl:with-param name="repeat_string" select="'     |'"/>
      </xsl:call-template>
    <!-- 2nd header line * nr of colums -->
     <xsl:text>&#xa;|</xsl:text>
      <xsl:call-template name="repeat-repeat_string">
        <xsl:with-param name="count" select="count(../acxhtml:td)" />
        <xsl:with-param name="repeat_string" select="' --- |'"/>
      </xsl:call-template>

    <!-- basically the same as acxhtml:td, but no conditions needed (are part of the match) -->
    <xsl:text>&#xa;|</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>|</xsl:text>
  </xsl:template>

  <!-- Table data cell -->
  <xsl:template name="acxhtml_td" match="acxhtml:td">
    <xsl:if test="position() = 1">
      <xsl:text>&#xa;|</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>|</xsl:text>
  </xsl:template>

  <!-- Table header cell -->
  <xsl:template match="acxhtml:th">
    <xsl:if test="position() = 1">
      <xsl:text>&#xa;|</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>|</xsl:text>

    <xsl:if test="position() = last()">
      <xsl:text>&#xa;|</xsl:text>
      <xsl:call-template name="repeat-repeat_string">
        <xsl:with-param name="count" select="count(../acxhtml:th)" />
        <xsl:with-param name="repeat_string" select="' -- |'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Insert newline after table -->
  <xsl:template match="acxhtml:table">
    <xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <!-- Images -->
  <xsl:template match="ac:image">
    <xsl:text>![](</xsl:text>
    <xsl:choose>
      <!-- Web -->
      <xsl:when test="ri:url">
        <xsl:value-of select="ri:url/@ri:value"/>
      </xsl:when>
      <!-- Attachment -->
      <xsl:when test="ri:attachment">
        <xsl:value-of select="ri:attachment/@ri:filename"/>
      </xsl:when>
    </xsl:choose>
    <xsl:text>)</xsl:text>
    <!-- 
    <xsl:if test="@*">
      <xsl:text>|</xsl:text>
      <xsl:for-each select="@*">
        <xsl:variable name="attrname" select="local-name(.)"/>
        <xsl:variable name="attrvalue" select="."/>
        <xsl:if test="position() > 1">,</xsl:if>
        <xsl:choose>
          <xsl:when test="$attrname='border'">
            <xsl:text>border=1</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$attrname"/>
            <xsl:text>=</xsl:text>
            <xsl:value-of select="$attrvalue"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
    <xsl:text>!</xsl:text>
    -->
  </xsl:template>

  <!-- Macros -->
  <xsl:template match="ac:macro">
    <xsl:variable name="macro" select="@ac:name"/>
    <xsl:variable name="indent" select="substring($spaces, 1, count(ancestor::*[local-name()='macro']) * $indentStep)"/>
    <xsl:if test="parent::*=/*">
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="document('')/*/lookup:macros/lookup:macro[@name=$macro and @indent='yes']">
      <xsl:value-of select="$indent"/>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="@ac:name"/>
    <xsl:if test="ac:parameter or ac:default-parameter">
      <xsl:text>:</xsl:text>
      <xsl:if test="ac:default-parameter">
        <xsl:value-of select="ac:default-parameter"/>
        <xsl:if test="ac:parameter">
          <xsl:text>|</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:for-each select="ac:parameter">
        <xsl:if test="position() > 1">|</xsl:if>
        <xsl:value-of select="@ac:name"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:if>
    <xsl:text>}</xsl:text>
    <xsl:if test="parent::*=/* or document('')/*/lookup:macros/lookup:macro[@name=$macro and @type='blockwrapper']">
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="ac:rich-text-body or ac:plain-text-body">
      <xsl:apply-templates/>
      <xsl:if test="$macro='code'">
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
      <xsl:if test="document('')/*/lookup:macros/lookup:macro[@name=$macro and @indent='yes' and @type='blockwrapper']">
        <xsl:value-of select="$indent"/>
      </xsl:if>
      <xsl:text>{</xsl:text>
      <xsl:value-of select="@ac:name"/>
      <xsl:text>}</xsl:text>
      <xsl:if test="not(document('')/*/lookup:macros/lookup:macro[@name=$macro and @type='inline'])">
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Drawio-Macros : add wrapper for addition of other structured-macros-->
  <!-- ![](<./{diagramName}.png>){width={diagramWidth}
  diagramName is expected to contain spaces
  -->

  
  <xsl:template name="ac:structured-macro-drawio">
    <xsl:text>![</xsl:text>
    <xsl:value-of select="ac:parameter[@ac:name='diagramName']"/>
    <xsl:text>](&lt;./</xsl:text>
    <xsl:value-of select="ac:parameter[@ac:name='diagramName']"/>
    <xsl:text>.png&gt;)</xsl:text>
    <xsl:if test="ac:parameter[@ac:name='diagramWidth']">
      <xsl:text>{width=</xsl:text>
      <xsl:value-of select="ac:parameter[@ac:name='diagramWidth']"/>
      <xsl:text>}&#xa;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="ac:structured-macro-status">
    <xsl:value-of select="ac:parameter[@ac:name='title']"/>
  </xsl:template>

  <xsl:template name="ac:structured-macro-details">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="ac:structured-macro-code">
    <xsl:choose>
      <xsl:when test="ac:plain-text-body">
        <xsl:text>&lt;pre&gt;</xsl:text>
        <xsl:call-template name="replace-newlines">
            <xsl:with-param name="text" select="." />
        </xsl:call-template>
        <xsl:text>&lt;/pre&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#xa;```&#xa;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;```&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ac:structured-macro">
    <xsl:choose>
      <xsl:when test="@ac:name='drawio'">
        <xsl:call-template name="ac:structured-macro-drawio"></xsl:call-template>
      </xsl:when>
      <xsl:when test="@ac:name='drawio-sketch'">
        <xsl:call-template name="ac:structured-macro-drawio"></xsl:call-template>
      </xsl:when>
      <xsl:when test="@ac:name='status'">
        <xsl:call-template name="ac:structured-macro-status"></xsl:call-template>
      </xsl:when> 
      <xsl:when test="@ac:name='code'">
        <xsl:call-template name="ac:structured-macro-code"></xsl:call-template>
      </xsl:when> 
      <xsl:when test="@ac:name='details'">
        <xsl:call-template name="ac:structured-macro-details"></xsl:call-template>
      </xsl:when> 
      <!-- ignore note -->
      <xsl:when test="@ac:name='info' or @ac:name='warning' or @ac:name='jira'"/> 

      <xsl:otherwise>
        <xsl:text>BEGIN {structured-macro: name=</xsl:text>
          <xsl:value-of select="@ac:name"/>
        <xsl:text>}&#xa;&#xa;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;&#xa;END {structured-macro: name=</xsl:text>
          <xsl:value-of select="@ac:name"/>
        <xsl:text>}&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ac:parameter"/>
  <xsl:template match="ac:default-parameter"/>

<lookup:macros>
  <lookup:macro name="highlight" type="inline"/>
  <lookup:macro name="span" type="inline"/>
  <lookup:macro name="color" type="inline"/>
  <lookup:macro name="table" type="blockwrapper" indent="yes"/>
  <lookup:macro name="tr" type="blockwrapper" indent="yes"/>
  <lookup:macro name="td" indent="yes"/>
  <lookup:macro name="th" indent="yes"/>
  <lookup:macro name="thead" type="blockwrapper" indent="yes"/>
  <lookup:macro name="tbody" type="blockwrapper" indent="yes"/>
  <lookup:macro name="tfoot" type="blockwrapper" indent="yes"/>
</lookup:macros>

  <!-- Emoticons -->

  <xsl:template match="ac:emoticon">
    <xsl:choose>
      <xsl:when test="@ac:name='smile'">:)</xsl:when>
      <xsl:when test="@ac:name='sad'">:(</xsl:when>
      <xsl:when test="@ac:name='cheeky'">:P</xsl:when>
      <xsl:when test="@ac:name='laugh'">:D</xsl:when>
      <xsl:when test="@ac:name='wink'">;)</xsl:when>
      <xsl:when test="@ac:name='thumbs-up'">(y)</xsl:when>
      <xsl:when test="@ac:name='thumbs-down'">(n)</xsl:when>
      <xsl:when test="@ac:name='information'">(i)</xsl:when>
      <xsl:when test="@ac:name='tick'">(/)</xsl:when>
      <xsl:when test="@ac:name='cross'">(x)</xsl:when>
      <xsl:when test="@ac:name='warning'">(!)</xsl:when>
      <xsl:otherwise>(Emoticon: <xsl:value-of select="@ac:name"/>)</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Text -->

  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- Discard unwanted leading white space inside elements -->
  <xsl:template match="node()[(parent::acxhtml:p or parent::acxhtml:li or parent::acxhtml:td) and position() = 1 and self::text()]">
    <xsl:variable name="input" select="."/>
    <xsl:choose>
      <xsl:when test="normalize-space($input) = ' ' or normalize-space($input) = ''"/>
      <xsl:otherwise>
        <xsl:variable name="firstNonWhiteSpaceChar" select="substring(normalize-space($input), 1, 1)"/>
        <xsl:value-of select="concat($firstNonWhiteSpaceChar, substring-after($input, $firstNonWhiteSpaceChar))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Discard unwanted leading white space before block elements -->
  <xsl:template match="text()[preceding-sibling::acxhtml:p and normalize-space(.) = '']"/>
  <!-- Discard unwanted trailing space inside elements -->
  <xsl:template match="node()[(parent::acxhtml:p or parent::acxhtml:li or parent::acxhtml:td) and position() = last() and self::text()]">
    <xsl:variable name="input" select="."/>
    <xsl:variable name="firstChar" select="substring($input, 1, 1)"/>
    <!-- If the text node begins with whitespace, then reinstate a single leading space -->
    <xsl:if test="translate($firstChar, '&#xa; ', '') = ''">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  <!-- Discard unwanted newline before list element -->
  <xsl:template match="text()[following-sibling::acxhtml:ol or following-sibling::acxhtml:ul]">
    <xsl:variable name="input" select="."/>
    <xsl:variable name="firstChar" select="substring($input, 1, 1)"/>
    <!-- If the text node begins with whitespace, then reinstate a single leading space -->
    <xsl:if test="translate($firstChar, '&#xa; ', '') = ''">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- Page layout -->
  <xsl:template match="acxhtml:div">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="acxhtml:div[@class='innerCell'][preceding::acxhtml:div[@class='innerCell']]">
    <xsl:text>&#xa;----&#xa;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>