<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:food_and_beverage_preparation_serving:xsd:3' and local-name()='foodAndBeveragePreparationServingModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="preparationServing" mode="foodAndBeveragePreparationServingModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>


	<xsl:template match="preparationServing" mode="foodAndBeveragePreparationServingModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 362: If a minimum and corresponding maximum are not empty then the minimum SHALL be less than or equal to the corresponding maximum.-->
		<xsl:if test="gs1:InvalidRange(minimumOptimumConsumptionTemperature,maximumOptimumConsumptionTemperature)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="362"/>
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 1090: If targetMarketCountryCode does not equal <Geographic> and ProductYieldInformation/productYield is used then PreparationServing/preparationTypeCode SHALL be used.-->
		<xsl:if test="$targetMarket = '246'">
			<xsl:if test="productYieldInformation[productYield != ''] and preparationTypeCode = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1090" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

	
		<xsl:for-each select="productYieldInformation">
			<!--Rule 1091: If ProductYieldInformation/productYield is not empty then ProductYieldInformation/productYieldTypeCode must not be empty.-->
			<xsl:if test="productYield != '' and productYieldTypeCode = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1091" />
				</xsl:apply-templates>
			</xsl:if>
			<!--Rule 1410: If productYieldTypeCode  is used then productYield shall be used.-->
			<xsl:if test="productYield = '' and productYieldTypeCode != ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1410" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

	

	</xsl:template>

</xsl:stylesheet>