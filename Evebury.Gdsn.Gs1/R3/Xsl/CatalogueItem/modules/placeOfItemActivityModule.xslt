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

		<xsl:apply-templates select="placeOfProductActivity" mode="placeOfItemActivityModule"/>

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