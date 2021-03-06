<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:v1="http://services.tmobile.com/OrderManagement/CartWSIL/V1"
    xmlns:base="http://services.tmobile.com/base"
    exclude-result-prefixes="v1 base">
    
    <xsl:output method="xml" encoding="ISO-8859-1" version="1.0"/>
    
    <xsl:template match="v1:*|base:*">
        <xsl:element name="{local-name()}" >
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>