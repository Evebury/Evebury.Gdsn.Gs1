<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:trade_item_lifespan:xsd:3' and local-name()='tradeItemLifespanModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="tradeItemLifespan" mode="tradeItemLifespanModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	

	</xsl:template>

	<xsl:template match="tradeItemLifespan" mode="tradeItemLifespanModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 314: If minimumTradeItemLifespanFromTimeOfProduction is not empty and minimumTradeItemLifespanFromTimeOfArrival is not empty then minimumTradeItemLifespanFromTimeOfProduction must be greater than or equal to minimumTradeItemLifespanFromTimeOfArrival.-->
		<xsl:if test="gs1:InvalidRange(minimumTradeItemLifespanFromTimeOfArrival, minimumTradeItemLifespanFromTimeOfProduction)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="314"/>
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 536: If minimumTradeItemLifespanFromTimeOfArrival is not empty then value must be greater than 0.-->
		<xsl:if test="minimumTradeItemLifespanFromTimeOfArrival != '' and minimumTradeItemLifespanFromTimeOfArrival &lt;= 0">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="536" />
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 537: If minimumTradeItemLifespanFromTimeOfProduction is not empty then value must be greater than 0.-->
		<xsl:if test="minimumTradeItemLifespanFromTimeOfProduction != '' and minimumTradeItemLifespanFromTimeOfProduction &lt;= 0">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="537" />
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 1952: If targetMarketCountryCode equals <Geographic> and itemPeriodSafeToUseAfterOpening is used then itemPeriodSafeToUseAfterOpening/@timeMeasurementUnitCode SHALL equal 'ANN' or 'MON'.-->
		<xsl:if test="contains('203, 752, 756, 040, 703', $targetMarket)">
			<xsl:for-each select="itemPeriodSafeToUseAfterOpening">
				<xsl:choose>
					<xsl:when test="@timeMeasurementUnitCode = 'ANN'"/>
					<xsl:when test="@timeMeasurementUnitCode = 'MON'"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1952" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
		
		
	</xsl:template>

</xsl:stylesheet>