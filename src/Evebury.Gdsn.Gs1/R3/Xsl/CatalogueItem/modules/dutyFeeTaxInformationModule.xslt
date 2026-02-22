<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:duty_fee_tax_information:xsd:3' and local-name()='dutyFeeTaxInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="dutyFeeTaxInformation" mode="dutyFeeTaxInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="dutyFeeTaxInformation" mode="dutyFeeTaxInformationModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 341: If a start dateTime and its corresponding end dateTime are not empty then the start date SHALL be less than or equal to corresponding end date. -->
		<xsl:if test="gs1:InvalidDateTimeSpan(dutyFeeTaxEffectiveStartDateTime, dutyFeeTaxEffectiveEndDateTime)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="341"/>
			</xsl:apply-templates>
		</xsl:if>
		<!--Rule 571: If targetMarketCountryCode is equal to '752' (Sweden) and dutyFeeTaxAgencyCode is not empty then dutyFeeTaxAgencyCode must equal '9SE'.-->
		<xsl:if test="$targetMarket = '752'">
			<xsl:if test="dutyFeeTaxAgencyCode != '' and dutyFeeTaxAgencyCode != '9SE'">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="571" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
		
	</xsl:template>



</xsl:stylesheet>