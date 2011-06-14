<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="ncx:ncx">
    <html profile="http://www.idpf.org/epub/30/profile/content/">
      <xsl:call-template name="html-head"/>
      <xsl:apply-templates/>
    </html>
  </xsl:template>

  <xsl:template match="ncx:docTitle">
    <title><xsl:value-of select="ncx:text"/></title>
  </xsl:template>

  <!-- Ignore these elements -->
  <xsl:template match="ncx:head"/>

  <!-- Default rule to catch omissions -->
  <xsl:template match="*">
    <xsl:message terminate="yes">ERROR: <xsl:value-of select="name(.)"/> not matched!
    </xsl:message>
  </xsl:template>

  <xsl:template name="html-head">
    <head>
      <xsl:apply-templates select="/ncx:ncx/ncx:docTitle"/>
    </head>  
  </xsl:template>

</xsl:stylesheet>
