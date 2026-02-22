<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:marketing_information:xsd:3' and local-name()='marketingInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="marketingInformation" mode="marketingInformationModule"/>

	</xsl:template>

	<xsl:template match="marketingInformation" mode="marketingInformationModule">
		<!--Rule 341: If a start dateTime and its corresponding end dateTime are not empty then the start date SHALL be less than or equal to corresponding end date. -->
		<xsl:for-each select="marketingCampaign">
			<xsl:if test="gs1:InvalidDateTimeSpan(campaignStartDateTime, campaignEndDateTime)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="341"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="season">
			<xsl:if test="gs1:InvalidDateTimeSpan(seasonalAvailabilityStartDateTime, seasonalAvailabilityEndDateTime)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="341"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>



</xsl:stylesheet>