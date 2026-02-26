<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1 cin"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	xmlns:cin="urn:gs1:gdsn:catalogue_item_notification:xsd:3"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="version" select="'3.1'"/>
	<xsl:param name="current"/>

	<xsl:include href="modules/alcoholInformationModule.xslt"/>
	<xsl:include href="modules/allergenInformationModule.xslt"/>
	<xsl:include href="modules/animalFeedingModule.xslt"/>
	<xsl:include href="modules/audienceOrPlayerInformationModule.xslt"/>
	<xsl:include href="modules/audioVisualMediaContentInformationModule.xslt"/>
	<xsl:include href="modules/audioVisualMediaProductDescriptionInformationModule.xslt"/>
	<xsl:include href="modules/batteryInformationModule.xslt"/>
	<xsl:include href="modules/certificationInformationModule.xslt"/>
	<xsl:include href="modules/childNutritionInformationModule.xslt"/>
	<xsl:include href="modules/dairyFishMeatPoultryItemModule.xslt"/>
	<xsl:include href="modules/dangerousSubstanceInformationModule.xslt"/>
	<xsl:include href="modules/deliveryPurchasingInformationModule.xslt"/>
	<xsl:include href="modules/dietInformationModule.xslt"/>
	<xsl:include href="modules/dutyFeeTaxInformationModule.xslt"/>
	<xsl:include href="modules/farmingAndProcessingInformationModule.xslt"/>
	<xsl:include href="modules/foodAndBeverageIngredientModule.xslt"/>
	<xsl:include href="modules/foodAndBeveragePreparationServingModule.xslt"/>
	<xsl:include href="modules/foodAndBeveragePropertiesInformationModule.xslt"/>
	<xsl:include href="modules/healthRelatedInformationModule.xslt"/>
	<xsl:include href="modules/marketingInformationModule.xslt"/>
	<xsl:include href="modules/materialModule.xslt"/>
	<xsl:include href="modules/nonfoodIngredientModule.xslt"/>
	<xsl:include href="modules/nonGTINLogisticsUnitInformationModule.xslt"/>
	<xsl:include href="modules/nutritionalInformationModule.xslt"/>
	<xsl:include href="modules/oNIXPublicationFileInformationModule.xslt"/>
	<xsl:include href="modules/packagingInformationModule.xslt"/>
	<xsl:include href="modules/packagingMarkingModule.xslt"/>
	<xsl:include href="modules/placeOfItemActivityModule.xslt"/>
	<xsl:include href="modules/plumbingHVACPipeInformationModule.xslt"/>
	<xsl:include href="modules/productFormulationStatementModule.xslt"/>
	<xsl:include href="modules/productInformationModule.xslt"/>
	<xsl:include href="modules/promotionalItemInformationModule.xslt"/>
	<xsl:include href="modules/referencedFileDetailInformationModule.xslt"/>
	<xsl:include href="modules/regulatedTradeItemModule.xslt"/>
	<xsl:include href="modules/safetyDataSheetModule.xslt"/>
	<xsl:include href="modules/salesInformationModule.xslt"/>
	<xsl:include href="modules/tradeItemDataCarrierAndIdentificationModule.xslt"/>
	<xsl:include href="modules/tradeItemDescriptionModule.xslt"/>
	<xsl:include href="modules/tradeItemHandlingModule.xslt"/>
	<xsl:include href="modules/tradeItemHierarchyModule.xslt"/>
	<xsl:include href="modules/tradeItemHumidityInformationModule.xslt"/>
	<xsl:include href="modules/tradeItemLicensingModule.xslt"/>
	<xsl:include href="modules/tradeItemLifespanModule.xslt"/>
	<xsl:include href="modules/tradeItemMeasurementsModule.xslt"/>
	<xsl:include href="modules/tradeItemSizeModule.xslt"/>
	<xsl:include href="modules/tradeItemTemperatureInformationModule.xslt"/>
	<xsl:include href="modules/transportationHazardousClassificationModule.xslt"/>
	<xsl:include href="modules/variableTradeItemInformationModule.xslt"/>
	<xsl:include href="modules/warrantyInformationModule.xslt"/>

	<!-- region auxiliary -->
	<xsl:include href="measurementUnit.xslt"/>
	<xsl:include href="components.xslt"/>

	<xsl:variable name="quote">
		<xsl:text>'</xsl:text>
	</xsl:variable>

	<xsl:variable name="EVENT_DATA_INFORMATION_PROVIDER" select="'information_provider'"/>
	<xsl:variable name="EVENT_DATA_MARKET" select="'market'"/>
	<xsl:variable name="EVENT_DATA_TRADE_PARTNER" select="'trade_partner'"/>
	<xsl:variable name="EVENT_DATA_GTIN" select="'gtin'"/>
	<xsl:variable name="EVENT_DATA_DESCRIPTOR" select="'descriptor'"/>
	<xsl:variable name="EVENT_DATA_BRICK" select="'brick'"/>
	<xsl:variable name="EVENT_DATA_XPATH" select="'xpath'"/>
	<xsl:variable name="EVENT_DATA_LANGUAGE" select="'language'"/>
	<xsl:variable name="EVENT_DATA_MEASUREMENT_UNIT" select="'unit'"/>

	<xsl:template match="*" mode="error">
		<xsl:param name="id"/>
		<xsl:apply-templates select="." mode="xpath"/>
		<xsl:apply-templates select="gs1:AddErrorEvent($id)" />
	</xsl:template>

	<xsl:template match="*" mode="xpath">
		<xsl:param name="xpath" select="''"/>
		<xsl:variable name="name" select="local-name()"/>
		<xsl:choose>
			<xsl:when test="$name != 'catalogueItemNotificationMessage'">
				<xsl:variable name="path">
					<xsl:choose>
						<xsl:when test="$name = 'transaction'">
							<xsl:value-of select="concat($name, '[transactionIdentification/entityIdentification =', $quote, transactionIdentification/entityIdentification , $quote, ']')"/>
						</xsl:when>
						<xsl:when test="$name = 'catalogueItem'">
							<xsl:choose>
								<xsl:when test="tradeItem/gtin != ''">
									<xsl:value-of select="concat($name, '[tradeItem/gtin = ', $quote, tradeItem/gtin, $quote, ']')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="name()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:apply-templates select=".." mode="xpath">
					<xsl:with-param name="xpath">
						<xsl:choose>
							<xsl:when test="$xpath = ''">
								<xsl:value-of select="$path"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($path,'/',$xpath)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_XPATH, concat('/', name(), '/', $xpath))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--endregion auxiliary -->

	<xsl:template match="/">
		<xsl:apply-templates select="gs1:BeginResponse($version)"/>
		<xsl:apply-templates select="cin:catalogueItemNotificationMessage"/>
		<xsl:copy-of select="gs1:EndResponse()"/>
	</xsl:template>

	<xsl:template match="cin:catalogueItemNotificationMessage">
		<xsl:variable name="count" select="count(transaction)"/>
		<xsl:choose>
			<xsl:when test="$count &gt; 1000">
				<!--There must be at most 1000 transactions per message.-->
				<xsl:apply-templates select="transaction" mode="r493"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="transaction"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="transaction">
		<xsl:apply-templates select="gs1:BeginTransaction(transactionIdentification/entityIdentification)"/>
		<xsl:apply-templates select="documentCommand/cin:catalogueItemNotification/catalogueItem" mode="hierarchical">
			<xsl:with-param name="command" select="documentCommand/documentCommandHeader/@type"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="gs1:EndTransaction()"/>
	</xsl:template>

	<xsl:template match="catalogueItem" mode="hierarchical">
		<xsl:param name="sequence" select="1"/>
		<xsl:param name="command"/>

		<xsl:variable name="informationProvider" select="tradeItem/informationProviderOfTradeItem/gln"/>
		<xsl:variable name="targetMarket" select="tradeItem/targetMarket/targetMarketCountryCode"/>

		<xsl:apply-templates select="gs1:BeginSequence()"/>
		<xsl:apply-templates select="gs1:AddSequenceEventDataWithLabel($EVENT_DATA_INFORMATION_PROVIDER, $informationProvider, tradeItem/informationProviderOfTradeItem/partyName)"/>
		<xsl:apply-templates select="gs1:AddSequenceEventData($EVENT_DATA_MARKET, $targetMarket)"/>
		<xsl:for-each select="tradeItem/partyInRole[partyRoleCode = 'PARTY_RECEIVING_PRIVATE_DATA']">
			<xsl:apply-templates select="gs1:AddSequenceEventDataWithLabel($EVENT_DATA_TRADE_PARTNER, gln, partyName)"/>
		</xsl:for-each>
		<xsl:apply-templates select="gs1:AddSequenceEventData($EVENT_DATA_GTIN, tradeItem/gtin)"/>
		<xsl:apply-templates select="gs1:AddSequenceEventData($EVENT_DATA_DESCRIPTOR, tradeItem/tradeItemUnitDescriptorCode)"/>

		<xsl:if test="$sequence = 1">
			<xsl:apply-templates select="." mode="hierarchy_rules">
				<xsl:with-param name="targetMarket" select="$targetMarket"/>
				<xsl:with-param name="informationProvider" select="$informationProvider"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:apply-templates select="tradeItem" mode="instance_rules">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="informationProvider" select="$informationProvider"/>
			<xsl:with-param name="command" select="$command"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="gs1:EndSequence()"/>

		<xsl:apply-templates select="catalogueItemChildItemLink/catalogueItem" mode="hierarchical">
			<xsl:with-param name="sequence" select="$sequence + 1"/>
			<xsl:with-param name="command" select="$command"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="module">
		<!-- ignore all undefined modules -->
	</xsl:template>


	<!-- region validation rules -->

	<xsl:template match="*" mode="r96">
		<!--Rule 96: If tradeItemUnitDescriptor is equal to 'BASE_UNIT_OR_EACH' then ChildTradeItem/gtin must be empty.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH' and nextLowerLevelTradeItemInformation/childTradeItem[gtin != '']">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="96"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r202">
		<!--Rule 202: If specialItemCode does not equal 'DYNAMIC_ASSORTMENT' then the sum of all quantityofNextLowerLevelTradeItem shall equal totalQuantityOfNextLowerLevelTradeItem.-->
		<xsl:variable name="xpath" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:marketing_information:xsd:3' and local-name()='marketingInformationModule']/marketingInformation/specialItemCode" />
		<xsl:if test="$xpath != 'DYNAMIC_ASSORTMENT'">

			<xsl:variable name="xpath1" select="nextLowerLevelTradeItemInformation/totalQuantityOfNextLowerLevelTradeItem"/>

			<xsl:variable name="xpath2" select="sum(nextLowerLevelTradeItemInformation/childTradeItem/quantityOfNextLowerLevelTradeItem)"/>

			<xsl:if test="$xpath1 != $xpath2">
				<xsl:apply-templates select="$xpath1" mode="error">
					<xsl:with-param name="id" select="202"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r203">
		<!--Rule 203: dataRecipient must not be empty.-->
		<xsl:if test="../dataRecipient = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="203"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r204">
		<!--Rule 204: If isTradeItemADespatchUnit equals 'true' then tradeItemWeight/grossWeight SHALL be greater than 0.-->
		<xsl:if test="isTradeItemADespatchUnit = 'true'">
			<xsl:variable name="xpath" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements/tradeItemWeight/grossWeight" />
			<xsl:variable name="grossWeight">
				<xsl:choose>
					<xsl:when test="$xpath != number($xpath)">
						<xsl:value-of select="0"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$xpath"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$grossWeight &lt;= 0">
				<xsl:choose>
					<xsl:when test="$xpath  = ''">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="204"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$xpath" mode="error">
							<xsl:with-param name="id" select="204"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r312">
		<!--Rule 312: If isReturnableAssetEmpty does not equal “true” or is not used for any item in a Catalogue Item Notification Message then isTradeItemAnOrderableUnit must be equal to 'true' for at least one item in a Catalogue Item Notification Message.-->
		<xsl:if test="count(.//tradeItem[isTradeItemAnOrderableUnit = 'true']) = 0">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="312"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r325">
		<xsl:param name="targetMarket"/>
		<!--Rule 325: If targetMarketCountryCode equals <Geographic> and (gpcCategoryCode is in GPC Class '50202200' and gpcCategoryCode does not equal ('10000142', '10000143', '10008029', '10008030', '10008031', '10008032', '10008033', ' 10008034', '10008035', '10008042') and isTradeItemABaseUnit equals 'true' then percentageOfAlcoholByVolume SHALL be used.-->
		<xsl:if test="contains('008, 031, 040, 051, 056, 070, 100, 112, 191, 196, 203, 208, 233, 246, 268, 276, 300, 348, 352, 372, 376, 380, 398, 417, 428, 440, 442, 498, 499, 528, 578, 616, 620, 642, 643, 688, 703, 705, 756, 792, 795, 804, 807, 826, 860', $targetMarket) and isTradeItemABaseUnit = 'true'">
			<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode" />
			<xsl:if test="gs1:IsInClass($brick, '50202200')">
				<xsl:choose>
					<xsl:when test="contains('10000142, 10000143, 10008029, 10008030, 10008031, 10008032, 10008033, 10008034, 10008035, 10008042', $brick)"></xsl:when>
					<xsl:otherwise>
						<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:alcohol_information:xsd:3' and local-name()='alcoholInformationModule']/alcoholInformation/percentageOfAlcoholByVolume = ''">
							<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_BRICK, $brick)"/>
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="325"/>
							</xsl:apply-templates>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r382">
		<!--Rule 328: If ChildTradeItem/gtin is empty then attribute isTradeItemABaseUnit must be equal to 'true'.-->
		<xsl:if test="isTradeItemABaseUnit != 'true' and nextLowerLevelTradeItemInformation/childTradeItem[gtin = '']">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="382"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r383">
		<!--Rule 383: If ChildTradeItem/gtin is not empty then attribute isTradeItemABaseUnit must be equal to 'false'.-->
		<xsl:if test="isTradeItemABaseUnit != 'false' and nextLowerLevelTradeItemInformation/childTradeItem[gtin != '']">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="383"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r454">
		<!--Rule 454: ChildTradeItem/gtin must not equal TradeItem/gtin-->
		<xsl:variable name="gtin" select="gtin" />
		<xsl:for-each select="nextLowerLevelTradeItemInformation/childTradeItem/gtin">
			<xsl:if test=". = $gtin">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="454"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="r469">
		<xsl:param name="targetMarket" />
		<!--Rule 469: If targetMarketCountryCode equals <Geographic> then tradeItem/gtin SHALL NOT start with '002', '004' or '02'.-->
		<xsl:variable name="isTargetMarket" select="contains('056, 442, 528', $targetMarket)" />
		<xsl:if test="$isTargetMarket">
			<xsl:if test="starts-with(gtin, '002') or starts-with(gtin, '004') or starts-with(gtin, '02')">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="469"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r472">
		<!--Rule 472: If childTradeItem/gtin is used, then the corresponding tradeItem/gtin SHALL exist in the same CIN document. -->
		<xsl:variable name="tradeItem" select="."/>
		<xsl:for-each select="nextLowerLevelTradeItemInformation/childTradeItem[gtin != '']">
			<xsl:variable name="gtin" select="gtin"/>
			<xsl:choose>
				<xsl:when test="$tradeItem/../catalogueItemChildItemLink/catalogueItem/tradeItem/gtin = $gtin"/>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="472"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="r474">
		<!--Rule 474: If dataCarrierTypeCode is equal to 'EAN_8' then the first six digits of the TradeItem/GTIN shall equal '000000'.-->
		<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_data_carrier_and_identification:xsd:3' and local-name()='tradeItemDataCarrierAndIdentificationModule']/dataCarrier/dataCarrierTypeCode ='EAN_8'">
			<xsl:if test="not(starts-with(gtin, '000000'))">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="474"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r475">
		<xsl:param name="targetMarket"/>
		<!--Rule 475: targetMarketCountryCode and (targetMarketSubdivisionCode if not empty) must be consistent across item hierarchy.  Example: If parent item targetmarketCountryCode is equal to '840' then child item cannot have a targetMarketCountryCode equal to '340'.-->
		<xsl:if test="../catalogueItemChildItemLink/catalogueItem/tradeItem/targetMarket[targetMarketCountryCode != $targetMarket]">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="475"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="compare">
		<xsl:param name="targetMarket"/>
		<xsl:param name="informationProvider"/>
		<xsl:param name="command"/>
		<xsl:variable name="gtin" select="gtin"/>
		<xsl:variable name="tradeItem" select="msxsl:node-set($current)/*/tradeItem[@informationProvider = $informationProvider and @market = $targetMarket and @gtin=$gtin]"/>
		<xsl:if test="$tradeItem">
			<!--Rule 483: On first population endAvailabilityDateTime shall be later than or equal to today.-->
			<xsl:variable name="date" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:delivery_purchasing_information:xsd:3' and local-name()='deliveryPurchasingInformationModule']/deliveryPurchasingInformation/endAvailabilityDateTime"/>
			<xsl:if test="$tradeItem/deliveryPurchasingInformation/endAvailabilityDateTime = ''">
				<xsl:if test="gs1:InvalidDateTimeSpan(gs1:Today(), $date)">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="483" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
			<!-- Rule 488: lastChangeDateTime SHALL be later than or equal to the previously sent value.-->
			<xsl:if test="gs1:InvalidDateTimeSpan($tradeItem/tradeItemSynchronisationDates/lastChangeDateTime, tradeItemSynchronisationDates/lastChangeDateTime)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="488" />
				</xsl:apply-templates>
			</xsl:if>

			<xsl:if test="preliminaryItemStatusCode != 'PRELIMINARY' and $command = 'CHANGE_BY_REFRESH'">
				<xsl:variable name="module" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements"/>

				<xsl:variable name="netContent">
					<xsl:apply-templates select="$module/netContent" mode="measurementUnit"/>
				</xsl:variable>

				<xsl:variable name="cNetContent">
					<xsl:apply-templates select="$tradeItem/tradeItemMeasurements/netContent" mode="measurementUnit"/>
				</xsl:variable>

				<!--Rule 449: If preliminaryItemStatusCode does not equal 'PRELIMINARY' then if the Document Command is equal to  'CHANGE_BY_REFRESH' then netContent must not be updated.-->
				<xsl:if test="$netContent != $cNetContent">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="449"/>
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 451: If preliminaryItemStatusCode does not equal 'PRELIMINARY' and the Document Command equals  'CHANGE_BY_REFRESH' then BrandNameInformation/brandName shall not be updated.-->
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']/tradeItemDescriptionInformation/brandNameInformation/brandName != $tradeItem/tradeItemDescriptionInformation/brandName">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="451"/>
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 452: If preliminaryItemStatusCode does not equal 'PRELIMINARY' then if the Document Command is equal to 'CHANGE_BY_REFRESH' then totalQuantityOfNextLowerLevelTradeItem must not be updated.-->

				<xsl:if test="nextLowerLevelTradeItemInformation/totalQuantityOfNextLowerLevelTradeItem != $tradeItem/nextLowerLevelTradeItemInformation/totalQuantityOfNextLowerLevelTradeItem">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="452"/>
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 453: If the Document Command is equal to 'CHANGE_BY_REFRESH then ChildTradeItem/gtin shall not be updated.-->
				<xsl:variable name="xpath" select="."/>
				<xsl:for-each select="nextLowerLevelTradeItemInformation/childTradeItem">
					<xsl:variable name="key" select="gtin"/>
					<xsl:choose>
						<xsl:when test="$tradeItem/nextLowerLevelTradeItemInformation/childTradeItem[@gtin = $key]"/>
						<xsl:otherwise>
							<xsl:apply-templates select="$xpath" mode="error">
								<xsl:with-param name="id" select="453"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:for-each select="$tradeItem/nextLowerLevelTradeItemInformation/childTradeItem">
					<xsl:variable name="key" select="@gtin"/>
					<xsl:choose>
						<xsl:when test="$xpath/nextLowerLevelTradeItemInformation/childTradeItem[gtin = $key]"/>
						<xsl:otherwise>
							<xsl:apply-templates select="$xpath" mode="error">
								<xsl:with-param name="id" select="453"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>

				<xsl:variable name="price">
					<xsl:apply-templates select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:sales_information:xsd:3' and local-name()='salesInformationModule']/salesInformation/priceComparisonMeasurement" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="cPrice">
					<xsl:apply-templates select="$tradeItem/salesInformation/priceComparisonMeasurement" mode="measurementUnit"/>
				</xsl:variable>
				<!--Rule 450: If preliminaryItemStatusCode does not equal 'PRELIMINARY' then if the Document Command is equal to 'CHANGE_BY_REFRESH' then priceComparisonMeasurement must not be updated.-->
				<xsl:if test="$price != $cPrice">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="450"/>
					</xsl:apply-templates>
				</xsl:if>

				<xsl:variable name="height">
					<xsl:apply-templates select="$module/height" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="cHeight">
					<xsl:apply-templates select="$tradeItem/tradeItemMeasurements/height" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="width">
					<xsl:apply-templates select="$module/width" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="cWidth">
					<xsl:apply-templates select="$tradeItem/tradeItemMeasurements/width" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="depth">
					<xsl:apply-templates select="$module/depth" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="cDepth">
					<xsl:apply-templates select="$tradeItem/tradeItemMeasurements/depth" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="grossWeight">
					<xsl:apply-templates select="$module/tradeItemWeight/grossWeight" mode="measurementUnit"/>
				</xsl:variable>
				<xsl:variable name="cGrossWeight">
					<xsl:apply-templates select="$tradeItem/tradeItemMeasurements/grossWeight" mode="measurementUnit"/>
				</xsl:variable>

				<!-- Rule 500: If preliminaryItemStatusCode does not equal 'PRELIMINARY' and if the Document Command is equal to 'CHANGE_BY_REFRESH' then TradeItemMeasurements/height shall not be 20 percent greater than current version height.-->
				<xsl:if test="$height != '' and $cHeight != '' and  $height &gt; $cHeight * 1.2">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="500" />
					</xsl:apply-templates>
				</xsl:if>

				<!-- Rule 501: If preliminaryItemStatusCode does not equal 'PRELIMINARY' and if the Document Command is equal to 'CHANGE_BY_REFRESH' then TradeItemMeasurements/width shall not be 20 percent greater than current version width.-->
				<xsl:if test="$width != '' and $cWidth != '' and  $width &gt; $cWidth * 1.2">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="501" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 502: If preliminaryItemStatusCode does not equal 'PRELIMINARY' and if the Document Command is equal to 'CHANGE_BY_REFRESH' then TradeItemMeasurements/depth shall not be 20 percent greater than current version depth.-->
				<xsl:if test="$depth != '' and $cDepth != '' and  $depth &gt; $cDepth * 1.2">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="502" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 503: If preliminaryItemStatusCode does not equal 'PRELIMINARY' and if the Document Command is equal to 'CHANGE_BY_REFRESH' then TradeItemMeasurements/grossWeight shall not be 20 percent greater than current version grossWeight. -->
				<xsl:if test="$grossWeight != '' and $cGrossWeight != '' and  $grossWeight &gt; $cGrossWeight * 1.2">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="503" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 1085: If preliminaryItemStatusCode does not equal 'PRELIMINARY' and if the Document Command is equal to 'CHANGE_BY_REFRESH' then TradeItemMeasurements/height shall not be less than 80 percent of the current version height.-->
				<xsl:if test="$height != '' and $cHeight != '' and  $height &lt; $cHeight * 0.8">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1085" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 1086: If preliminaryItemStatusCode does not equal 'PRELIMINARY'  and if the Document Command is equal to 'CHANGE_BY_REFRESH' then TradeItemMeasurements/width must not be less than 80 percent of the current version width.-->
				<xsl:if test="$width != '' and $cWidth != '' and  $width &lt; $cWidth * 0.8">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1086" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 1087: If preliminaryItemStatusCode does not equal 'PRELIMINARY' and if the Document Command is equal to 'CHANGE_BY_REFRESH' then  TradeItemMeasurements/depth shall not be less than 80 percent of the current version depth.-->
				<xsl:if test="$depth != '' and $cDepth != '' and  $depth &lt; $cDepth * 0.8">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1087" />
					</xsl:apply-templates>
				</xsl:if>
				<!--Rule 1088: If preliminaryItemStatusCode does not equal 'PRELIMINARY' and if the Document Command is equal to 'CHANGE_BY_REFRESH' then TradeItemMeasurements/grossWeight shall not be less than 80 percent of the current version grossWeight.-->
				<xsl:if test="$grossWeight != '' and $cGrossWeight != '' and  $grossWeight &lt; $cGrossWeight * 0.8">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1088" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>

			<!--Rule 1122: udidFirstPublicationDateTime when first populated or changed shall be today's date or in the future.-->
			<xsl:if test="gs1:InvalidDateTimeSpan(gs1:Today(), tradeItemSynchronisationDates/udidFirstPublicationDateTime)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1122" />
				</xsl:apply-templates>
			</xsl:if>

			<!--Rule 1123: udidFirstPublicationDateTime shall not be changed once the current populated date has been reached.-->
			<xsl:if test="gs1:InvalidDateTimeSpan(gs1:Today(), $tradeItem/tradeItemSynchronisationDates/udidFirstPublicationDateTime)">
				<xsl:if test="tradeItemSynchronisationDates/udidFirstPublicationDateTime != $tradeItem/tradeItemSynchronisationDates/udidFirstPublicationDateTime">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1123" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>


			<!--Rule 1290: If targetMarketCountryCode does not equal (036 (Australia), 554 (New Zealand)) and if preliminaryItemStatusCode changes from  'PRELIMINARY' to 'FINAL' and Document Command is equal to CHANGE_BY_REFRESH, then the lastChangeDateTime must be less than or equal to the firstShipDateTime.-->
			<xsl:if test="$targetMarket != '036' and $targetMarket != '554'">
				<xsl:if test="$tradeItem/preliminaryItemStatusCode = 'PRELIMINARY' and preliminaryItemStatusCode = 'FINAL'">
					<xsl:if test="$command = 'CHANGE_BY_REFRESH'">
						<xsl:if test="gs1:InvalidDateTimeSpan(tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:delivery_purchasing_information:xsd:3' and local-name()='deliveryPurchasingInformationModule']/deliveryPurchasingInformation/firstShipDateTime, tradeItemSynchronisationDates/lastChangeDateTime)">
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="1290" />
							</xsl:apply-templates>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:if>

			<xsl:if test="$command != 'CORRECT'">
				<xsl:if test="tradeItemSynchronisationDates/discontinuedDateTime != $tradeItem/tradeItemSynchronisationDates/discontinuedDateTime">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="485"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="transaction" mode="r493">
		<!--Rule 493: There must be at most 1000 transactions per message.-->
		<xsl:apply-templates select="gs1:BeginTransaction(transactionIdentification/entityIdentification)"/>
		<xsl:apply-templates select="gs1:AddErrorEvent('493')" />
		<xsl:apply-templates select="gs1:EndTransaction()"/>
	</xsl:template>

	<xsl:template match="*" mode="r504">
		<!--Rule 504: There shall be at most 25 iterations of Class GDSNTradeItemClassificationAttribute per Class GDSNTradeItemClassification.-->
		<xsl:variable name="xpath" select="gDSNTradeItemClassification" />
		<xsl:if test="count($xpath/gDSNTradeItemClassificationAttribute) &gt; 25">
			<xsl:apply-templates select="$xpath" mode="error">
				<xsl:with-param name="id" select="504"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r510">
		<!--Rule 510: If isTradeItemNonPhysical equals 'false' or is not used then tradeItemMeasurements/depth SHALL be greater than 0.-->
		<xsl:if test="isTradeItemNonphysical != 'true'">
			<xsl:if test="count(tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements[depth &gt; 0]) != 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="510" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r511">
		<!--Rule 511: If isTradeItemNonPhysical equals 'false' or is not used then tradeItemMeasurements/height SHALL be greater than 0.-->
		<xsl:if test="isTradeItemNonphysical != 'true'">
			<xsl:if test="count(tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements[height &gt; 0]) != 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="511" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r512">
		<!--Rule 512: If isTradeItemNonPhysical equals 'false' or is not used then tradeItemMeasurements/width SHALL be greater than 0.-->
		<xsl:if test="isTradeItemNonphysical != 'true'">
			<xsl:if test="count(tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements[width &gt; 0]) != 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="512" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r517">
		<xsl:param name="targetMarket" />
		<!--Rule 517: If targetMarketCountryCode not equal to '752' (Sweden) and (Audio Visual Media Product Description Module or Publication Title Rating Module or Audio Visual Media Content Information Module) are used and gpcCategoryCode is equal to '10001137' then audioVisualMediaProductTitle, genreTypeCodeReference, titleRatingCodeReference/Code, titleRatingCodeReference/codeListAgencyCode and gameFormatCode shall be used.-->
		<xsl:if test="$targetMarket != '752'">
			<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode"/>
			<xsl:if test="$brick = '10001137'">
				<xsl:variable name="mod1" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:audio_visual_media_product_description_information:xsd:3' and local-name()='audioVisualMediaProductDescriptionInformationModule']"/>
				<xsl:variable name="mod2" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:audio_visual_media_content_information:xsd:3' and local-name()='audioVisualMediaContentInformationModule']"/>
				<xsl:variable name="mod3" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:publication_title_rating:xsd:3' and local-name()='publicationTitleRatingModule']"/>
				<xsl:if test="$mod1 or $mod2 or $mod3">

					<xsl:variable name="audioVisualMediaProductTitle" select="$mod1/audioVisualMediaProductDescription/audioVisualMediaProductTitle != ''"/>
					<xsl:variable name="genreTypeCodeReference" select="$mod1/audioVisualMediaProductDescription/genreTypeCodeReference[text() != '']"/>
					<xsl:variable name="gameFormatCode" select="$mod2/audioVisualMediaContentInformation/gameFormatCode[text() != '']"/>
					<xsl:variable name="titleRatingCodeReference" select="$mod3/publicationTitleRating/titleRatingCodeReference[text() != '' and @codeListAgencyCode != '']"/>
					<xsl:choose>
						<xsl:when test="$audioVisualMediaProductTitle and $genreTypeCodeReference and $gameFormatCode and $titleRatingCodeReference"/>
						<xsl:otherwise>
							<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_BRICK, $brick)"/>
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="517" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:if>
			</xsl:if>
		</xsl:if>

	</xsl:template>

	<xsl:template match="*" mode="r521">
		<xsl:param name="targetMarket" />
		<!--Rule 521: If targetMarketCountryCode is equal to '752' (Sweden) and isTradeItemOrderable is equal to 'true'  and additionalTradeItemIdentificationTypeCode  is equal to ('SUPPLIER_ASSIGNED' or 'DISTRIBUTOR_ASSIGNED') then associated additionalTradeItemIdentification must be unique within hierarchy.-->
		<xsl:if test="$targetMarket = '752'">
			<xsl:variable name="root" select="."/>
			<xsl:for-each select="$root//tradeItem[isTradeItemAnOrderableUnit = 'true']">
				<xsl:for-each select="additionalTradeItemIdentification">
					<xsl:if test="@additionalTradeItemIdentificationTypeCode = 'SUPPLIER_ASSIGNED' or @additionalTradeItemIdentificationTypeCode = 'DISTRIBUTOR_ASSIGNED'">
						<xsl:variable name="code" select="."
						/>
						<xsl:if test="count($root//tradeItem/additionalTradeItemIdentification[text() = $code]) &gt; 1">
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="521" />
							</xsl:apply-templates>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r524">
		<xsl:param name="targetMarket" />
		<!--Rule 524: If targetMarketCountryCode equals <Geographic> and isTradeItemAConsumerUnit equals 'true' then netContent SHALL be used..-->
		<xsl:if test="isTradeItemAConsumerUnit = 'true'">
			<xsl:if test="contains('036, 203, 208, 246, 250, 348, 352, 380, 554, 703, 752, 840, 124', $targetMarket)">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements/netContent = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="524" />
					</xsl:apply-templates>

				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r528">
		<xsl:param name="targetMarket" />
		<!--Rule 528: If targetMarketCountryCode is equal to '036' (Australia) and dutyFeeTaxTypeCode is equal to 'WET' then percentageOfAlcoholByVolume must not be empty.-->
		<xsl:if test="$targetMarket= '036'">
			<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:duty_fee_tax_information:xsd:3' and local-name()='dutyFeeTaxInformationModule']/dutyFeeTaxInformation/dutyFeeTaxTypeCode = 'WET'">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:alcohol_information:xsd:3' and local-name()='alcoholInformationModule']/alcoholInformation/percentageOfAlcoholByVolume = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="528" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r531">
		<xsl:param name="targetMarket" />
		<!--Rule 531: If targetMarketCountryCode equals ('752' (Sweden)) and isTradeItemAConsumerUnit is equal to 'true' then functionalName must not contain a value from brandName or descriptiveSizeDimension.-->
		<xsl:if test="$targetMarket = '752' and isTradeItemAConsumerUnit = 'true'">
			<xsl:variable name="mod" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']/tradeItemDescriptionInformation"/>
			<xsl:variable name="functionalName" select="$mod/functionalName"/>
			<xsl:if test="$functionalName != ''">
				<xsl:variable name="brand" select="$mod/brandNameInformation/brandName"/>
				<xsl:variable name="size" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_size:xsd:3' and local-name()='tradeItemSizeModule']/nonPackagedSizeDimension/descriptiveSizeDimension"/>
				<xsl:choose>
					<xsl:when test="$brand != '' and contains($functionalName, $brand)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="531" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$size != '' and contains($functionalName, $size)">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="531" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r533">
		<xsl:param name="targetMarket" />
		<!--Rule 533: If targetMarketCountryCode equals '528' (Netherlands) and gpcCategoryCode does not equal class then dutyFeeTaxCategoryCode shall be used.-->
		<xsl:if test="$targetMarket = '528'">
			<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode"/>
			<xsl:choose>
				<xsl:when test ="contains('10000458,10000570,10000686,10000915,10000456,10000457,10000681,10000912,10000922,10000448,10000449,10000450,10000451,10000684,10000908,10000909,10000910,10000474,10000488,10000489,10000685,10000907,10000459,10000682,10000690,10000487,10000525,10000526,10000527,10000528,10000529,10000637,10000638,10000639,10000687,10000688,10000689,10000911,10000500,10000504,10000683,10000846,10000847,10000848,10000849,10000850,10000851,10000852,10000923,10000853,10000854,10000855,10000856,10000857,10000858,10000859,10000860,10000861,10000862,10000914,10000863,10000864,10000865,10000866,10000867,10000868,10000869,10000870,10000871,10000872,10000873,10000874,10000919,10000875,10000876,10000877,10000878,10000879,10000880,10000881,10000882,10000883,10000884,10000916,10000920,10000885,10000886,10000887,10000888,10000889,10000890,10000891,10000892,10000893,10000903,10000904,10000905,10000906,10000894,10000895,10000896,10000897,10000898,10000899,10000900,10000901,10000902,10000921,10002423,10000460,10000461,10000462,10000674,10000838,10000463,10000464,10000675,10000455,10000843,10000452,10000453,10000454,10000648,10000844,10000647,10000673,10005844,10006412,10005845,10000514', $brick)"/>
				<xsl:otherwise>
					<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:duty_fee_tax_information:xsd:3' and local-name()='dutyFeeTaxInformationModule']/dutyFeeTaxInformation/dutyFeeTax/dutyFeeTaxCategoryCode = ''">
						<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_BRICK, $brick)"/>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="533" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r549">
		<!--Rule 549: If isTradeItemNonphysical equals 'false' or is not used then tradeItemWeight/grossWeight SHALL be greater than 0.-->
		<xsl:if test="isTradeItemNonphysical != 'true'">
			<xsl:variable name="grossWeight" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_measurements:xsd:3' and local-name()='tradeItemMeasurementsModule']/tradeItemMeasurements/tradeItemWeight/grossWeight"/>
			<xsl:if test="$grossWeight = '' or $grossWeight &lt;= 0">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="549" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r554">
		<!--Rule 554: If tradeItemUnitDescriptorCode is equal to 'TRANSPORT_LOAD'  and parent item exists then parent item tradeItemUnitDescriptorCode must equal 'TRANSPORT_LOAD'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'TRANSPORT_LOAD'">
			<xsl:variable name="parent" select="../../../tradeItem"/>
			<xsl:if test="$parent">
				<xsl:choose>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode != 'TRANSPORT_LOAD'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="554" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r555">
		<!--Rule 555: If tradeItemUnitDescriptorCode is equal to 'PALLET' and parent item exists then parent item tradeItemUnitDescriptorCode must equal 'TRANSPORT_LOAD' or 'PALLET'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'PALLET'">
			<xsl:variable name="parent" select="../../../tradeItem"/>
			<xsl:if test="$parent">
				<xsl:choose>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'TRANSPORT_LOAD'"/>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'PALLET'"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="555" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r557">
		<!--Rule 557: If tradeItemUnitDescriptorCode is equal to 'PALLET' then child item tradeItemUnitDescriptorCode must not equal 'TRANSPORT_LOAD' .-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'PALLET'">
			<xsl:for-each select="catalogueItemChildItemLink/catalogueItem/tradeItem">
				<xsl:choose>
					<xsl:when test="tradeItemUnitDescriptorCode = 'TRANSPORT_LOAD'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="557" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r558">
		<!--Rule 558: If tradeItemUnitDescriptorCode is equal to 'CASE' then parent item tradeItemUnitDescriptorCode must not equal 'BASE_UNIT_OR_EACH' or 'PACK_OR_INNERPACK'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'CASE'">
			<xsl:variable name="parent" select="../../../tradeItem"/>
			<xsl:if test="$parent">
				<xsl:choose>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="558" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'PACK_OR_INNERPACK'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="558" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r559">
		<!--Rule 559: If tradeItemUnitDescriptorCode is equal to 'CASE' then child item tradeItemUnitDescriptorCode must not equal 'TRANSPORT_LOAD', 'MIXED_MODULE' or ' PALLET'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'CASE'">
			<xsl:for-each select="catalogueItemChildItemLink/catalogueItem/tradeItem">
				<xsl:choose>
					<xsl:when test="tradeItemUnitDescriptorCode = 'TRANSPORT_LOAD'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="559" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="tradeItemUnitDescriptorCode = 'MIXED_MODULE'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="559" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="tradeItemUnitDescriptorCode = 'PALLET'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="559" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r560">
		<!--Rule 560: If tradeItemUnitDescriptorCode is equal to 'PACK_OR_INNERPACK' then parent item tradeItemUnitDescriptorCode must not equal 'BASE_UNIT_OR_EACH'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'PACK_OR_INNERPACK'">
			<xsl:variable name="parent" select="../../../tradeItem"/>
			<xsl:if test="$parent">
				<xsl:choose>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="560" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r561">
		<!--Rule 561: If tradeItemUnitDescriptorCode is equal to 'PACK_OR_INNERPACK' then child item tradeItemUnitDescriptorCode must not equal 'TRANSPORT_LOAD', 'PALLET', 'MIXED_MODULE', 'DISPLAY_SHIPPER' or 'CASE'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'PACK_OR_INNERPACK'">
			<xsl:for-each select="catalogueItemChildItemLink/catalogueItem/tradeItem">
				<xsl:choose>
					<xsl:when test="tradeItemUnitDescriptorCode = 'TRANSPORT_LOAD'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="561" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="tradeItemUnitDescriptorCode = 'MIXED_MODULE'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="561" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="tradeItemUnitDescriptorCode = 'PALLET'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="561" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="tradeItemUnitDescriptorCode = 'DISPLAY_SHIPPER'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="561" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="tradeItemUnitDescriptorCode = 'CASE'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="561" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r565">
		<xsl:param name="targetMarket" />
		<!--Rule 565: If targetMarketCountryCode is equal to '752' (Sweden) and isTradeItemADespatchUnit is equal to 'true' then stackingFactor must not be empty.-->
		<xsl:if test="isTradeItemADespatchUnit = 'true' and $targetMarket = '752'">
			<xsl:choose>
				<xsl:when test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_handling:xsd:3' and local-name()='tradeItemHandlingModule']/tradeItemHandlingInformation/tradeItemStacking/stackingFactor[text() != '']"/>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="565" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r572">
		<!--Rule 572: lastChangeDateTime must not be greater than current date.-->
		<xsl:if test="gs1:InvalidDateTimeSpan(tradeItemSynchronisationDates/lastChangeDateTime, gs1:TimeStamp())">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="572"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r575">
		<xsl:param name="targetMarket" />
		<!--Rule 575: If targetMarketCountryCode equals <Geographic> and isTradeItemAConsumerUnit equals 'true' and gpcCategoryCode is not in GPC Segment '51000000' then tradeItem/gtin SHALL not begin with values '1' to '9'.-->
		<xsl:if test="isTradeItemAConsumerUnit = 'true' and contains('056, 246, 442, 528', $targetMarket)">
			<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode"/>
			<xsl:if test="not(gs1:IsInSegment($brick, '51000000'))">
				<xsl:choose>
					<xsl:when test="gtin = ''"/>
					<xsl:when test="starts-with(gtin, '0')"/>
					<xsl:otherwise>
						<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_BRICK, $brick)"/>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="575" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r590">
		<xsl:param name="targetMarket" />
		<!--Rule 590: If targetMarketCountryCode equals ('250' (France), '246' (Finland) or '380' (Italy)) then tradeItemDescription shall be used. -->
		<xsl:if test="contains('250, 380, 246', $targetMarket)">
			<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']/tradeItemDescriptionInformation/tradeItemDescription = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="590" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r594">
		<xsl:param name="targetMarket" />
		<!--Rule 594: If targetMarketCountryCode does not equal ('036' (Australia) or '554' (New Zealand) or 752 (Sweden)) and tradeItemUnitDescriptor is equal to 'PALLET' or 'MIXED_MODULE' then platformTypeCode  shall not be empty-->
		<xsl:if test="$targetMarket != '036' and $targetMarket != '554' and $targetMarket != '752'">
			<xsl:if test="tradeItemUnitDescriptorCode = 'PALLET' or tradeItemUnitDescriptorCode ='MIXED_MODULE'">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:packaging_information:xsd:3' and local-name()='packagingInformationModule']/packaging/platformTypeCode = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="594" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r598">
		<xsl:param name="targetMarket" />
		<!--Rule 598: If targetMarketCountryCode equals '250' (France) and tradeItemUnitDescriptorCode equals 'BASE_UNIT_OR_EACH' then placeOfProductActivity/countryOfOrigin shall not be empty.-->
		<xsl:if test="$targetMarket= '250'">
			<xsl:if test="tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH'">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:place_of_item_activity:xsd:3' and local-name()='placeOfItemActivityModule']/placeOfProductActivity/countryOfOrigin/countryCode = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="598" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r603">
		<xsl:param name="targetMarket" />
		<!--Rule 603: If targetMarketCountryCode equals '250' (France) then dutyFeeTaxAgencyCode, if used, shall equal  '65'.-->
		<xsl:if test="$targetMarket= '250'">
			<xsl:variable name="code" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:duty_fee_tax_information:xsd:3' and local-name()='dutyFeeTaxInformationModule']/dutyFeeTaxInformation/dutyFeeTaxAgencyCode"/>
			<xsl:if test="$code != '' and $code != '65'">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="603" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r617">
		<!--Rule 617: If childTradeItem/tradeItemIdentification is used then quantityOfNextLowerLevelTradeItem shall be greater than '0'.-->
		<xsl:for-each select="nextLowerLevelTradeItemInformation/childTradeItem">
			<xsl:if test="gtin != ''">
				<xsl:if test="quantityOfNextLowerLevelTradeItem = '' or quantityOfNextLowerLevelTradeItem &lt; 0">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="617" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="r618">
		<xsl:param name="targetMarket" />
		<!--Rule 618: If targetMarketCountryCode equals '250' (France)) and (gpcCategoryCode is in Class '50202200' and does not equal '10000142') and isTradeItemAConsumerUnit equals 'true' then at least one iteration of dutyFeeTaxTypeCode shall equal ('3001000002541', '3001000002244', '3001000002312' or '3001000002329').-->
		<xsl:if test="$targetMarket = '250'">
			<xsl:if test="isTradeItemAConsumerUnit = 'true'">
				<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode"/>
				<xsl:if test="$brick != '10000142'">
					<xsl:if test="gs1:IsInClass($brick, '50202200')">
						<xsl:choose>
							<xsl:when test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:duty_fee_tax_information:xsd:3' and local-name()='dutyFeeTaxInformationModule']/dutyFeeTaxInformation[dutyFeeTaxTypeCode = '3001000002541' or dutyFeeTaxTypeCode = '3001000002244' or dutyFeeTaxTypeCode = '3001000002312' or dutyFeeTaxTypeCode = '3001000002329'] "/>
							<xsl:otherwise>
								<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_BRICK, $brick)"/>
								<xsl:apply-templates select="." mode="error">
									<xsl:with-param name="id" select="618" />
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r631">
		<xsl:param name="targetMarket" />
		<!--Rule 631: If targetMarketCountryCode equals '372' (Ireland) and if isTradeItemABaseUnit equals 'true' and ((gpcCategoryCode is in Class ('50202200' or '50211500') and does not equal ('10000142', '10000143', '10000303' or '10000584')) then at least one iteration of AdditionalTradeItemClassification shall have a value with additionalTradeItemClassificationSystemCode equal to '57'(REV).-->
		<xsl:if test="$targetMarket = '372' and isTradeItemABaseUnit = 'true'">
			<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode"/>
			<xsl:choose>
				<xsl:when test="$brick = '10000142'"/>
				<xsl:when test="$brick = '10000143'"/>
				<xsl:when test="$brick = '10000303'"/>
				<xsl:when test="$brick = '10000584'"/>
				<xsl:otherwise>
					<xsl:if test="gs1:IsInClass($brick, '50202200') or gs1:IsInClass($brick, '50211500')">
						<xsl:choose>
							<xsl:when test="gDSNTradeItemClassification/additionalTradeItemClassification[additionalTradeItemClassificationSystemCode = '57']"/>
							<xsl:otherwise>
								<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_BRICK, $brick)"/>
								<xsl:apply-templates select="." mode="error">
									<xsl:with-param name="id" select="631" />
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r635">
		<!--Rule 635: discontinuedDateTime shall not be older than effectiveDateTime minus six months.-->
		<xsl:if test="tradeItemSynchronisationDates/discontinuedDateTime != '' and tradeItemSynchronisationDates/effectiveDateTime != ''">
			<xsl:variable name="date" select="gs1:AddMonths(tradeItemSynchronisationDates/effectiveDateTime, -6)"/>
			<xsl:if test="gs1:InvalidDateTimeSpan($date, tradeItemSynchronisationDates/discontinuedDateTime)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="635" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r636">
		<xsl:if test="referencedTradeItem">
			<xsl:variable name="gtin" select="gtin"/>
			<xsl:if test="$gtin != ''">
				<xsl:for-each select="referencedTradeItem[gtin = $gtin]">
					<xsl:choose>
						<xsl:when test="referencedTradeItemTypeCode = 'REPLACED_BY'">
							<!--Rule 636: Replaced By Trade Item (referencedTradeItemTypeCode equals 'REPLACED_BY')  shall not equal TradeItem/ tradeItemIdentification.-->
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="636" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="referencedTradeItemTypeCode = 'SUBSTITUTED_BY'">
							<!--Rule 637: Substituted By Trade Item (referencedTradeItemTypeCode equals 'SUBSTITUTED_BY') shall not equal TradeItem/tradeItemIdentification.-->
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="637" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="referencedTradeItemTypeCode = 'EQUIVALENT'">
							<!--Rule 638: equivalentTradeItem (referencedTradeItemTypeCode equals 'EQUIVALENT') shall not equal TradeItem/tradeItemIdentification.-->
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="638" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="referencedTradeItemTypeCode = 'DEPENDENT_PROPRIETARY'">
							<!--Rule 639: Dependent Proprietary Trade Item (referencedTradeItemTypeCode equals 'DEPENDENT_PROPRIETARY') shall not equal TradeItem/tradeItemIdentification.-->
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="639" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="referencedTradeItemTypeCode = 'ITEM_VARIANT_MASTER'">
							<!--Rule 640: Item Variant Master (referencedTradeItemTypeCode equals 'ITEM_VARIANT_MASTER') shall not equal TradeItem/tradeItemIdentification.-->
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="640" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="referencedTradeItemTypeCode = 'REPLACED'">
							<!--Rule 641: Replaced Trade Item Identification (referencedTradeItemTypeCode equals 'REPLACED') shall not equal TradeItem/tradeItemIdentification.-->
							<xsl:apply-templates select="." mode="error">
								<xsl:with-param name="id" select="641" />
							</xsl:apply-templates>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r642">
		<xsl:param name="targetMarket" />
		<!--Rule 642: If isTradeItemAConsumerUnit is equal to 'true' and targetMarketCountryCode is equal to '840'(United States) then dataCarrierTypeCode must not be empty..-->
		<xsl:if test="$targetMarket = '840'">
			<xsl:if test="isTradeItemAConsumerUnit = 'true'">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_data_carrier_and_identification:xsd:3' and local-name()='tradeItemDataCarrierAndIdentificationModule']/dataCarrier/dataCarrierTypeCode = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="642" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1000">
		<!--Rule 1000: There shall be one instance of TradeItem/informationProviderOfTradeItem/gln.-->
		<xsl:if test="count(informationProviderOfTradeItem/gln) != 1">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1000" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1001">
		<!--Rule 1001: TradeItem/informationProviderOfTradeItem/partyName shall be used.-->
		<xsl:if test="informationProviderOfTradeItem/partyName = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1001" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1004">
		<!--Rule 1004: startAvailabilityDateTime must not be empty.-->
		<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:delivery_purchasing_information:xsd:3' and local-name()='deliveryPurchasingInformationModule']/deliveryPurchasingInformation/startAvailabilityDateTime = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1004" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1008">
		<xsl:param name="targetMarket" />
		<!--Rule 1008: If targetMarketCountryCode does NOT equal <Geographic> then isTradeItemAConsumerUnit SHALL be used.-->
		<xsl:choose>
			<xsl:when test="contains('040, 056, 203, 208, 246, 276, 372, 442, 528, 703, 752, 756, 826', $targetMarket)"/>
			<xsl:otherwise>
				<xsl:if test="isTradeItemAConsumerUnit = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1008" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="r1010">
		<!--Rule 1010: isTradeItemADespatchUnit must not be empty.-->
		<xsl:if test="isTradeItemADespatchUnit = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1010" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1012">
		<!--Rule 1012: isTradeItemAnOrderableUnit must not be empty.-->
		<xsl:if test="isTradeItemAnOrderableUnit = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1012" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1018">
		<!--Rule 1018: targetMarket for a child item cannot be more specific than for the parent. Example: If parent item targetmarketCountryCode is equal to '840' then child item cannot have a targetMarketSubdivisonCode.-->
		<xsl:if test="targetMarket/targetMarketCountryCode">
			<xsl:for-each select="catalogueItemChildItemLink/catalogueItem/tradeItem">
				<xsl:if test="targetMarket/targetMarketSubdivisionCode">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1018" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1038">
		<!--Rule 1038: discontinuedDateTime and cancelledDateTime shall not be used simultaneously .-->
		<xsl:if test="tradeItemSynchronisationDates/cancelledDateTime != '' and tradeItemSynchronisationDates/discontinuedDateTime != ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1038" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1045">
		<!--Rule 1045: There must be at most one iteration per languageCode.-->
		<xsl:choose>
			<xsl:when test="@languageCode">
				<xsl:variable name="name" select="name()"/>
				<xsl:variable name="languageCode" select="@languageCode"/>
				<xsl:if test="count(../*[name() = $name and @languageCode = $languageCode]) &gt; 1">
					<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_LANGUAGE, $languageCode)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1045" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*" mode="r1045"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="r1049">
		<!--Rule 1049: There must be at most one iteration per Unit Of Measurement.-->
		<xsl:choose>
			<xsl:when test="@measurementUnitCode">
				<xsl:variable name="name" select="name()"/>
				<xsl:variable name="measurementUnitCode" select="@measurementUnitCode"/>
				<xsl:if test="count(../*[name() = $name and @measurementUnitCode = $measurementUnitCode]) &gt; 1">
					<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_MEASUREMENT_UNIT, $measurementUnitCode)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1049" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@temperatureMeasurementUnitCode">
				<xsl:variable name="name" select="name()"/>
				<xsl:variable name="measurementUnitCode" select="@temperatureMeasurementUnitCode"/>
				<xsl:if test="count(../*[name() = $name and @temperatureMeasurementUnitCode = $measurementUnitCode]) &gt; 1">
					<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_MEASUREMENT_UNIT, $measurementUnitCode)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1049" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@currencyCode">
				<xsl:variable name="name" select="name()"/>
				<xsl:variable name="measurementUnitCode" select="@currencyCode"/>
				<xsl:if test="count(../*[name() = $name and @currencyCode = $measurementUnitCode]) &gt; 1">
					<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_MEASUREMENT_UNIT, $measurementUnitCode)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1049" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@timeMeasurementUnitCode">
				<xsl:variable name="name" select="name()"/>
				<xsl:variable name="measurementUnitCode" select="@timeMeasurementUnitCode"/>
				<xsl:if test="count(../*[name() = $name and @timeMeasurementUnitCode = $measurementUnitCode]) &gt; 1">
					<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_MEASUREMENT_UNIT, $measurementUnitCode)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1049" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@transactionalMeasurementUnitCode">
				<xsl:variable name="name" select="name()"/>
				<xsl:variable name="measurementUnitCode" select="@transactionalMeasurementUnitCode"/>
				<xsl:if test="count(../*[name() = $name and @transactionalMeasurementUnitCode = $measurementUnitCode]) &gt; 1">
					<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_MEASUREMENT_UNIT, $measurementUnitCode)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1049" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@bitternessOfBeerMeasurementUnitCode">
				<xsl:variable name="name" select="name()"/>
				<xsl:variable name="measurementUnitCode" select="@bitternessOfBeerMeasurementUnitCode"/>
				<xsl:if test="count(../*[name() = $name and @bitternessOfBeerMeasurementUnitCode = $measurementUnitCode]) &gt; 1">
					<xsl:apply-templates select="gs1:AddEventData($EVENT_DATA_MEASUREMENT_UNIT, $measurementUnitCode)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1049" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*" mode="r1049"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="r1039">
		<!--Rule 1039: If additionalTradeItemIdentificationTypeCode  is equal to 'GTIN_13' then associated additionalTradeItemIdentification value must have 13 digits and must have a valid check digit.-->
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
		<xsl:for-each select="referencedTradeItem/additionalTradeItemIdentification">
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
		<xsl:for-each select="nextLowerLevelTradeItemInformation/childTradeItem/additionalTradeItemIdentification">
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
	</xsl:template>

	<xsl:template match="*" mode="r1061">
		<!--Rule 1061: The maximumlength of datatype StringAttributeValuePair is 5000 characters.-->
		<xsl:choose>
			<xsl:when test="avpList">
				<xsl:for-each select="stringAVP">
					<xsl:if test="string-length(.) &gt; 5000">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1061" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*" mode="r1061"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="r1078">
		<!--Rule 1078: If TradeItem/brandOwner/gln is not empty then brandOwner/PartyRoleCode shall be empty.-->
		<xsl:if test="brandOwner/gln != ''">
			<xsl:if test="brandOwner[partyRoleCode != '']">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1078" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1079">
		<!--Rule 1079: If TradeItem/informationProviderOfTradeItem/gln is used then TradeItem/informationProviderOfTradeItem/partyRoleCode shall be empty.-->
		<xsl:if test="informationProviderOfTradeItem/gln != ''">
			<xsl:if test="informationProviderOfTradeItem[partyRoleCode != '']">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1079" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1080">
		<!--Rule 1080: If TradeItem/manufacturerOfTradeItem/gln and/or TradeItem/manufacturerOfTradeItem/partyName is used then manufacturerOfTradeItem/partyRoleCode shall be empty.-->
		<xsl:if test="manufacturerOfTradeItem/gln != '' or manufacturerOfTradeItem/partyName != ''">
			<xsl:if test="manufacturerOfTradeItem[partyRoleCode != '']">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1080" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1089">
		<!--Rule 1089: If any attribute in class catalogueItem/tradeItem/PartyInRole is used then catalogueItem/tradeItem/PartyInRole/partyRoleCode SHALL be used.-->
		<xsl:for-each select="partyInRole">
			<xsl:if test="partyRoleCode = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1089" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="r1092">
		<xsl:param name="targetMarket" />
		<!--Rule 1092: If targetMarketCountryCode equals <Geographic> and (isTradeItemNonphysical equals 'false' or is not used) and (isTradeItemAService equals 'false' or is not used) and (one iteration of tradeItemTradeChannelCode equals to ('CASH_AND_CARRY', 'CONSIGNMENT', 'CONVENIENCE', 'DRUG_STORE', 'FOOD_SERVICE', 'GROCERY',  'ONLINE' or 'UNSPECIFIED') or tradeItemTradeChannelCode is not used) then isTradeItemADespatchUnit SHALL equal 'true' for at least one trade item in the item hierarchy.-->
		<xsl:if test="$targetMarket = '250'">
			<xsl:variable name="tradeItems" select=".//tradeItem"/>
			<xsl:if test="not($tradeItems[isTradeItemNonphysical != 'true' and isTradeItemAService !='true'])">
				<xsl:if test="$tradeItems[tradeItemTradeChannelCode= 'CASH_AND_CARRY' or tradeItemTradeChannelCode= 'CONSIGNMENT' or tradeItemTradeChannelCode= 'CONVENIENCE' or tradeItemTradeChannelCode= 'DRUG_STORE' or tradeItemTradeChannelCode= 'FOOD_SERVICE' or tradeItemTradeChannelCode= 'GROCERY' or tradeItemTradeChannelCode= 'ONLINE' or tradeItemTradeChannelCode= 'UNSPECIFIED']">
					<xsl:if test="count($tradeItems[isTradeItemADespatchUnit = 'true'])  = 0">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1092" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1160">
		<xsl:param name="targetMarket" />
		<!--Rule 1160: If targetMarketCountryCode equals ('249' (France) or '250' (France)) and isTradeItemAConsumerUnit equals 'TRUE' then descriptionShort shall be used.-->
		<xsl:if test="isTradeItemAConsumerUnit = 'true' and ($targetMarket = '249' or $targetMarket = '250')">
			<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']/tradeItemDescriptionInformation/descriptionShort = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1160" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1161">
		<xsl:param name="targetMarket" />
		<!--Rule 1161: If targetMarketCountryCode equals ('249' (France) or '250' (France)) then tradeItemDescriptionInformation/tradeItemDescription shall be used.-->
		<xsl:if test="$targetMarket = '249' or $targetMarket = '250'">
			<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']/tradeItemDescriptionInformation/tradeItemDescription = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1161" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1167">
		<!--Rule 1167: If isTradeItemNonPhysical is not equal to 'true' then tradeItemUnitDescriptor must not be empty.-->
		<xsl:if test="isTradeItemNonphysical != 'true' and tradeItemUnitDescriptorCode = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1167" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1168">
		<!--Rule 1168: There must be at most 1 iteration of referencedTradeItem/GTIN where  referencedTradeItemTypeCode equals 'ITEM_VARIANT_MASTER'-->
		<xsl:if test="count(referencedTradeItem[referencedTradeItemTypeCode = 'ITEM_VARIANT_MASTER']) &gt; 1">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1168" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1176">
		<!--Rule 1176: There must be at most 1 iteration of referencedTradeItem/GTIN where  referencedTradeItemTypeCode equals 'PREFERRED'-->
		<xsl:if test="count(referencedTradeItem[referencedTradeItemTypeCode = 'PREFERRED']) &gt; 1">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1176" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1277">
		<!--Rule 1277: If tradeItemUnitDescriptorCode is equal to 'MIXED_MODULE' and parent item exists then parent item tradeItemUnitDescriptorCode must equal 'TRANSPORT_LOAD', 'PALLET', or 'MIXED_MODULE'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'MIXED_MODULE'">
			<xsl:variable name="parent" select="../../../tradeItem"/>
			<xsl:if test="$parent">
				<xsl:choose>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'TRANSPORT_LOAD'"/>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'PALLET'"/>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'MIXED_MODULE'"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1277" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1278">
		<!--Rule 1278: If tradeItemUnitDescriptorCode is equal to 'MIXED_MODULE' then child item tradeItemUnitDescriptorCode must not equal 'TRANSPORT_LOAD' .-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'MIXED_MODULE'">
			<xsl:for-each select="catalogueItemChildItemLink/catalogueItem/tradeItem">
				<xsl:choose>
					<xsl:when test="tradeItemUnitDescriptorCode = 'TRANSPORT_LOAD'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1278" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1279">
		<!--Rule 1279: If tradeItemUnitDescriptorCode equals 'DISPLAY_SHIPPER' then parent item tradeItemUnitDescriptorCode shall not equal 'BASE_UNIT_OR_EACH' or 'PACK_OR_INNER_PACK'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'DISPLAY_SHIPPER'">
			<xsl:variable name="parent" select="../../../tradeItem"/>
			<xsl:if test="$parent">
				<xsl:choose>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1279" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$parent/tradeItemUnitDescriptorCode = 'PACK_OR_INNER_PACK'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1279" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1280">
		<!--Rule 1280: If tradeItemUnitDescriptorCode is equal to 'DISPLAY_SHIPPER' then child item tradeItemUnitDescriptorCode must not equal 'TRANSPORT_LOAD', 'MIXED_MODULE' or ' PALLET'.-->
		<xsl:if test="tradeItemUnitDescriptorCode = 'MIXED_MODULE'">
			<xsl:for-each select="catalogueItemChildItemLink/catalogueItem/tradeItem">
				<xsl:choose>
					<xsl:when test="tradeItemUnitDescriptorCode = 'TRANSPORT_LOAD' or tradeItemUnitDescriptorCode = 'MIXED_MODULE' or tradeItemUnitDescriptorCode = 'PALLET'">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1280" />
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1283">
		<!--Rule 1283: effectiveDateTime must not be empty-->
		<xsl:if test="tradeItemSynchronisationDates/effectiveDateTime = ''">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1283" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1288">
		<xsl:param name="targetMarket" />
		<!--Rule 1288: If targetMarketCountryCode does not equal (036 (Australia), 554 (New Zealand)) and If preliminaryItemStatusCode is equal to 'PRELIMINARY' or 'FINAL' then firstShipDateTime must not be empty. -->
		<xsl:if test="$targetMarket != '036' and $targetMarket != '554'">
			<xsl:if test="preliminaryItemStatusCode = 'PRELIMINARY' or preliminaryItemStatusCode = 'FINAL'">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:delivery_purchasing_information:xsd:3' and local-name()='deliveryPurchasingInformationModule']/deliveryPurchasingInformation/firstShipDateTime = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1288" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1291">
		<!--Rule 1291: If preliminaryItemStatusCode is equal to 'PRELIMINARY' then parent trade item preliminaryItemStatusCode must not equal 'FINAL'.-->
		<xsl:if test="preliminaryItemStatusCode = 'PRELIMINARY'">
			<xsl:variable name="parent" select="../../../tradeItem"/>
			<xsl:if test="$parent/preliminaryItemStatusCode = 'FINAL'">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1291" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1299">
		<xsl:param name="targetMarket" />
		<!--Rule 1299: If targetMarketCountryCode does not equal <Geographic> and any attribute in class brandOwner is used then brandOwner/gln SHALL be used.-->
		<xsl:choose>
			<xsl:when test="contains('036, 040, 276', $targetMarket)"/>
			<xsl:otherwise>
				<xsl:if test="brandOwner/*[name() != 'gln']">
					<xsl:if test="brandOwner/gln = ''">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1299" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="r1338">
		<!--Rule 1338: If gpcAttributeTypeCode is used then gpcAttributeValueCode shall be used.-->
		<xsl:for-each select="gDSNTradeItemClassification/gDSNTradeItemClassificationAttribute">
			<xsl:if test="gpcAttributeTypeCode != '' and gpcAttributeValueCode  =''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1338" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="r1419">
		<xsl:param name="targetMarket"/>
		<xsl:if test="$targetMarket = '752'">
			<!--Rule 1419: There must be one iteration for language 'Swedish'.-->
			<xsl:choose>
				<xsl:when test="@languageCode">
					<xsl:variable name="name" select="name()"/>
					<xsl:if test="count(../*[name() = $name and @languageCode = 'sv']) &lt; 1">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1419" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*" mode="r1419">
						<xsl:with-param name="targetMarket" select="$targetMarket"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1458">
		<xsl:param name="command"/>
		<!--Rule 1458: Catalogue Item Notification message shall not be sent using  transaction/documentCommand/documentCommandHeader/@type equal to 'DELETE'.-->
		<xsl:if test="$command = 'DELETE'">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1458" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1459">

		<xsl:for-each select="gDSNTradeItemClassification/additionalTradeItemClassification">
			<!--Rule 1459: if additionalTradeItemClassificationSystemCode is used then there shall be a corresponding additionalTradeItemClassificationCodeValue used-->
			<xsl:if test="additionalTradeItemClassificationSystemCode != '' and additionalTradeItemClassificationValue[additionalTradeItemClassificationCodeValue = '']">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1459" />
				</xsl:apply-templates>
			</xsl:if>
			<!--Rule 1460: if additionalTradeItemClassificationCodeValue is used then there shall be a corresponding additionalTradeItemClassificationSystemCode used-->
			<xsl:if test="additionalTradeItemClassificationSystemCode = '' and additionalTradeItemClassificationValue[additionalTradeItemClassificationCodeValue != '']">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1460" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="r1613">
		<xsl:param name="targetMarket" />
		<!--Rule 1613: If additionalTradeItemClassificationSystemCode equals '76' then additionalTradeItemClassificationCodeValue shall equal ('EU_CLASS_I',  'EU_CLASS_IIA', 'EU_CLASS_IIB', 'EU_CLASS_III', 'EU_CLASS_A', 'EU_CLASS_B', 'EU_CLASS_C', or 'EU_CLASS_D').-->
		<xsl:variable name="class" select="gDSNTradeItemClassification/additionalTradeItemClassification[additionalTradeItemClassificationSystemCode = '76']"/>
		<xsl:if test="$class">
			<xsl:if test="contains('008, 051, 031, 112, 056, 070, 040, 100, 191, 196, 203, 208, 233, 246, 250, 276, 268, 300, 348, 352, 372, 376, 380, 398, 417, 428, 440, 442, 807, 498, 499, 528, 578, 616, 620, 642, 643, 688, 703, 705, 724, 752, 756, 792, 795, 804, 860, 826', $targetMarket)">
				<xsl:choose>
					<xsl:when test="$class/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue = 'EU_CLASS_I'"/>
					<xsl:when test="$class/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue = 'EU_CLASS_IIA'"/>
					<xsl:when test="$class/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue = 'EU_CLASS_IIB'"/>
					<xsl:when test="$class/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue = 'EU_CLASS_III'"/>
					<xsl:when test="$class/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue = 'EU_CLASS_A'"/>
					<xsl:when test="$class/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue = 'EU_CLASS_B'"/>
					<xsl:when test="$class/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue = 'EU_CLASS_C'"/>
					<xsl:when test="$class/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue = 'EU_CLASS_D'"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="1613" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1639">
		<xsl:param name="targetMarket" />
		<!--Rule 1639: If targetMarketCountryCode equals '250' (France) and  isTradeItemABaseUnit equals 'true' and (gpcCategoryCode equals ('10000273' [- Wine – Fortified] or '10000275' [- Wine – Sparkling] or  '10000276' [- Wine – Still]) then isTradeItemAQualityVintageAlcoholProduct shall be used.-->
		<xsl:if test="$targetMarket = '250' and isTradeItemABaseUnit = 'true'">
			<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode"/>
			<xsl:if test="$brick = '10000276'">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:alcohol_information:xsd:3' and local-name()='alcoholInformationModule']/alcoholInformation/isTradeItemAQualityVintageAlcoholProduct = ''">
					<xsl:apply-templates select="gs1:AddEventData('brick', $brick)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1639" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1662">
		<xsl:param name="targetMarket" />
		<!--Rule 1662: If targetMarketCountryCode equals <Geographic> and gpcCategoryCode equals '10000159' and isTradeItemAConsumerUnit = 'true', then degreeOfOriginalWort SHALL be used.-->
		<xsl:if test="contains('056, 442, 528, 380, 203', $targetMarket) and isTradeItemAConsumerUnit = 'true'">
			<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode"/>
			<xsl:if test="$brick = '10000159'">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:alcohol_information:xsd:3' and local-name()='alcoholInformationModule']/alcoholInformation/degreeOfOriginalWort = ''">
					<xsl:apply-templates select="gs1:AddEventData('brick', $brick)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1662" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1684">
		<xsl:param name="targetMarket" />

		<xsl:if test="$targetMarket = '250' and tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH' and isTradeItemAConsumerUnit = 'true'">
			<xsl:variable name="brick" select="gDSNTradeItemClassification/gpcCategoryCode"/>
			<xsl:if test="gs1:IsInFamily($brick, '67010000, 63010000')">

				<!--Rule 1684: If targetMarketCountryCode equals ‘250’ (France) and gpcCategoryCode is in GPC Family ('67010000' (Clothing) or ‘63010000’ (Footwear)) and tradeItemUnitDescriptorCode equals ‘BASE_UNIT_OR_EACH’ and isTradeItemAConsumerUnit equals ‘true’ then at least one iteration of additionalTradeItemIdentification/@additionalTradeItemIdentificationTypeCode SHALL have the value ‘SUPPLIER_ASSIGNED’ -->
				<xsl:if test="count(additionalTradeItemIdentification[@additionalTradeItemIdentificationTypeCode ='SUPPLIER_ASSIGNED']) = 0">
					<xsl:apply-templates select="gs1:AddEventData('brick', $brick)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1684" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 1686: If targetMarketCountryCode equals ‘250’ (France) and gpcCategoryCode is in GPC Family ('67010000' (Clothing) or ‘63010000’ (Footwear)) and isTradeItemAConsumerUnit equals ‘true’ then additionalTradeItemDescription shall not be empty.-->
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']/tradeItemDescriptionInformation/additionalTradeItemDescription = ''">
					<xsl:apply-templates select="gs1:AddEventData('brick', $brick)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1686" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 1688: If targetMarketCountryCode equals ‘250’ (France) and gpcCategoryCode is in GPC Family ('67010000' (Clothing) or ‘63010000’ (Footwear)) and tradeItemUnitDescriptorCode equals ‘BASE_UNIT_OR_EACH’ and isTradeItemAConsumerUnit equals ‘true’ then one iteration of colourCode shall be provided.-->
				<xsl:if test="count(tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']/tradeItemDescriptionInformation/colour/colourCode) = 0">
					<xsl:apply-templates select="gs1:AddEventData('brick', $brick)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1688" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 1689: If targetMarketCountryCode equals ‘250’ (France) and gpcCategoryCode is in GPC Family ('67010000' (Clothing) or ‘63010000’ (Footwear)) and tradeItemUnitDescriptorCode equals ‘BASE_UNIT_OR_EACH’ and isTradeItemAConsumerUnit equals ‘true’ then colourFamilyCode shall be populated.-->
				<xsl:if test="count(tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:trade_item_description:xsd:3' and local-name()='tradeItemDescriptionModule']/tradeItemDescriptionInformation/colour/colourFamilyCode) = 0">
					<xsl:apply-templates select="gs1:AddEventData('brick', $brick)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1689" />
					</xsl:apply-templates>
				</xsl:if>

				<!--Rule 1690: If targetMarketCountryCode equals ‘250’ (France) and gpcCategoryCode is in GPC Family ('67010000' (Clothing) or ‘63010000’ (Footwear)) and tradeItemUnitDescriptorCode equals ‘BASE_UNIT_OR_EACH’ and isTradeItemAConsumerUnit equals ‘true’ then targetConsumerGender shall be provided .-->
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:marketing_information:xsd:3' and local-name()='marketingInformationModule']/marketingInformation/targetConsumer/targetConsumerGender = ''">
					<xsl:apply-templates select="gs1:AddEventData('brick', $brick)"/>
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1690" />
					</xsl:apply-templates>
				</xsl:if>

			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1692">
		<xsl:param name="targetMarket" />
		<!--Rule 1692: If (targetMarketCountryCode equals '056' (Belgium) or '528' (the Netherlands) or '442' (Luxembourg) ) and isTradeItemAConsumerUnit equals 'true', then one instance of importClassificationTypeCode SHALL be equal to 'INTRASTAT'.-->
		<xsl:if test="isTradeItemAConsumerUnit = 'true'">
			<xsl:if test="$targetMarket  = '056' or $targetMarket = '528' or $targetMarket = '442'">
				<xsl:if test="count(tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:place_of_item_activity:xsd:3' and local-name()='placeOfItemActivityModule']/importClassification[importClassificationTypeCode = 'INTRASTAT'])  = 0">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1692" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1695">
		<xsl:param name="targetMarket" />
		<!--Rule 1695: If targetMarketCountryCode equals ('250' (France)) then codes ('NON_EU' or 'D_A') cannot be used for any countryCode attribute.-->
		<xsl:if test="$targetMarket = '250'">
			<xsl:if test=".//@countryCode = 'NON_EU' or .//@countryCode = 'D_A'">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1695" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="r1697">
		<xsl:param name="targetMarket" />
		<!--Rule 1697: Code value 'NON_EU' (Non European Union) shall not be used -->
		<xsl:if test="$targetMarket = 'NON_EU'">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1697" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>


	<xsl:template match="*" mode="r2069">
		<xsl:param name="targetMarket"/>
		<xsl:if test="$targetMarket = '250'">
			<!--Rule 2069: There must be one iteration for language 'French'.-->
			<xsl:choose>
				<xsl:when test="@languageCode">
					<xsl:variable name="name" select="name()"/>
					<xsl:if test="count(../*[name() = $name and @languageCode = 'fr']) &lt; 1">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="2069" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*" mode="r2069">
						<xsl:with-param name="targetMarket" select="$targetMarket"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- endregion validation rules -->

	<xsl:template match="catalogueItem" mode="hierarchy_rules">
		<xsl:param name="targetMarket"/>
		<xsl:param name="informationProvider"/>
		<!--
		apply rules that evaluate the total hierarchy here. these will only be executed once 
		make sure that the rule is recursive if required
		-->
		<xsl:apply-templates select="." mode="r312"/>
		<xsl:apply-templates select="." mode="r521">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1092">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="tradeItem" mode="instance_rules">
		<xsl:param name="targetMarket"/>
		<xsl:param name="informationProvider"/>
		<xsl:param name="command"/>
		<!--
		apply default rules that apply to all tradeitems in the hierarchy.
		-->
		<xsl:apply-templates select="tradeItemInformation/extension/*" mode="module">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="."/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r96"/>
		<xsl:apply-templates select="." mode="r202"/>
		<xsl:apply-templates select="." mode="r203"/>
		<xsl:apply-templates select="." mode="r204"/>
		<xsl:apply-templates select="." mode="r325">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r382"/>
		<xsl:apply-templates select="." mode="r383"/>
		<xsl:apply-templates select="." mode="r454"/>
		<!-- Rule 455 == Rule 454: ChildTradeItem/gtin must not equal TradeItem/gtin -->
		<xsl:apply-templates select="." mode="r469">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r472"/>
		<xsl:apply-templates select="." mode="r474"/>
		<xsl:apply-templates select="." mode="r475">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="compare">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="informationProvider" select="$informationProvider"/>
			<xsl:with-param name="command" select="$command"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r504"/>
		<xsl:apply-templates select="." mode="r510"/>
		<xsl:apply-templates select="." mode="r511"/>
		<xsl:apply-templates select="." mode="r512"/>
		<xsl:apply-templates select="." mode="r517">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r521">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r524">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r528">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r531">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r533">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<!--Rule 541: If the datatype of an attribute references a code list managed by an external agency, then only values in this list shall be used.-->
		<!--Rule 542: If code list agency for a code attribute represents GS1 then only valid GS1 managed code list can be used.-->
		<xsl:apply-templates select="." mode="r549"/>
		<!--TODO? Rule 550: If specialItemCode does not equal 'DYNAMIC_ASSORTMENT' and grossWeight is used, then grossWeight SHALL be greater than 0.96 multiplied by the ((Parent trade Item packagingWeight if used) + (Sum of (Parent trade item quantityOfNextLowerLevelTradeItem multiplied by Child GTIN grossWeight))).-->
		<xsl:apply-templates select="." mode="r554"/>
		<xsl:apply-templates select="." mode="r555"/>
		<xsl:apply-templates select="." mode="r557"/>
		<xsl:apply-templates select="." mode="r558"/>
		<xsl:apply-templates select="." mode="r559"/>
		<xsl:apply-templates select="." mode="r560"/>
		<xsl:apply-templates select="." mode="r561"/>
		<xsl:apply-templates select="." mode="r565">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r572"/>
		<xsl:apply-templates select="." mode="r575">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r590">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r594">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r598">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r603">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r617"/>
		<xsl:apply-templates select="." mode="r618">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r631">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<!--NO SUCH ELEMENTS Rule 633: If targetMarketCountryCode does not equal <Geographic> and consumerProductVariantStartEffectiveDateTime is used then consumerProductVariantDescription SHALL be used.-->
		<xsl:apply-templates select="." mode="r635"/>
		<xsl:apply-templates select="." mode="r636"/>
		<xsl:apply-templates select="." mode="r642">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1000"/>
		<xsl:apply-templates select="." mode="r1001"/>
		<xsl:apply-templates select="." mode="r1004"/>
		<xsl:apply-templates select="." mode="r1008">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1010"/>
		<xsl:apply-templates select="." mode="r1012"/>
		<!--Rule 1013: isTradeItemAVariableUnit SHALL be used. MISSING CLASS INFO-->
		<xsl:apply-templates select="." mode="r1018"/>
		<!--Rule 1026: If TradeItemMeasurements/height is used then measurementUnitCode shall be from same measuring system across whole hierarchy.-->
		<!--Rule 1027: If TradeItemMeasurements/width is used then measurementUnitCode shall be from same measuring system across whole hierarchy.-->
		<!--Rule 1028: If TradeItemMeasurements/depth is used then measurementUnitCode shall be from same measuring system across whole hierarchy.-->
		<!--Rule 1029: If netWeight is used then measurementUnitCode shall be from same measuring system across whole hierarchy.-->
		<!--Rule 1030: If grossWeight  is used then measurementUnitCode shall be from same measuring system across whole hierarchy-->
		<!--Rule 1031: If packagingWeight is used then measurementUnitCode shall be from same measuring system across whole hierarchy.-->
		<!--Rule 1032: If drainedWeight is used then measurementUnitCode shall be from same measuring system across whole hierarchy.-->
		<xsl:apply-templates select="." mode="r1038"/>
		<xsl:apply-templates select="." mode="r1039"/>
		<xsl:apply-templates select="." mode="r1045"/>
		<xsl:apply-templates select="." mode="r1049"/>
		<!--Rule 1061: this should be a schema validation but implemented -->
		<xsl:apply-templates select="." mode="r1061"/>
		<!--Rule 1066: If targetMarketCountryCode equals <Geographic> then functionalName SHALL be used. EQUALS Rule 1065: functionalName SHALL be used.-->
		<xsl:apply-templates select="." mode="r1078"/>
		<xsl:apply-templates select="." mode="r1079"/>
		<xsl:apply-templates select="." mode="r1080"/>
		<xsl:apply-templates select="." mode="r1089"/>
		<xsl:apply-templates select="." mode="r1160">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1161">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1167"/>
		<xsl:apply-templates select="." mode="r1168"/>
		<xsl:apply-templates select="." mode="r1176"/>
		<xsl:apply-templates select="." mode="r1277"/>
		<xsl:apply-templates select="." mode="r1278"/>
		<xsl:apply-templates select="." mode="r1279"/>
		<xsl:apply-templates select="." mode="r1280"/>
		<xsl:apply-templates select="." mode="r1283"/>
		<xsl:apply-templates select="." mode="r1288">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1291"/>
		<xsl:apply-templates select="." mode="r1299">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1338"/>
		<!--Rule 1340: If both gpcCategoryCode and gpcAttributeTypeCode are used, the value of gpcAttributeTypeCode shall be valid for the value of gpcCategoryCode.-->
		<!--Rule 1341: If both gpcAttributeValueCode and gpcAttributeTypeCode are used, the value of gpcAttributeValueCode shall be valid for the value of gpcAttributeTypeCode.-->
		<xsl:apply-templates select="." mode="r1419">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1458">
			<xsl:with-param name="command" select="$command"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1459"/>
		<xsl:apply-templates select="." mode="components">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="."/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1613">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1639">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1662">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1684">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1692">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1695">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="r1697">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="." mode="r2069">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>

	</xsl:template>
</xsl:stylesheet>