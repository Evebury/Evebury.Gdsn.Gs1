<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:nonfood_ingredient:xsd:3' and local-name()='nonfoodIngredientModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="nonfoodIngredient" mode="nonfoodIngredientModule"/>

	</xsl:template>

	<xsl:template match="nonfoodIngredient" mode="nonfoodIngredientModule">
		<!--Rule 1305: If isIngredientGeneric is not empty, then ingredientStength must not be empty.-->
		<xsl:if test="isIngredientGeneric != '' and ingredientStrength[ingredientStrength = '']">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1305" />
			</xsl:apply-templates>
		</xsl:if>
		
	</xsl:template>

</xsl:stylesheet>