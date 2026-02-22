<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="tradeItemMeasurements" mode="tradeItemMeasurementsModule">
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>


	</xsl:template>

	<xsl:template match="tradeItemMeasurements" mode="tradeItemMeasurementsModule">
		<xsl:param name="tradeItem"/>
		<xsl:variable name="netWeightValue" select="tradeItemWeight/netWeight"/>
		<xsl:variable name="grossWeightValue" select="tradeItemWeight/grossWeight"/>

		<!--Rule 98: If specialItemCode does not equal 'DYNAMIC_ASSORTMENT' and parent trade item netWeight and child trade item netWeight are used then parent netWeight shall  be greater than or equal to the sum of (netweight multiplied by quantityOfNextLowerLevelTradeItem) of each child item.-->
		<xsl:if test="$tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:marketing_information:xsd:3' and local-name()='marketingInformationModule']/marketingInformation/specialItemCode != 'DYNAMIC_ASSORTMENT'">
			<xsl:if test="$netWeightValue = number($netWeightValue)">

				<xsl:variable name="netWeight">
					<xsl:apply-templates select="$netWeightValue" mode="measurementUnit"/>
				</xsl:variable>

				<xsl:variable name="childNetWeight">
					<xsl:call-template name="r98">
						<xsl:with-param name="items" select="$tradeItem/../catalogueItemChildItemLink" />
					</xsl:call-template>
				</xsl:variable>

				<xsl:if test="$childNetWeight &gt; $netWeight">
					<xsl:apply-templates select="$netWeightValue" mode="error">
						<xsl:with-param name="id" select="98"/>
					</xsl:apply-templates>
				</xsl:if>

			</xsl:if>
		</xsl:if>


		<!--Rule 201: If grossWeight is not empty and netWeight is not empty then grossWeight must be greater than or equal to netWeight.-->
		<xsl:if test="$grossWeightValue = number($grossWeightValue) and $netWeightValue = number($netWeightValue)">

			<xsl:variable name="grossWeight">
				<xsl:apply-templates select="$grossWeightValue" mode="measurementUnit"/>
			</xsl:variable>

			<xsl:variable name="netWeight">
				<xsl:apply-templates select="$netWeightValue" mode="measurementUnit"/>
			</xsl:variable>

			<xsl:if test="$netWeight &gt; $grossWeight">
				<xsl:apply-templates select="$grossWeightValue" mode="error">
					<xsl:with-param name="id" select="201"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<!--Rule 362: If a minimum and corresponding maximum are not empty then the minimum SHALL be less than or equal to the corresponding maximum.-->
		<xsl:if test="gs1:InvalidRange(individualUnitMinimumSize,individualUnitMaximumSize)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="362"/>
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 478: If nestingIncrement is not empty then value must be greater than 0.-->
		<xsl:for-each select="tradeItemNesting/nestingIncrement">
			<xsl:if test=". != '' and . &lt;= 0">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="478"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

		<!--Rule 515: If  grossWeight is not empty then value shall be greater than or equal to 0.-->
		<xsl:if test="$grossWeightValue != '' and $grossWeightValue &lt; 0">
			<xsl:apply-templates select="$grossWeightValue" mode="error">
				<xsl:with-param name="id" select="515" />
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 516: If netWeight is not empty then value must be greater than 0.-->
		<xsl:if test="netWeightValue != '' and netWeightValue &lt; 0">
			<xsl:apply-templates select="netWeightValue" mode="error">
				<xsl:with-param name="id" select="516" />
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 539: If grossWeight is used and netContent/measurementUnitCode is a weight then grossWeight shall be greater than or equal to netContent.-->
		<xsl:if test="$grossWeightValue != ''">
			<xsl:if test="netContent != ''">
				<xsl:variable name="type">
					<xsl:apply-templates select="netContent" mode="measurementUnitType"/>
				</xsl:variable>
				<xsl:if test="$type = 'Weight'">
					<xsl:variable name="grossWeight">
						<xsl:apply-templates select="$grossWeightValue" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:variable name="netContentWeight">
						<xsl:apply-templates select="netContent" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:if test="$netContentWeight &gt; $grossWeight">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="539" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:if>

		<!--Rule 543: If individualUnitMinimumSize and/or individualUnitMaximumSize are not empty then isTradeItemABaseUnit must equal 'true'.-->
		<!--Rule 544: If isTradeItemABaseUnit is equal to 'false' then individualUnitMinimumSize and individualUnitMaximumSize must be empty.-->
		<xsl:if test="individualUnitMaximumSize != '' and individualUnitMinimumSize != ''">
			<xsl:if test="$tradeItem/isTradeItemABaseUnit != 'true'">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="544" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<!--Rule 613: If freeQuantityOfProduct and netContent are both used, then freeQuantityOfProduct shall be less than or equal to netContent, when expressed in the same measurementUnitCode.-->
		<xsl:if test="netContent != ''">
			<xsl:variable name="freeQuantityOfProduct" select="$tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:promotional_item_information:xsd:3' and local-name()='promotionalItemInformationModule']/promotionalItemInformation/freeQuantityOfProduct"/>
			<xsl:if test="$freeQuantityOfProduct != ''">
				<xsl:variable name="netContentType">
					<xsl:apply-templates select="netContent" mode="measurementUnitType"/>
				</xsl:variable>
				<xsl:variable name="freeQuantityOfProductType">
					<xsl:apply-templates select="$freeQuantityOfProduct" mode="measurementUnitType"/>
				</xsl:variable>
				<xsl:if test="$netContentType = $freeQuantityOfProductType">
					<xsl:variable name="netContentValue">
						<xsl:apply-templates select="netContent" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:variable name="freeQuantityOfProductValue">
						<xsl:apply-templates select="netContent" mode="measurementUnit"/>
					</xsl:variable>
					<xsl:if test="$freeQuantityOfProductValue &gt; $netContentValue">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="613" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:if>

		<!--Rule 616: if drainedWeight and netWeight are not empty then drainedWeight must be less than or equal to netWeight.-->
		<xsl:if test="tradeItemWeight/drainedWeight != '' and $netWeightValue != ''">
			<xsl:variable name="netWeight">
				<xsl:apply-templates select="$netWeightValue" mode="measurementUnit"/>
			</xsl:variable>
			<xsl:variable name="drainedWeight">
				<xsl:apply-templates select="tradeItemWeight/drainedWeight" mode="measurementUnit"/>
			</xsl:variable>
			<xsl:if test="$drainedWeight &gt; $netWeight">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="616" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<!--Rule 1017: if drainedWeight and grossWeight are not empty then drainedWeight must be less than or equal to grossWeight.-->
		<xsl:if test="tradeItemWeight/drainedWeight != '' and $grossWeightValue != ''">
			<xsl:variable name="grossWeight">
				<xsl:apply-templates select="$grossWeightValue" mode="measurementUnit"/>
			</xsl:variable>
			<xsl:variable name="drainedWeight">
				<xsl:apply-templates select="tradeItemWeight/drainedWeight" mode="measurementUnit"/>
			</xsl:variable>
			<xsl:if test="$drainedWeight &gt; $grossWeight">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1017" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>


	</xsl:template>




	<xsl:template name="r98">
		<xsl:param name="items"/>
		<xsl:param name="index" select="1"/>
		<xsl:param name="count" select="count(msxsl:node-set($items))"/>
		<xsl:param name="weight" select="0"/>
		<xsl:choose>
			<xsl:when test="$index &lt;= $count">
				<xsl:variable name="item" select="msxsl:node-set($items)[$index]"/>

				<xsl:variable name="value" select="$item/catalogueItem/tradeItem/tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements/tradeItemWeight/netWeight"/>

				<xsl:variable name="netWeight">
					<xsl:choose>
						<xsl:when test="$value = number($value)">
							<xsl:variable name="quantity">
								<xsl:choose>
									<xsl:when test="$item/quantity = number($item/quantity)">
										<xsl:value-of select="$item/quantity"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="1"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="weightValue">
								<xsl:apply-templates select="$value" mode="measurementUnit"/>
							</xsl:variable>
							<xsl:value-of select="$quantity * $weightValue"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="0"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:call-template name="r98">
					<xsl:with-param name="items" select="$items"/>
					<xsl:with-param name="index" select="$index + 1"/>
					<xsl:with-param name="count" select="$count"/>
					<xsl:with-param name="weight" select="$weight + $netWeight"/>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$weight"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>