<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:dangerous_substance_information:xsd:3' and local-name()='dangerousSubstanceInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="dangerousSubstanceInformation/dangerousSubstanceProperties" mode="dangerousSubstanceInformationModule"/>

	</xsl:template>

	<xsl:template match="dangerousSubstanceProperties" mode="dangerousSubstanceInformationModule">
		<!--Rule 362: If a minimum and corresponding maximum are not empty then the minimum SHALL be less than or equal to the corresponding maximum.-->
		<xsl:if test="gs1:InvalidRange(flammableSubstanceMinimumPercent,flammableSubstanceMaximumPercent)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="362"/>
			</xsl:apply-templates>
		</xsl:if>
		
		

	</xsl:template>

</xsl:stylesheet>