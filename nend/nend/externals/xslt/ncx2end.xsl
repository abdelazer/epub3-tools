<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
                exclude-result-prefixes="ncx xsl"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:epub="http://www.idpf.org/2007/ops"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Text for the top-level `h1` inside the primary `nav` element -->
  <xsl:param name='contents-str'>Contents</xsl:param>

  <xsl:template match="ncx:ncx">
    <html profile="http://www.idpf.org/epub/30/profile/content/">
      <xsl:call-template name="html-head"/>
      <xsl:apply-templates/>
    </html>
  </xsl:template>

  <xsl:template match="ncx:navMap">
    <body>
      <nav epub:type="toc" id="toc">
        <h1><xsl:value-of select="$contents-str"/></h1>
        <ol>
          <xsl:apply-templates/>
        </ol>
      </nav>
    </body>
  </xsl:template>

  <xsl:template match="ncx:navPoint">
    <li>
      <xsl:copy-of select="@id"/>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="ncx:content[1]/@src"/>
        </xsl:attribute>
        <xsl:apply-templates select="ncx:navLabel"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="ncx:navLabel|
                       ncx:text">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Ignore these elements -->
  <xsl:template match="ncx:head|
                       ncx:docAuthor|
                       ncx:docTitle"/>
  <!-- Ignore this whitespace -->
  <xsl:template match="ncx:head/text()|
                       ncx:docAuthor/text()|
                       ncx:docTitle/text()|
                       ncx:navLabel/text()"/>

  <!-- Default rule to catch omissions -->
  <xsl:template match="*">
    <xsl:message terminate="yes">ERROR: <xsl:value-of select="name(.)"/> not matched!
    </xsl:message>
  </xsl:template>

  <xsl:template name="html-head">
    <head>
      <title><xsl:apply-templates select="/ncx:ncx/ncx:docTitle/ncx:text"/></title>
    </head>  
  </xsl:template>

</xsl:stylesheet>
