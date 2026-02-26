<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="tradeItemDescriptionInformation" mode="tradeItemDescriptionModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="tradeItemDescriptionInformation" mode="tradeItemDescriptionModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>
		
		<!--Rule 464: If TargetMarket/targetMarketCountryCode is equal to ('036' (Australia) or '554' (New Zealand)) then the codeDescription of tradeItemGroupIdentificationCodeReference must be equal for all Items with the the same tradeItemGroupIdentificationCodeReference.-->
		<xsl:if test="contains('036, 554', $targetMarket)">
			<xsl:for-each select="tradeItemGroupIdentificationCodeReference">
				<xsl:variable name="code" select="@codeDescription"/>
				<xsl:variable name="description" select="."/>
				<xsl:if test="tradeItemGroupIdentificationCodeReference[@codeDescription = $code and text() != $description]">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="464"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>

		<!--Rule 566: If targetMarketCountryCode is equal to '752' (Sweden) and functionalName is not empty then exactly one iteration of functionalName must have a languageCode equal to 'sv'.-->
		<xsl:if test="$targetMarket = '752'">
			<xsl:choose>
				<xsl:when test="functionalName[text() != '' and @languageCode = 'sv']"/>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="566" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<!--Rule 1063: brandName must not be empty.-->
		<xsl:if test="brandNameInformation/brandName = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1063" />
			</xsl:apply-templates>
		</xsl:if>
		<!--Rule 1065: functionalName SHALL be used.-->
		<xsl:if test="functionalName = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1065" />
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 1232: There must be at most one iteration of tradeItemGroupIdentificationCodeReference-->
		<xsl:variable name="info" select="."/>
		<xsl:for-each select="tradeItemGroupIdentificationCodeReference">
			<xsl:variable name="value" select="."/>
			<xsl:if test="count($info[tradeItemGroupIdentificationCodeReference = $value]) &gt; 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1232" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>


		<!--Rule 1762: If targetMarketCountryCode equals '528' (the Netherlands) and regulatedProductName is used and gpcCategoryCode equals '10005786, then there SHALL be at least one instance of provenanceStatement with languageCode equal to 'nl'.-->
		<xsl:if test="$targetMarket = '528'">
			<xsl:if test="regulatedProductName != ''">
				<xsl:variable name="brick" select="$tradeItem/gDSNTradeItemClassification/gpcCategoryCode"/>
				<xsl:if test="$brick = '10005786'">
					<xsl:choose>
						<xsl:when test="$tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:food_and_beverage_ingredient:xsd:3' and local-name()='foodAndBeverageIngredientModule']/foodAndBeverageIngredient/ingredientPlaceOfActivity/provenanceStatement[@languageCode = 'nl']"/>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="1762" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:place_of_item_activity:xsd:3' and local-name()='placeOfItemActivityModule']/placeOfProductActivity/provenanceStatement[@languageCode = 'nl']"/>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="1762" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	
	</xsl:template>

</xsl:stylesheet>