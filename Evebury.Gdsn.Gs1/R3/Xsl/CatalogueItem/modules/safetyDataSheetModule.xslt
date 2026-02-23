<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:safety_data_sheet:xsd:3' and local-name()='safetyDataSheetModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="safetyDataSheetInformation" mode="safetyDataSheetModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="safetyDataSheetInformation" mode="safetyDataSheetModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 362: If a minimum and corresponding maximum are not empty then the minimum SHALL be less than or equal to the corresponding maximum.-->
		<xsl:for-each select="chemicalInformation/chemicalIngredient">
			<xsl:if test="gs1:InvalidRange(chemicalIngredientConcentrationLowerValue,chemicalIngredientConcentrationUpperValue)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="362"/>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="gs1:InvalidRange(lowerExplosiveLimit,upperExplosiveLimit)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="362"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="specificGravityInformation">
			<xsl:if test="gs1:InvalidRange(specificGravityLowerValue,specificGravityUpperValue)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="362"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:apply-templates select="physicalChemicalPropertyInformation" mode="safetyDataSheetModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="referencedFileInformation" mode="safetyDataSheetModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		
	</xsl:template>

	<xsl:template match="referencedFileInformation" mode="safetyDataSheetModule">
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

	<xsl:template match="physicalChemicalPropertyInformation" mode="safetyDataSheetModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 362: If a minimum and corresponding maximum are not empty then the minimum SHALL be less than or equal to the corresponding maximum.-->
		<xsl:if test="gs1:InvalidRange(lowerExplosiveLimit,upperExplosiveLimit)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="362"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:for-each select="flashPoint">
			<xsl:if test="gs1:InvalidRange(flashPointTemperatureLowerValue,flashPointTemperatureUpperValue)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="362"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="pHInformation">
			<xsl:if test="gs1:InvalidRange(minimumPH,maximumPH)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="362"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

		<!--Rule 477: If targetMarketCountryCode equals <Geographic> and (maximumTemperature, minimumTemperature, flashPoint/flashPointTemperature or hazardousInformationHeader/flashPointTemperature are used) then at least one iteration of the associated measurementUnitCode SHALL equal 'CEL'.-->
		<xsl:if test="contains('752, 203, 250, 208, 246, 040, 703, 756', $targetMarket)">
			<xsl:if test="flashPoint/flashPointTemperature">
				<xsl:choose>
					<xsl:when test="flashPoint/flashPointTemperature[@temperatureMeasurementUnitCode = 'CEL']"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="477"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>