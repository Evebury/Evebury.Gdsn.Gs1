<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:packaging_marking:xsd:3' and local-name()='packagingMarkingModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="packagingMarking" mode="packagingMarkingModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="packagingMarking" mode="packagingMarkingModule">
		<xsl:param name="targetMarket"/>
		<xsl:apply-templates select="consumerWarningInformation" mode="packagingMarkingModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<!--Rule 1231: There must be at most one iteration of tradeItemDateOnPackagingFormatName  -->
		<xsl:for-each select="packagingDate">
			<xsl:variable name="date" select="."/>
			<xsl:for-each select="tradeItemDateOnPackagingFormatName">
				<xsl:variable name="value" select="."/>
				<xsl:if test="count($date[tradeItemDateOnPackagingFormatName = $value]) &gt; 1">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1231" />
					</xsl:apply-templates>
				</xsl:if>			
			</xsl:for-each>
		</xsl:for-each>

		<!--Rule 1660: If multiple iterations of packagingMarkedLabelAccreditationCode are used, then no two iterations SHALL be equal.-->
		<xsl:variable name="parent" select="."/>
		<xsl:for-each select="packagingMarkedLabelAccreditationCode">
			<xsl:variable name="value" select="."/>
			<xsl:if test="count($parent[packagingMarkedLabelAccreditationCode = $value]) &gt; 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1660" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="consumerWarningInformation" mode="packagingMarkingModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 1541: If targetMarketCountryCode equals ('249' (France) or '250' (France) and consumerWarningDescription is used, then consumerWarningTypeCode shall be used.-->
		<xsl:if test="$targetMarket = '249' or $targetMarket = '250'">
			<xsl:if test="consumerWarningDescription != '' and consumerWarningTypeCode = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1541" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>