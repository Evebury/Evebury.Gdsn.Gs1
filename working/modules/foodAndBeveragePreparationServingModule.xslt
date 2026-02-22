<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:food_and_beverage_preparation_serving:xsd:3' and local-name()='foodAndBeveragePreparationServingModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>


		<xsl:apply-templates select="foodAndBeverageIngredient" mode="foodAndBeveragePreparationServingModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="preparationServing" mode="foodAndBeveragePreparationServingModule"/>

	</xsl:template>

	<xsl:template match="foodAndBeverageIngredient" mode="foodAndBeveragePreparationServingModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 586: If targetMarketCountryCode is equal to '840' (US) and growingMethodCode  is equal to 'ORGANIC' then organicClaimAgencyCode and organicTradeItemCode must not  be empty.-->
		<xsl:if test="$targetMarket = '840'">
			<xsl:if test="ingredientFarmingProcessing[growingMethodCode = 'ORGANIC']">
				<xsl:for-each select="ingredientOrganicInformation/organicClaim">
					<xsl:if test="organicClaimAgencyCode = '' or organicTradeItemCode = ''">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="586" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="preparationServing" mode="foodAndBeveragePreparationServingModule">
		<!--Rule 362: If a minimum and corresponding maximum are not empty then the minimum SHALL be less than or equal to the corresponding maximum.-->
		<xsl:if test="gs1:InvalidRange(minimumOptimumConsumptionTemperature,maximumOptimumConsumptionTemperature)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="362"/>
			</xsl:apply-templates>
		</xsl:if>		

	</xsl:template>

</xsl:stylesheet>