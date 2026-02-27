<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:health_related_information:xsd:3' and local-name()='healthRelatedInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="healthRelatedInformation" mode="healthRelatedInformationModule"/>

	</xsl:template>

	<xsl:template match="healthRelatedInformation" mode="healthRelatedInformationModule">
		<xsl:apply-templates select="nutritionalProgram" mode="healthRelatedInformationModule"/>
		
	</xsl:template>

	<xsl:template match="nutritionalProgram" mode="healthRelatedInformationModule">
		<xsl:apply-templates select="nutritionalProgramIngredients" mode="healthRelatedInformationModule"/>

		<!--Rule 1698: If nutritionalProgramCode equals '8' (Nutri-Score) and nutritionalProgramStatusCode does not equal 'NOT_REGISTERED' then nutritionalScore SHALL be used and nutritionalScore SHALL equal ('A', 'B', 'C', 'D', 'E' or 'EXEMPT').-->
		<xsl:if test="nutritionalProgramCode  = '8' and nutritionalProgramStatusCode != 'NOT_REGISTERED'">
			<xsl:choose>
				<xsl:when test="nutritionalScore  = 'A'"/>
				<xsl:when test="nutritionalScore  = 'B'"/>
				<xsl:when test="nutritionalScore  = 'C'"/>
				<xsl:when test="nutritionalScore  = 'D'"/>
				<xsl:when test="nutritionalScore  = 'E'"/>
				<xsl:when test="nutritionalScore  = 'EXEMPT'"/>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1698" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
		
		<!--Rule 1799: If nutritionalProgramCode equals '8' (Nutri-Score) and nutritionalProgramStatusCode equals ‘NOT_REGISTERED’ then nutritionalScore SHALL NOT be used.-->
		<xsl:if test="nutritionalProgramCode  = '8' and nutritionalProgramStatusCode = 'NOT_REGISTERED'">
			<xsl:if test="nutritionalScore != ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1799" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

	</xsl:template>

	<xsl:template match="nutritionalProgramIngredients" mode="healthRelatedInformationModule">
		<!--Rule 1699: nutritionalProgramIngredientMeasurement shall only be used if  nutritionalProgramIngredientTypeCode is used.-->
		<xsl:if test="nutritionalProgramIngredientTypeCode  = '' and nutritionalProgramIngredientMeasurement != ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1699" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>