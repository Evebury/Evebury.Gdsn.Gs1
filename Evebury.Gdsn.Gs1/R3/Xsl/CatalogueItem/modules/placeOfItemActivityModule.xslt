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
	</xsl:template>

</xsl:stylesheet>