<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:onix_publication_file_information:xsd:3' and local-name()='oNIXPublicationFileInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select=".//referencedFileInformation" mode="oNIXPublicationFileInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="oNIXPublicationFileInformation" mode="oNIXPublicationFileInformationModule"/>

	</xsl:template>

	<xsl:template match="oNIXPublicationFileInformation" mode="oNIXPublicationFileInformationModule">

		<!--Rule 1217: There must be at most one iteration of publisherName -->
		<xsl:for-each select="oNIXPublisher">
			<xsl:variable name="publisher" select="."/>
			<xsl:for-each select="publisherName">
				<xsl:variable name="value" select="."/>
				<xsl:if test="count($publisher[publisherName = $value]) &gt; 1">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1217" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>


	</xsl:template>

	<xsl:template match="referencedFileInformation" mode="oNIXPublicationFileInformationModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 341: If a start dateTime and its corresponding end dateTime are not empty then the start date SHALL be less than or equal to corresponding end date. -->
		<xsl:if test="gs1:InvalidDateTimeSpan(fileEffectiveStartDateTime, fileEffectiveEndDateTime)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="341"/>
			</xsl:apply-templates>
		</xsl:if>
		<!--Rule 569: If targetMarketCountryCode does not equal ('756' (Switzerland), '276' (Germany), '040' (Austria), '528' (Netherlands), '056' (Belgium), '442' (Luxembourg), 203 (Czech Republic), or '250' (France)) and uniformResourceIdentifier is used and referencedFileTypeCode equals 'PRODUCT_IMAGE' then fileFormatName SHALL be used.-->
		<xsl:if test="not(contains('756, 276, 040, 528, 056, 442, 203, 250', $targetMarket))">
			<xsl:if test="uniformResourceIdentifier != '' and referencedFileTypeCode = 'PRODUCT_IMAGE'">
				<xsl:choose>
					<xsl:when test="fileFormatName != ''"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="569" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
		<!--Rule 570: If uniformResourceIdentifier is used and referencedFileTypeCode equals  'PRODUCT_IMAGE' and targetMarketCountryCode does not equal  756 (Switzerland), 276 (Germany), 040 (Austria), 528 (Netherlands) then fileName shall be used.-->
		<xsl:if test="not(contains('756, 276, 040, 528', $targetMarket))">
			<xsl:if test="uniformResourceIdentifier != '' and referencedFileTypeCode = 'PRODUCT_IMAGE'">
				<xsl:choose>
					<xsl:when test="fileName != ''"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="570" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>



</xsl:stylesheet>