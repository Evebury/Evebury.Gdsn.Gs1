<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:dairy_fish_meat_poultry:xsd:3' and local-name()='dairyFishMeatPoultryItemModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="dairyFishMeatPoultryInformation/cheeseInformation" mode="dairyFishMeatPoultryItemModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="cheeseInformation" mode="dairyFishMeatPoultryItemModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 1034: If fatPercentageInDryMatter is not empty then value must be greater than or equal to 0 and less than or equal to 100.00.-->
		<xsl:if test="fatPercentageInDryMatter != '' and (fatPercentageInDryMatter &lt; 0 or fatPercentageInDryMatter &gt; 100)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1034" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>