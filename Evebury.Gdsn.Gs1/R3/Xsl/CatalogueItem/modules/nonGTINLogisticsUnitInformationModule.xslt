<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:nongtin_logistics_unit_information:xsd:3' and local-name()='nonGTINLogisticsUnitInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="nonGTINLogisticsUnitInformation" mode="nonGTINLogisticsUnitInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="nonGTINLogisticsUnitInformation" mode="nonGTINLogisticsUnitInformationModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>
		<!--Rule 480: If targetMarketCountryCode equals <Geographic> then logisticsUnitStackingFactor SHALL be less than 100.-->
		<xsl:if test="contains('056, 442, 528', $targetMarket)">
			<xsl:if test="logisticsUnitStackingFactor != '' and logisticsUnitStackingFactor &gt; 100">
				<xsl:apply-templates select="logisticsUnitStackingFactor" mode="error">
					<xsl:with-param name="id" select="480"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
		<!--Rule 1651: If targetMarketCountryCode equals <Geographic> and tradeItemUnitDescriptorCode equals 'PALLET', then no attributes in class nonGTINLogisticsUnitInformation SHALL be used.-->
		<xsl:if test="contains('276, 528, 208, 203, 246, 056, 442, 250, 040, 380', $targetMarket)">
			<xsl:if test="$tradeItem/tradeItemUnitDescriptorCode  = 'PALLET'">
				<xsl:if test="grossWeight != '' or height != '' or depth != '' or width != '' or logisticsUnitStackingFactor != ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1651" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>