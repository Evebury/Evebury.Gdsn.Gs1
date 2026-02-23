<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:transportation_hazardous_classification:xsd:3' and local-name()='transportationHazardousClassificationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="transportationClassification/regulatedTransportationMode/hazardousInformationHeader" mode="transportationHazardousClassificationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="hazardousInformationHeader" mode="transportationHazardousClassificationModule">
		<xsl:param name="targetMarket"/>

		<xsl:if test="dangerousGoodsRegulationCode  = 'ADR'">

			<!--Rule 339: If dangerousGoodsRegulationCode is equal to 'ADR' and dangerousGoodsPackingGroup is not empty then dangerousGoodsPackingGroup must equal  ('NA','I', 'II' or 'III').-->
			<xsl:for-each select="hazardousInformationDetail/dangerousGoodsPackingGroup">
				<xsl:choose>
					<xsl:when test=". = ''"/>
					<xsl:when test=". = 'NA'"/>
					<xsl:when test=". = 'I'"/>
					<xsl:when test=". = 'II'"/>
					<xsl:when test=". = 'III'"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="339"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<!--Rule 437: If dangerousGoodsRegulationCode is equal to 'ADR' and classOfDangerousGoods is not empty then classOfDangerousGoods must equal ('1', '2', '3', '4.1', '4.2', '4.3', '5.1', '5.2', '6.1', '6.2', '7', '8'or '9').-->
			<xsl:for-each select="hazardousInformationDetail/classOfDangerousGoods">
				<xsl:choose>
					<xsl:when test=". = ''"/>
					<xsl:when test=". = '1'"/>
					<xsl:when test=". = '2'"/>
					<xsl:when test=". = '3'"/>
					<xsl:when test=". = '4.1'"/>
					<xsl:when test=". = '4.2'"/>
					<xsl:when test=". = '4.3'"/>
					<xsl:when test=". = '5.1'"/>
					<xsl:when test=". = '5.2'"/>
					<xsl:when test=". = '6.1'"/>
					<xsl:when test=". = '6.2'"/>
					<xsl:when test=". = '7'"/>
					<xsl:when test=". = '8'"/>
					<xsl:when test=". = '9'"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="437"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>

		<!--Rule 477: If targetMarketCountryCode equals <Geographic> and (maximumTemperature, minimumTemperature, flashPoint/flashPointTemperature or hazardousInformationHeader/flashPointTemperature are used) then at least one iteration of the associated measurementUnitCode SHALL equal 'CEL'.-->
		<xsl:if test="contains('752, 203, 250, 208, 246, 040, 703, 756', $targetMarket)">
			<xsl:if test="flashPointTemperature">
				<xsl:choose>
					<xsl:when test="flashPointTemperature[@temperatureMeasurementUnitCode = 'CEL']"/>
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