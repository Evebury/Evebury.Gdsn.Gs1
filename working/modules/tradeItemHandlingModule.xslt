<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:trade_item_handling:xsd:3' and local-name()='tradeItemHandlingModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="tradeItemHandlingInformation" mode="tradeItemHandlingModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="tradeItemHandlingInformation" mode="tradeItemHandlingModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 479: If targetMarketCountryCode equals <Geographic> then stackingFactor SHALL be less than 100.-->
		<xsl:if test="contains('056, 442, 528', $targetMarket)">
			<xsl:if test="tradeItemStacking/stackingFactor != '' and tradeItemStacking/stackingFactor &gt; 100">
				<xsl:apply-templates select="tradeItemStacking/stackingFactor" mode="error">
					<xsl:with-param name="id" select="479"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>