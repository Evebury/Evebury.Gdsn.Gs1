<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:nutritional_information:xsd:3' and local-name()='nutritionalInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="nutrientHeader" mode="nutritionalInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="nutrientHeader" mode="nutritionalInformationModule">
		<xsl:param name="targetMarket"/>
		<xsl:apply-templates select="nutrientDetail" mode="nutritionalInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<!--Rule 1440: If targetMarketCountryCode equals <Geographic> and preparationStateCode is used then at least 1 iteration of nutrientTypeCode SHALL be used.-->
		<xsl:if test="contains('752, 246, 756', $targetMarket)">
			<xsl:if test="preparationStateCode != ''">
				<xsl:if test="count(nutrientDetail[nutrientTypeCode != '']) = 0">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1440" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>


		<xsl:if test="contains('056, 442, 528, 276, 208, 203, 826, 040, 756, 246, 380, 250', $targetMarket)">
			<xsl:variable name="starch" select="nutrientDetail[nutrientTypeCode = 'STARCH']"/>
			<xsl:variable name="choavl" select="nutrientDetail[nutrientTypeCode = 'CHOAVL']"/>
			<xsl:variable name="polyl" select="nutrientDetail[nutrientTypeCode = 'POLYL']"/>
			<xsl:variable name="fasat" select="nutrientDetail[nutrientTypeCode = 'FASAT']"/>
			<xsl:variable name="fat" select="nutrientDetail[nutrientTypeCode = 'FAT']"/>
			<xsl:variable name="famcis" select="nutrientDetail[nutrientTypeCode = 'FAMSCIS']"/>
			<xsl:variable name="fapucis" select="nutrientDetail[nutrientTypeCode = 'FAPUCIS']"/>
			<xsl:variable name="sugarmin" select="nutrientDetail[nutrientTypeCode = 'SUGAR-']"/>
			
			<!--Rule 1641: If targetMarketCountryCode equals <Geographic> for the same nutrientBasisQuantity or servingSize and one instance of nutrientTypeCode equals 'STARCH' and quantityContained is used and another instance of nutrientTypeCode equals 'CHOAVL' and quantityContained is used then quantityContained for nutrientTypeCode 'STARCH' SHALL be less than or equal to quantityContained for nutrientTypeCode 'CHOAVL'.-->
			<xsl:if test="$starch and $starch/quantityContained != ''">
				<xsl:if test="$choavl and $choavl/quantityContained != ''">
					<xsl:variable name="v1">
						<xsl:apply-templates select="$starch/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:variable name="v2">
						<xsl:apply-templates select="$choavl/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:if test="$v1 &gt; $v2">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1641" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<!--Rule 1642: If targetMarketCountryCode equals <Geographic> for the same nutrientBasisQuantity or servingSize and one instance of nutrientTypeCode equals 'POLYL' and quantityContained is used and another instance of nutrientTypeCode equals 'CHOAVL' and quantityContained is used then quantityContained for nutrientTypeCode 'POLYL' SHALL be less than or equal to quantityContained for nutrientTypeCode 'CHOAVL'..-->
			<xsl:if test="$polyl and $polyl/quantityContained != ''">
				<xsl:if test="$choavl and $choavl/quantityContained != ''">
					<xsl:variable name="v1">
						<xsl:apply-templates select="$polyl/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:variable name="v2">
						<xsl:apply-templates select="$choavl/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:if test="$v1 &gt; $v2">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1641" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<!--Rule 1643: If targetMarketCountryCode equals <Geographic> for the same nutrientBasisQuantity or servingSize and one instance of nutrientTypeCode equals 'FASAT' and quantityContained is used and another instance of nutrientTypeCode equals 'FAT' and quantityContained is used then quantityContained for nutrientTypeCode 'FASAT' SHALL be less than or equal to quantityContained for nutrientTypeCode 'FAT'.-->
			<xsl:if test="$fasat and $fasat/quantityContained != ''">
				<xsl:if test="$fat and $fat/quantityContained != ''">
					<xsl:variable name="v1">
						<xsl:apply-templates select="$fasat/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:variable name="v2">
						<xsl:apply-templates select="$fat/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:if test="$v1 &gt; $v2">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1641" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<!--Rule 1644: If targetMarketCountryCode equals <Geographic> for the same nutrientBasisQuantity or servingSize and one instance of nutrientTypeCode equals 'FAMSCIS' and quantityContained is used and another instance of nutrientTypeCode equals 'FAT' and quantityContained is used then quantityContained for nutrientTypeCode 'FAMSCIS' SHALL be less than or equal to quantityContained for nutrientTypeCode 'FAT'.-->
			<xsl:if test="$famcis and $famcis/quantityContained != ''">
				<xsl:if test="$fat and $fat/quantityContained != ''">
					<xsl:variable name="v1">
						<xsl:apply-templates select="$famcis/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:variable name="v2">
						<xsl:apply-templates select="$fat/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:if test="$v1 &gt; $v2">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1641" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<!--Rule 1645: If targetMarketCountryCode equals <Geographic> for the same nutrientBasisQuantity or servingSize and one instance of nutrientTypeCode equals 'FAPUCIS' and quantityContained is used and another instance of nutrientTypeCode equals 'FAT' and quantityContained is used then quantityContained for nutrientTypeCode 'FAPUCIS' SHALL be less than or equal to quantityContained for nutrientTypeCode 'FAT'.-->
			<xsl:if test="$fapucis and $fapucis/quantityContained != ''">
				<xsl:if test="$fat and $fat/quantityContained != ''">
					<xsl:variable name="v1">
						<xsl:apply-templates select="$fapucis/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:variable name="v2">
						<xsl:apply-templates select="$fat/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:if test="$v1 &gt; $v2">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1641" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>

			<!--Rule 1665: If targetMarketCountryCode equals <Geographic> for the same nutrientBasisQuantity or servingSize and one instance of nutrientTypeCode equals 'SUGAR-' and quantityContained is used and another instance of nutrientTypeCode equals 'CHOAVL' and quantityContained is used then quantityContained for nutrientTypeCode 'SUGAR-' SHALL be less than or equal to quantityContained for nutrientTypeCode 'CHOAVL'.-->
			<xsl:if test="$sugarmin and $sugarmin/quantityContained != ''">
				<xsl:if test="$choavl and $choavl/quantityContained != ''">
					<xsl:variable name="v1">
						<xsl:apply-templates select="$sugarmin/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:variable name="v2">
						<xsl:apply-templates select="$choavl/quantityContained" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:if test="$v1 &gt; $v2">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1665" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:if>


		<!--Rule 1654: If targetMarketCountryCode equals <Geographic> and nutrientTypeCode equals ('ENER-', 'FAT', 'FASAT', 'CHOAVL', 'SUGAR-', 'PRO-' or 'SALTEQ') and dailyValueIntakePercent is used then dailyValueIntakeReference SHALL be used in the parent NutrientHeader class.-->
		<xsl:if test="contains('040, 056, 203, 276, 380, 442, 528, 752, 756, 826', $targetMarket)">
			<xsl:variable name="used">
				<xsl:choose>
					<xsl:when test="nutrientDetail[nutrientTypeCode = 'ENER-']/dailyValueIntakePercent != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:when test="nutrientDetail[nutrientTypeCode = 'FAT']/dailyValueIntakePercent != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:when test="nutrientDetail[nutrientTypeCode = 'FASAT']/dailyValueIntakePercent != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:when test="nutrientDetail[nutrientTypeCode = 'CHOAVL']/dailyValueIntakePercent != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:when test="nutrientDetail[nutrientTypeCode = 'SUGAR-']/dailyValueIntakePercent != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:when test="nutrientDetail[nutrientTypeCode = 'PRO-']/dailyValueIntakePercent != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:when test="nutrientDetail[nutrientTypeCode = 'SALTEQ']/dailyValueIntakePercent != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$used = 1 and dailyValueIntakeReference = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1654" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<xsl:variable name="parent" select="."/>

		<!--Rule 1717: If targetMarketCountryCode equals <Geographic> and NutrientDetail sub-class is used then all nutrientTypeCode values SHALL be unique within the same NutrientHeader class.-->
		<xsl:if test="contains('208, 250, 752, 756, 040', $targetMarket)">
			<xsl:for-each select="nutrientDetail/nutrientTypeCode">
				<xsl:variable name="value" select="."/>
				<xsl:if test="count($parent/nutrientDetail[nutrientTypeCode = $value]) &gt; 1">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1717" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>		  
		</xsl:if>

	</xsl:template>

	<xsl:template match="nutrientDetail" mode="nutritionalInformationModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 1445: If nutrientTypeCode is used and measurementPrecisionCode does not equal ('ABSENCE', 'NOT_DETECTED', 'NOT_SIGNIFICANT_SOURCE_OF', 'TRACE', 'UNDETECTABLE') then at least quantityContained or dailyValueIntakePercent SHALL be used.-->
		<xsl:if test="nutrientTypeCode != ''">
			<xsl:choose>
				<xsl:when test="measurementPrecisionCode = 'ABSENCE'"/>
				<xsl:when test="measurementPrecisionCode = 'NOT_DETECTED'"/>
				<xsl:when test="measurementPrecisionCode = 'NOT_SIGNIFICANT_SOURCE_OF'"/>
				<xsl:when test="measurementPrecisionCode = 'TRACE'"/>
				<xsl:when test="measurementPrecisionCode = 'UNDETECTABLE'"/>
				<xsl:otherwise>
					<xsl:if test="quantityContained = '' and dailyValueIntakePercent = ''">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1445" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>