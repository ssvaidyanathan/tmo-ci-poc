<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="no" method="xml"/>
    <xsl:key name="planmap" match="/cart/cartItem[./productOffering/productType='Plan']/networkResource" use="../rootParentCartItemId"/>
    
    <xsl:template match="/cart/cartItem[./productOffering/productType='Device']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:variable name="itemId" select="./rootParentCartItemId"/>
            <xsl:variable name="networkResource" select="key('planmap', $itemId)"/>
            <xsl:copy-of select="./*[not(local-name() = 'networkResource')]"/>
            <xsl:choose>
                <xsl:when test="./productOffering/productSubType='SimCard' and (../orderType = 'ACTIVATION' or ../orderType = 'ADDALINE')">
                    <xsl:apply-templates select="networkResource[not(sim)]"/>
                    <xsl:choose>
                        <xsl:when test="./networkResource[sim]">
                            <xsl:element name="networkResource">
                                <xsl:if test="$networkResource/@actionCode">
                                    <xsl:copy-of select="$networkResource/@actionCode"/>
                                </xsl:if>
                                <xsl:element name="sim">
                                    <xsl:copy-of select="./networkResource/sim/*[not(local-name() = 'simNumber')]"/>
                                    <xsl:choose>
                                        <xsl:when test="$networkResource/sim/simNumber">
                                            <xsl:copy-of select="$networkResource/sim/simNumber"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:copy-of select="./networkResource/sim/simNumber"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$networkResource[sim]">
                            <xsl:element name="networkResource">
                                <xsl:if test="$networkResource/@actionCode">
                                    <xsl:copy-of select="$networkResource/@actionCode"/>
                                </xsl:if>
                                <xsl:element name="sim">
                                    <xsl:copy-of select="$networkResource/sim/simNumber"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="networkResource[sim]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="networkResource"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:choose>
            <xsl:when test=". instance of element()">
                <xsl:if test="current() != '' or count(//@*) > 0">
                    <xsl:element name="{local-name()}">
                        <xsl:apply-templates select="@* | node()"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>