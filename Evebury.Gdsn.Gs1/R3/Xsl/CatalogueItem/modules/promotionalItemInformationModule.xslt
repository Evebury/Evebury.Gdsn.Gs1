<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:promotional_item_information:xsd:3' and local-name()='promotionalItemInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="promotionalItemInformation" mode="promotionalItemInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="promotionalItemInformation" mode="promotionalItemInformationModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="nonPromotionalTradeItem" mode="promotionalItemInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>

		<!--Rule 1320: If (freeQuantityOfNextLowerLevelTradeItem or  freeQuantityOfProduct) is not empty, then istradeItemAConsumerunit must equal "TRUE"-->
		<xsl:if test="freeQuantityOfNextLowerLevelTradeItem != '' or freeQuantityOfProduct != ''">
			<xsl:if test="$tradeItem/isTradeItemAconsumerUnit != 'true'">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1320" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<!--Rule 1321: If promotionTypeCode is not empty, then isTradeItemAConsumerUnit must equal "TRUE"-->
		<xsl:if test="promotionTypeCode != '' and $tradeItem/isTradeItemAconsumerUnit != 'true'">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1321" />
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 1323: The associated UoM of freeQuantityOfNextLowerLevelTradeItem must be one of the associated UoMs of netContent of the child trade item.-->
		<xsl:for-each select="freeQuantityOfNextLowerLevelTradeItem">
			<xsl:variable name="unit" select="@measurementUnitCode"/>
			<xsl:choose>
				<xsl:when test="$tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements/netContent[@measurementUnitCode = $unit]"/>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1323" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<!--Rule 1859: If targetMarketCountryCode equals <Geographic> and ChildItem..isTradeItemAPromotionalUnit equals 'true', then isTradeItemAPromotionalUnit SHALL equal 'true'.-->
		<xsl:if test="$targetMarket = '250' and isTradeItemAPromotionalUnit != 'true'">
			<xsl:for-each select="$tradeItem/../catalogueItemChildItemLink/catalogueItem/tradeItem">
				<xsl:if test="./tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:promotional_item_information:xsd:3' and local-name()='promotionalItemInformationModule']/isTradeItemAPromotionalUnit = 'true'">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1859" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>

	</xsl:template>

	<xsl:template match="nonPromotionalTradeItem" mode="promotionalItemInformationModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="." mode="gtin"/>

		<xsl:for-each select="additionalTradeItemIdentification">
			<xsl:choose>
				<xsl:when test="@additionalTradeItemIdentificationTypeCode = 'GTIN_13'">
					<xsl:if test="gs1:InvalidGTIN(.,13)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1039" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
				<xsl:when test="@additionalTradeItemIdentificationTypeCode = 'GTIN_8'">
					<xsl:if test="gs1:InvalidGTIN(.,8)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1040" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
				<xsl:when test="@additionalTradeItemIdentificationTypeCode = 'GTIN_14'">
					<xsl:if test="gs1:InvalidGTIN(.,14)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1041" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
				<xsl:when test="@additionalTradeItemIdentificationTypeCode = 'GTIN_12'">
					<xsl:if test="gs1:InvalidGTIN(.,12)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1042" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>

		<!--Rule 1317: If PromotionalItemInformation/nonPromotionalTradeItem/tradeItemIdentification is not empty,  then isTradeItemAconsumerUnit must equal "TRUE" -->
		<xsl:if test="gtin != '' and $tradeItem/isTradeItemAconsumerUnit != 'true'">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1317" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>