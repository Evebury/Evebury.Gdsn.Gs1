<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*[namespace-uri()='urn:gs1:gdsn:packaging_information:xsd:3' and local-name()='packagingInformationModule']" mode="module">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="packaging" mode="packagingInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="packaging" mode="packagingInformationModule">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>




		<!--Rule 506: If targetMarketCountryCode equals <Geographic> and packagingMaterialCompositionQuantity is used then in at least one iteration of packagingMaterialCompositionQuantity the related packagingMaterialCompositionQuantity/@measurementUnitCode SHALL equal 'KGM' or 'GRM'.-->
		<xsl:if test="contains('056, 203, 246, 442, 528, 752', $targetMarket)">
			<xsl:if test="packagingMaterial/packagingMaterialCompositionQuantity[text() != '']">
				<xsl:choose>
					<xsl:when test="packagingMaterial/packagingMaterialCompositionQuantity[text() != '' and @measurementUnitCode = 'KGM']"/>
					<xsl:when test="packagingMaterialCompositionQuantity[text() != '' and @measurementUnitCode = 'GRM']"/>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="506" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>

		<!--Rule 507: If packagingMaterialCompositionQuantity and packagingWeight are not empty then the sum of all instances of  packagingMaterialCompositionQuantity for the trade item must be less than or equal to packagingWeight.-->
		<xsl:if test="packagingWeight != '' and packagingMaterial/packagingMaterialCompositionQuantity[text() != '']">
			<xsl:variable name="packagingWeight">
				<xsl:apply-templates select="packagingWeight" mode="measurementUnit"/>
			</xsl:variable>
			<xsl:variable name="itemWeight">
				<xsl:call-template name="r507">
					<xsl:with-param name="items" select="packagingMaterial/packagingMaterialCompositionQuantity"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$itemWeight &gt; $packagingWeight">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="507" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<!--Rule 540: If parent item platformTypeCode is equal to '11', and the child platformTypeCode is equal to '10' then quantityOfNextLowerLevelTradeItem of the parent item must not be greater than 2.-->
		<xsl:if test="platformTypeCode = '11'">
			<xsl:variable name="quantity" select="sum(nextLowerLevelTradeItemInformation/childTradeItem/quantityOfNextLowerLevelTradeItem)"/>
			<xsl:for-each select="$tradeItem/../catalogueItemChildItemLink/catalogueItem/tradeItem">
				<xsl:if test="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:packaging_information:xsd:3' and local-name()='packagingInformationModule']/packaging/platformTypeCode = '10'">
					<xsl:if test="$quantity &gt; 2">
						<xsl:apply-templates select="." mode="error">
							<xsl:with-param name="id" select="540" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>

		<xsl:apply-templates select="packagingMaterial" mode="packagingInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="packageDeposit" mode="packagingInformationModule"/>
		<xsl:apply-templates select="returnableAsset" mode="packagingInformationModule">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="packagingMaterial" mode="packagingInformationModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 466: If packagingMaterialCompositionQuantity is not empty then value must be greater than 0.-->
		<xsl:if test="packagingMaterialCompositionQuantity != '' and packagingMaterialCompositionQuantity &lt;= 0">
			<xsl:apply-templates select="packagingMaterialCompositionQuantity" mode="error">
				<xsl:with-param name="id" select="466"/>
			</xsl:apply-templates>
		</xsl:if>

		<!--Rule 1025: If targetMarketCountryCode equals <Geographic> and packagingMaterial/packagingMaterialTypeCode is used then packagingMaterial/packagingMaterialCompositionQuantity SHALL be used.-->
		<xsl:if test="contains('752, 203, 246, 703', $targetMarket)">
			<xsl:if test="packagingMaterialTypeCode != '' and packagingMaterialCompositionQuantity =''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1025" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>

		<!--Rule 1057: If packagingMaterial/packagingMaterialTypeCode does not equal ('COMPOSITE', 'METAL_COMPOSITE', 'LAMINATED_CARTON', 'PAPER_PAPERBOARD' or 'OTHER') then CompositeMaterialDetail class SHALL NOT be used..-->
		<xsl:choose>
			<xsl:when test="packagingMaterialTypeCode = 'COMPOSITE'"/>
			<xsl:when test="packagingMaterialTypeCode = 'METAL_COMPOSITE'"/>
			<xsl:when test="packagingMaterialTypeCode = 'LAMINATED_CARTON'"/>
			<xsl:when test="packagingMaterialTypeCode = 'PAPER_PAPERBOARD'"/>
			<xsl:when test="packagingMaterialTypeCode = 'OTHER'"/>
			<xsl:otherwise>
				<xsl:if test="compositeMaterialDetail != ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="1057" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

	<xsl:template match="packageDeposit" mode="packagingInformationModule">
		<!--Rule 632: If depositValueEffectiveDateTime is not empty then returnablePackageDepositIdentification or returnablePackageDepositAmount must not be empty.-->
		<xsl:if test="depositValueEffectiveDateTime != ''">
			<xsl:if test="returnablePackageDepositAmount = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="632" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="returnableAsset" mode="packagingInformationModule">
		<xsl:param name="targetMarket"/>
		<!--Rule 634: If targetMarketCountryCode is equal to  ('040' (Austria) or '276' (Germany)) and isReturnableAssetEmpty = 'true' then returnableAssetCapacityContent shall not be empty.-->
		<xsl:if test="$targetMarket = '040' or $targetMarket = '276'">
			<xsl:if test="isReturnableAssetEmpty = 'true'">
				<xsl:if test="returnableAssetCapacityContent  = ''">
					<xsl:apply-templates select="." mode="error">
						<xsl:with-param name="id" select="634" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="r507">
		<xsl:param name="items"/>
		<xsl:param name="index" select="1"/>
		<xsl:param name="count" select="count(msxsl:node-set($items))"/>
		<xsl:param name="weight" select="0"/>
		<xsl:choose>
			<xsl:when test="$index &lt;= $count">
				<xsl:variable name="value" select="msxsl:node-set($items)[$index]"/>
				<xsl:variable name="itemWeight">
					<xsl:choose>
						<xsl:when test="$value = number($value)">
							<xsl:variable name="weightValue">
								<xsl:apply-templates select="$value" mode="measurementUnit"/>
							</xsl:variable>
							<xsl:value-of select="$weightValue"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="0"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:call-template name="r507">
					<xsl:with-param name="items" select="$items"/>
					<xsl:with-param name="index" select="$index + 1"/>
					<xsl:with-param name="count" select="$count"/>
					<xsl:with-param name="weight" select="$weight + $itemWeight"/>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$weight"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>