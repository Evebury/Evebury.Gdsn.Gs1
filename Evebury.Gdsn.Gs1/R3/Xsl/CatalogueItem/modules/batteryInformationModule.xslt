<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:battery_information:xsd:3' and local-name()='batteryInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="batteryDetail/batteryMaterials" mode="batteryInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="batteryMaterials" mode="batteryInformationModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 1553: (if TradeItemMaterial/materialAgencyCode is used then TradeItemMaterial/TradeItemMaterialComposition/materialCode shall be used) and (if TradeItemMaterial/TradeItemMaterialComposition/materialCode is used then TradeItemMaterial/materialAgencyCode shall be used).-->
		<xsl:if test="(materialAgencyCode != '' and materialCode = '') or (materialAgencyCode = '' and materialCode != '')">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1553" />
			</xsl:apply-templates>
		</xsl:if>
		<!--Rule 1554: If TradeItemMaterial/materialAgencyCode and TradeItemMaterial/TradeItemMaterialComposition/materialCode are used and targetMarketCountryCode does NOT equal (056 (Belgium), 442 (Luxembourg), 528 (Netherlands)) then TradeItemMaterial/TradeItemMaterialComposition/materialPercentage shall be used.-->
		<xsl:choose>
			<xsl:when test="$targetMarket = '056' or $targetMarket = '442' or $targetMarket = '528'"/>
			<xsl:otherwise>
				<xsl:if test="materialAgencyCode != '' and tradeItemMaterialComposition/materialCode !=''">
					<xsl:if test="tradeItemMaterialComposition/materialPercentage = ''">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1554" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>