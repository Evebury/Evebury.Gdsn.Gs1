<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl gs1"
    xmlns:gs1="urn:xsl:extension:gdsn:gs1:response"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="*" mode="components">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>
		<xsl:apply-templates select="tradeItemInformation" mode="components">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>
	
	</xsl:template>

	<xsl:template match="tradeItemInformation" mode="components">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>
		<xsl:apply-templates select="tradeItemComponents" mode="components">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="tradeItemComponents" mode="components">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<xsl:apply-templates select="componentInformation" mode="components">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
		</xsl:apply-templates>
		
		<xsl:variable name="root" select="."/>
		
		<!--Rule 1607: All iterations of componentNumber shall be unique within this tradeItem-->
		
		<xsl:for-each select="componentInformation/componentNumber">
			<xsl:variable name="value" select="."/>
			<xsl:if test="count($root/componentInformation[componentNumber = $value]) &gt; 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1607" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

		<!--Rule 1610: If componentInformation is used, then componentIdentification shall be unique for each component.-->
		<xsl:for-each select="componentInformation/componentIdentification">
			<xsl:variable name="value" select="."/>
			<xsl:if test="count($root/componentInformation[componentIdentification = $value]) &gt; 1">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1610" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		
		
		<xsl:variable name="specialItemCode" select="tradeItemInformation/extension/*[namespace-uri()='urn:gs1:gdsn:marketing_information:xsd:3' and local-name()='marketingInformationModule']/marketingInformation/specialItemCode"/>

		<xsl:if test="$specialItemCode != 'DYNAMIC_ASSORTMENT'">
			<!--Rule 1604: If any attribute in class tradeItemComponents or class componentInformation is used, and specialItemcode does not equal 'DYNAMIC_ASSORTMENT' then numberOfPiecesInSet and totalNumberOfComponents shall be used.-->
			<xsl:if test="numberOfPiecesInSet  = '' or totalNumberOfComponents = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1604" />
				</xsl:apply-templates>
			</xsl:if>
			<!--Rule 1605: If any attribute in class componentInformation is used, and specialItemcode does not equal 'DYNAMIC_ASSORTMENT' then componentDescription and componentQuantity shall be used.-->
			<xsl:if test="componentDescription  = '' or componentQuantity = ''">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1605" />
				</xsl:apply-templates>
			</xsl:if>
			<!--Rule 1606: If any attribute in tradeItemComponents or componentInformation is used, and specialItemCode does not equal 'DYNAMIC_ASSORTMENT', then totalNumberOfComponents shall be greater than '0'.-->
			<xsl:if test="totalNumberOfComponents &lt;= 0">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1606" />
				</xsl:apply-templates>
			</xsl:if>

		</xsl:if>

		<!--Rule 1608: numberOfPiecesInSet shall equal the sum of componentQuantity of each child component.-->
		<xsl:if test="numberOfPiecesInSet != ''">
			<xsl:if test="numberOfPiecesInSet != sum(componentInformation/componentQuantity)">
				<xsl:apply-templates select="." mode="error">
					<xsl:with-param name="id" select="1608" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
		
		<!--Rule 1609: If componentInformation is used, then totalNumberOfComponents shall equal the number of iterations of class componentInformation.-->
		<xsl:if test="totalNumberOfComponents != count(componentInformation)">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1609" />
			</xsl:apply-templates>
		</xsl:if>
		
		
	</xsl:template>

	<xsl:template match="componentInformation" mode="components">
		<xsl:param name="targetMarket"/>
		<xsl:param name="tradeItem"/>

		<!--Rule 1550: There shall be at most 25 iterations of Class GDSNTradeItemClassificationAttribute per iteration of ComponentInformation/gpcCategoryCode.-->
		<xsl:if test="count(gDSNTradeItemClassificationAttribute) &gt; 25">
			<xsl:apply-templates select="." mode="error">
				<xsl:with-param name="id" select="1550" />
			</xsl:apply-templates>
		</xsl:if>
		
		<xsl:apply-templates select="extension/*" mode="module">
			<xsl:with-param name="targetMarket" select="$targetMarket"/>
			<xsl:with-param name="tradeItem" select="$tradeItem"/>
			<xsl:with-param name="component" select=".."/>
		</xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>