<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:food_and_beverage_ingredient:xsd:3' and local-name()='foodAndBeverageIngredientModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="foodAndBeverageIngredient" mode="foodAndBeverageIngredientModule" >
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="foodAndBeverageIngredient" mode="foodAndBeverageIngredientModule">
		<xsl:param name="targetMarket"/>
		<xsl:apply-templates select="ingredientPlaceOfActivity" mode="foodAndBeverageIngredientModule"/>
		<!--Rule 1177:If targetMarketCountryCode does not equal <Geographic> and there is more than one iteration of ingredientSequence, then ingredientSequence and ingredientName must not be empty.-->
		<xsl:if test="$targetMarket != '562'">
			<xsl:if test="ingredientSequence = '' or ingredientName = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1177" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<!--Rule 1275: If targetMarketCountryCode does not equal <Geographic> and any attribute of the FoodAndBeverageIngredient class is used, then either ingredientName or grapeVarietycode, or both shall be used.-->
		<xsl:choose>
			<xsl:when test="contains('056, 203, 442, 528', $targetMarket)"/>
			<xsl:otherwise>
				<xsl:if test="ingredientName = '' and  grapeVarietycode = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1275" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>

		<!--Rule 1281: The format of ingredientSequence shall be 'dd.dd.dd…'. Where 'd' shall be a digit, always ending in a 'dd' and never having a value of '00'.-->
		<xsl:if test="gs1:InvalidSequence(ingredientSequence)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1281" />
			</xsl:apply-templates>
		</xsl:if>
		
	</xsl:template>

	<xsl:template match="ingredientPlaceOfActivity" mode="foodAndBeverageIngredientModule">
		<!--Rule 1656: If the class CountryOfOrigin or MaterialCountryOfOrigin is repeated, then no two iterations of countryCode in  this class SHALL be equal.-->
		<xsl:variable name="parent" select="."/>
		<xsl:for-each select="countryOfOrigin/countryCode">
			<xsl:variable name="value" select="."/>
			<xsl:if test="count($parent/countryOfOrigin[countryCode = $value]) &gt; 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1656" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>