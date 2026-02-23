<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:promotional_item_information:xsd:3' and local-name()='promotionalItemInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="promotionalItemInformation" mode="promotionalItemInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="promotionalItemInformation" mode="promotionalItemInformationModule">
		<xsl:param name="targetMarket"/>
		<xsl:for-each select="nonPromotionalTradeItem/additionalTradeItemIdentification">
			<xsl:choose>
				<xsl:when test="@additionalTradeItemIdentificationTypeCode = 'GTIN_13'">
					<xsl:if test="gs1:InvalidGTIN(.,13)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1039" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
				<xsl:when test="@additionalTradeItemIdentificationTypeCode = 'GTIN_8'">
					<xsl:if test="gs1:InvalidGTIN(.,8)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1040" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
				<xsl:when test="@additionalTradeItemIdentificationTypeCode = 'GTIN_14'">
					<xsl:if test="gs1:InvalidGTIN(.,14)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1041" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
				<xsl:when test="@additionalTradeItemIdentificationTypeCode = 'GTIN_12'">
					<xsl:if test="gs1:InvalidGTIN(.,12)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1042" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>