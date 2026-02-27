<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:delivery_purchasing_information:xsd:3' and local-name()='deliveryPurchasingInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="deliveryPurchasingInformation" mode="deliveryPurchasingInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="deliveryPurchasingInformation" mode="deliveryPurchasingInformationModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="incotermInformation" mode="deliveryPurchasingInformationModule"/>
		
		<!--Rule 341: If a start dateTime and its corresponding end dateTime are not empty then the start date SHALL be less than or equal to corresponding end date. -->
		<xsl:if test="gs1:InvalidDateTimeSpan(consumerFirstAvailabilityDateTime, consumerEndAvailabilityDateTime)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="341"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="gs1:InvalidDateTimeSpan(firstOrderDateTime, lastOrderDateTime)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="341"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="gs1:InvalidDateTimeSpan(startAvailabilityDateTime, endAvailabilityDateTime)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="341"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="gs1:InvalidDateTimeSpan(startDateMaximumBuyingQuantity, endMaximumBuyingQuantityDateTime)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="341"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="gs1:InvalidDateTimeSpan(startDateMinimumBuyingQuantity, endMinimumBuyingQuantityDateTime)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="341"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="gs1:InvalidDateTimeSpan(firstShipDateTime, lastShipDateTime)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="341"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:for-each select="orderableReturnableInformation">
			<xsl:if test="gs1:InvalidDateTimeSpan(firstReturnableDateTime, lastReturnableDateTime)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="341"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

		<!--Rule 362: If a minimum and corresponding maximum are not empty then the minimum SHALL be less than or equal to the corresponding maximum.-->
		<xsl:if test="gs1:InvalidRange(agreedMinimumBuyingQuantity,agreedMaximumBuyingQuantity)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="362"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="gs1:InvalidRange(orderQuantityMinimum,orderQuantityMaximum)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="362"/>
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 526: If orderingLeadTime is not empty, then value must be greater than 0.-->
		<xsl:for-each select="distributionDetails/orderingLeadTime">
			<xsl:if test=". != '' and . &lt; 0">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="526" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

		<!--Rule 1289: If targetMarketCountryCode does not equal (036 (Australia), 554 (New Zealand)) and If  firstShipDateTime is less than or equal to current date then preliminaryItemStatusCode must not equal 'PRELIMINARY' -->
		<xsl:if test="$targetMarket != '036' and $targetMarket != '554'">
			<xsl:if test="gs1:InvalidDateTimeSpan(gs1:Today(), firstShipDateTime)">
				<xsl:if test="$tradeItem/preliminaryItemStatusCode = 'PRELIMINARY'">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1289" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	
	</xsl:template>

	<xsl:template match="incotermInformation" mode="deliveryPurchasingInformationModule">
		<!--Rule 392: If incotermCodeLocation is not empty then incotermCode must not be empty.-->
		<xsl:if test="incotermCodeLocation != '' and incotermCode =''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="392" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>