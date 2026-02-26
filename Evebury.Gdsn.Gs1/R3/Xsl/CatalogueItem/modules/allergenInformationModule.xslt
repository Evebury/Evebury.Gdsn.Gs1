<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:allergen_information:xsd:3' and local-name()='allergenInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="allergenRelatedInformation" mode="allergenInformationModule"/>

	</xsl:template>

	<xsl:template match="allergenRelatedInformation" mode="allergenInformationModule">
		<!--Rule 1658: If multiple iterations of allergenTypeCode are used, then no two iterations SHALL be equal within the same class allergenRelatedInformation.-->
		<xsl:variable name="parent" select="."/>
		<xsl:for-each select="allergen/allergenTypeCode">
			<xsl:variable name="value" select="."/>
			<xsl:if test="count($parent/allergen[allergenTypeCode = $value]) &gt; 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1658" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		
		
	</xsl:template>

</xsl:stylesheet>