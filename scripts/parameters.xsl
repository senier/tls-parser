<?xml version="1.0"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:iana="http://www.iana.org/assignments"
>

<xsl:output method="text" />

<xsl:template match="/">
    <xsl:text>with Ada.Streams;</xsl:text>
    <xsl:text>package TLS.Parameters is</xsl:text>
    <xsl:apply-templates select="iana:registry"/>
    <xsl:text>end TLS.Parameters;</xsl:text>
</xsl:template>

<xsl:template match="iana:registry[@id='tls-parameters']">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="iana:registry[@id='tls-parameters-4']">
    <xsl:text>   --  </xsl:text>
    <xsl:value-of select="iana:title"/>
    <xsl:text></xsl:text>
    <xsl:text>   type CipherSuite is (</xsl:text>
    <xsl:apply-templates select="iana:record[iana:description[substring(text(), 1, 4)='TLS_']]" mode="declaration"/>
    <xsl:text>       INVALID);</xsl:text>
    <xsl:text></xsl:text>
    <xsl:text>   for CipherSuite use (</xsl:text>
    <xsl:apply-templates select="iana:record[iana:description[substring(text(), 1, 4)='TLS_']]" mode="representation"/>
    <xsl:text>       INVALID => 16#FFFF#);</xsl:text>
    <xsl:text>   for CipherSuite'Size use 16;</xsl:text>
    <xsl:text>   procedure Read_CipherSuite</xsl:text>
    <xsl:text>       (Stream : not null access Ada.Streams.Root_Stream_Type'Class;</xsl:text>
    <xsl:text>        Item   : out CipherSuite);</xsl:text>
    <xsl:text>   for CipherSuite'Read use Read_CipherSuite;</xsl:text>
    <xsl:text></xsl:text>
</xsl:template>

<xsl:template match="iana:record" mode="declaration">
    <xsl:text>       </xsl:text>
    <xsl:value-of select="iana:description"/>
    <xsl:text>,</xsl:text>
</xsl:template>

<xsl:template match="iana:record" mode="representation">
    <xsl:text>       </xsl:text>
    <xsl:value-of select="iana:description"/>
    <xsl:text> => 16#</xsl:text>
    <xsl:value-of select="substring(iana:value, 3, 2)"/>
    <xsl:value-of select="substring(iana:value, 8, 2)"/>
    <xsl:text>#,</xsl:text>
</xsl:template>

<xsl:template match="node()|@*">
<!--
    <xsl:apply-templates select="node()|@*"/>
-->
</xsl:template>

</xsl:stylesheet> 
