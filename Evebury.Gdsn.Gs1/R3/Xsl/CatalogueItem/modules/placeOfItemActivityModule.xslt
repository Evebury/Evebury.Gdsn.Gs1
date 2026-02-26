<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:place_of_item_activity:xsd:3' and local-name()='placeOfItemActivityModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="importClassification" mode="placeOfItemActivityModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="placeOfProductActivity" mode="placeOfItemActivityModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="importClassification" mode="placeOfItemActivityModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 583: If importClassificationTypeCode is not empty then importClassificationValue must not be empty.-->
		<xsl:if test="importClassificationTypeCode != '' and importClassificationValue = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="583" />
			</xsl:apply-templates>
		</xsl:if>
		<!--Rule 584: If importClassificationValue  is not empty then  importClassificationTypeCode must not be empty.-->
		<xsl:if test="importClassificationValue != '' and importClassificationTypeCode = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="584" />
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 1693: If targetMarketCountryCode equals <Geographic> and importClassificationTypeCode equals 'INTRASTAT' then corresponding importClassificationValue SHALL have exactly 8 digits.-->
		<xsl:if test="importClassificationTypeCode  = 'INTRASTAT'">
			<xsl:if test="contains('056, 528, 442, 756, 380, 752', $targetMarket)">
				<xsl:if test="importClassificationValue != number(importClassificationValue) or string-length(importClassificationValue) != 8">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1693" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="placeOfProductActivity" mode="placeOfItemActivityModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>
		<xsl:apply-templates select="productActivityDetails" mode="placeOfItemActivityModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>
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

	<xsl:template match="productActivityDetails" mode="placeOfItemActivityModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<!--Rule 1702: If <Geographic> and If catchAreaCode is used and PlaceOfItemActivityModule/../productActivityTypeCode equals 'CATCH_ZONE', then catchAreaCode shall equal PlaceOfItemActivityModule/../productActivityRegionZoneCodeReference/enumerationValueInformation/enumerationValue-->
		<xsl:if test="productActivityTypeCode  = 'CATCH_ZONE'">
			<xsl:if test="contains('008, 051, 031, 040, 112, 056, 070, 100, 191, 196, 203, 208, 233, 246, 250, 276, 268, 300, 348, 352, 372, 376, 380, 398, 417, 428, 440, 442, 807, 498, 499, 528, 578, 616, 620, 642, 643, 688, 703, 705, 756, 792, 795, 826, 804, 860', $targetMarket)">
				<xsl:variable name="module" select="$tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:dairy_fish_meat_poultry:xsd:3' and local-name()='dairyFishMeatPoultryItemModule']/dairyFishMeatPoultryInformation/fishReportingInformation"/>
				<xsl:for-each select="productActivityRegionZoneCodeReference/enumerationValueInformation/enumerationValue">
					<xsl:variable name="value" select="."/>
					<xsl:choose>
						<xsl:when test="$module/fishCatchInformation[catchAreaCode = $value]"/>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="1702" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>

		<!--Rule 1719: If targetMarketCountryCode equals <Geographic> and placeOfItemActivityModule/../productActivityTypeCode equals 'CATCH_ZONE' then placeOfItemActivityModule/../productActivityRegionZoneCodeReference/enumerationValueInformation/enumerationValue SHALL NOT be in ('27', '37').-->
		<xsl:if test="productActivityTypeCode  = 'CATCH_ZONE'">
			<xsl:if test="$targetMarket = '276'">
				<xsl:if test="productActivityRegionZoneCodeReference/enumerationValueInformation[enumerationValue = '27' or enumerationValue = '37']">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1719" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		
	</xsl:template>

</xsl:stylesheet>