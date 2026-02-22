<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:trade_item_hierarchy:xsd:3' and local-name()='tradeItemHierarchyModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="tradeItemHierarchy" mode="tradeItemHierarchyModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="tradeItemHierarchy" mode="tradeItemHierarchyModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:if test="isTradeItemPackedIrregularly = 'false'">

			<xsl:variable name="total" select="$tradeItem/nextLowerLevelTradeItemInformation/totalQuantityOfNextLowerLevelTradeItem"/>
			
			<!--Rule 446: If isTradeItemPackedIrregularly equals ‘FALSE’ and tradeItemCompositionWidth, tradeItemCompositionDepth and quantityOfCompleteLayersContainedInATradeItem are all supplied and tradeItemCompositionWidth/measurementUnitCode and tradeItemCompositionDepth/measurementUnitCode equal ‘EA’ then the product of the three attributes should equal the totalQuantityOfNextLowerLevelTradeItem.-->
			<xsl:variable name="measurements" select="$tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements"/>
			<xsl:if test="$measurements">
				<xsl:variable name="depth" select="$measurements/tradeItemCompositionDepth"/>
				<xsl:variable name="width" select="$measurements/tradeItemCompositionWidth"/>
				<xsl:if test="$depth * $width * quantityOfCompleteLayersContainedInATradeItem != $total">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="446"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>

			<!--Rule 473: If isTradeItemPackedIrregularly is equal to 'FALSE' and quantityOfCompleteLayersContainedInATradeItem is used and quantityOfTradeItemsContainedInACompleteLayer is used then totalQuantityOfNextLowerLevelTradeItem must equal quantityOfCompleteLayersContainedInATradeItem multiplied by value in quantityOfTradeItemsContainedInACompleteLayer.-->
			<xsl:if test="quantityOfCompleteLayersContainedInATradeItem * quantityOfTradeItemsContainedInACompleteLayer != $total">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="473"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>

		<!--Rule 481: If targetMarketCountryCode equals <Geographic> and quantityOfLayersPerPallet is used then quantityOfLayersPerPallet SHALL be less than 999.-->
		<xsl:if test="contains('056, 442, 528', $targetMarket)">
			<xsl:if test="quantityOfLayersPerPallet != '' and quantityOfLayersPerPallet &gt;= 999">
				<xsl:apply-templates select="quantityOfLayersPerPallet" mode="error">
					<xsl:with-param name="id" select="481"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<!--Rule 519: If  targetMarketCountryCode is equal to '752' (Sweden) and layerHeight is not empty then value must equal child item width, depth or height.-->
		<xsl:if test="contains('752', $targetMarket)">
			<xsl:if test="layerHeight != ''">
				<xsl:variable name="value">
					<xsl:apply-templates select="layerHeight" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="height">
					<xsl:apply-templates select="$tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements/height" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:if test="$value != $height">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="519" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>

		<!--Rule 530: If targetMarketCountryCode equals <Geographic> and quantityOfTradeItemsPerPalletLayer is used then quantityOfLayersPerPallet SHALL be used..-->
		<xsl:if test="quantityOfTradeItemsPerPalletLayer != ''">
			<xsl:if test="contains('036, 348, 528, 056, 442, 380, 554', $targetMarket)">
				<xsl:if test="quantityOfLayersPerPallet = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="530" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>

		<!--Rule 576: If  isNonGTINLogisticsUnitPackedIrregularly is equal to 'false' then quantityOfTradeItemsPerPallet shall equal quantityOfLayersPerPallet multiplied by quantityOfTradeItemsPerPalletLayer.-->
		<xsl:if test="isNonGTINLogisticsUnitPackedIrregularly = 'false'">
			<xsl:if test="quantityOfLayersPerPallet * quantityOfTradeItemsPerPalletLayer != quantityOfTradeItemsPerPallet">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="576" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
		<!--Rule 585: If targetMarketCountryCode equals ('036' (Australia),'348' (Hungary),'554' (New Zealand),'528' (Netherlands),'056' (Belgium) or'442' (Luxembourg)) and quantityOfLayersPerPallet is greater than zero then quantityOfTradeItemsPerPalletLayer shall be greater than zero.-->
		<xsl:if test="contains('036, 554, 348, 528, 056, 442', $targetMarket)">
			<xsl:if test="quantityOfLayersPerPallet != '' and quantityOfLayersPerPallet &gt; 0">
				<xsl:if test="quantityOfTradeItemsPerPalletLayer = '' or quantityOfTradeItemsPerPalletLayer &lt;= 0">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="585" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	
	</xsl:template>

</xsl:stylesheet>