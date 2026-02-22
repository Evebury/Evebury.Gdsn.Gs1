<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:sales_information:xsd:3' and local-name()='salesInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="tradeItemPriceInformation" mode="salesInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="tradeItemPriceInformation" mode="salesInformationModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 341: If a start dateTime and its corresponding end dateTime are not empty then the start date SHALL be less than or equal to corresponding end date. -->
		<xsl:for-each select="additionalTradeItemPrice">
			<xsl:if test="gs1:InvalidDateTimeSpan(priceEffectiveStartDate, priceEffectiveEndDate)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="341"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="cataloguePrice">
			<xsl:if test="gs1:InvalidDateTimeSpan(priceEffectiveStartDate, priceEffectiveEndDate)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="341"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="suggestedRetailPrice">
			<xsl:if test="gs1:InvalidDateTimeSpan(priceEffectiveStartDate, priceEffectiveEndDate)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="341"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

		<!--Rule 520: If  targetMarketCountryCode equals '752' (Sweden) and priceBasisQuantity is used then related measurementUnitCode shall equal 'KGM', 'GRM', 'MTR','MLT', 'MMT', 'LTR', 'MTK', 'MTQ' or 'H87'.-->
		<xsl:if test="$targetMarket = '752'">
			<xsl:apply-templates select="additionalTradeItemPrice/priceBasisQuantity" mode="r520"/>
			<xsl:apply-templates select="cataloguePrice/priceBasisQuantity" mode="r520"/>
			<xsl:apply-templates select="suggestedRetailPrice/priceBasisQuantity" mode="r520"/>
		</xsl:if>
	
	</xsl:template>

	<xsl:template match="priceBasisQuantity" mode="r520">
		<xsl:choose>
			<xsl:when test="@measurementUnitCode = 'KGM'"/>
			<xsl:when test="@measurementUnitCode = 'GRM'"/>
			<xsl:when test="@measurementUnitCode = 'MTR'"/>
			<xsl:when test="@measurementUnitCode = 'MLT'"/>
			<xsl:when test="@measurementUnitCode = 'MMT'"/>
			<xsl:when test="@measurementUnitCode = 'LTR'"/>
			<xsl:when test="@measurementUnitCode = 'MTK'"/>
			<xsl:when test="@measurementUnitCode = 'MTQ'"/>
			<xsl:when test="@measurementUnitCode = 'H87'"/>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="520" />
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>