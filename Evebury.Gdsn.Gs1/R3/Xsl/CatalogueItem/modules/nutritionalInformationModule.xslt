<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:nutritional_information:xsd:3' and local-name()='nutritionalInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="nutrientHeader" mode="nutritionalInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="nutrientHeader" mode="nutritionalInformationModule">
		<xsl:param name="targetMarket"/>
		<xsl:apply-templates select="nutrientDetail" mode="nutritionalInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<!--Rule 1440: If targetMarketCountryCode equals <Geographic> and preparationStateCode is used then at least 1 iteration of nutrientTypeCode SHALL be used.-->
		<xsl:if test="contains('752, 246, 756', $targetMarket)">
			<xsl:if test="preparationStateCode != ''">
				<xsl:if test="count(nutrientDetail[nutrientTypeCode != '']) = 0">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1440" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		
		
	</xsl:template>

	<xsl:template match="nutrientDetail" mode="nutritionalInformationModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 1445: If nutrientTypeCode is used and measurementPrecisionCode does not equal ('ABSENCE', 'NOT_DETECTED', 'NOT_SIGNIFICANT_SOURCE_OF', 'TRACE', 'UNDETECTABLE') then at least quantityContained or dailyValueIntakePercent SHALL be used.-->
		<xsl:if test="nutrientTypeCode != ''">
			<xsl:choose>
				<xsl:when test="measurementPrecisionCode = 'ABSENCE'"/>
				<xsl:when test="measurementPrecisionCode = 'NOT_DETECTED'"/>
				<xsl:when test="measurementPrecisionCode = 'NOT_SIGNIFICANT_SOURCE_OF'"/>
				<xsl:when test="measurementPrecisionCode = 'TRACE'"/>
				<xsl:when test="measurementPrecisionCode = 'UNDETECTABLE'"/>
				<xsl:otherwise>
					<xsl:if test="quantityContained = '' and dailyValueIntakePercent = ''">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1445" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>