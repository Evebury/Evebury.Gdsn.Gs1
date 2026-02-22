<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:trade_item_lifespan:xsd:3' and local-name()='tradeItemLifespanModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="tradeItemLifespan" mode="tradeItemLifespanModule"/>

	

	</xsl:template>

	<xsl:template match="tradeItemLifespan" mode="tradeItemLifespanModule">
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
		
		
	</xsl:template>

</xsl:stylesheet>