<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:product_information:xsd:3' and local-name()='productInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="productInformationDetail/claimDetail" mode="productInformationModule"/>

	</xsl:template>

	<xsl:template match="claimDetail" mode="productInformationModule">
		<!--Rule 1236: If claimElementCode is used then claimTypeCode SHALL be used.-->
		<xsl:if test="claimElementCode != '' and claimTypeCode = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1236" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>