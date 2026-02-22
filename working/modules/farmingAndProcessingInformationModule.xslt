<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:farming_and_processing_information:xsd:3' and local-name()='farmingAndProcessingInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>


		<!--Rule 586: If targetMarketCountryCode is equal to '840' (US) and growingMethodCode  is equal to 'ORGANIC' then organicClaimAgencyCode and organicTradeItemCode must not  be empty.-->
		<xsl:if test="$targetMarket = '840'">
			<xsl:if test="tradeItemFarmingAndProcessing[growingMethodCode = 'ORGANIC']">
				<xsl:for-each select="tradeItemOrganicInformation/organicClaim">
					<xsl:if test="organicClaimAgencyCode = '' or organicTradeItemCode = ''">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="586" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
		
		<!--<xsl:apply-templates select="tradeItemOrganicInformation" mode="farmingAndProcessingInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>-->

	</xsl:template>

	<!--<xsl:template match="tradeItemOrganicInformation" mode="farmingAndProcessingInformationModule">
		<xsl:param name="targetMarket"/>
		
	
	</xsl:template>-->

</xsl:stylesheet>