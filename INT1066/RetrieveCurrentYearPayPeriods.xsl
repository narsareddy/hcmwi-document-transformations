<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
	xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">

	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="firstPayrollDate"/>
	<xsl:param name="totalPayPeriods"/>
	<xsl:param name="currentPeriodStartDate"/>

	<xsl:variable name="firstPayrollStartDate">
		<xsl:choose>
			<xsl:when test="$currentPeriodStartDate > $firstPayrollDate">
				<xsl:value-of select="$currentPeriodStartDate"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$firstPayrollDate"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/">

		<Root>
			<xsl:for-each
				select="env:Envelope/env:Body/wd:Get_Period_Schedules_Response/wd:Response_Data/wd:Period_Schedule/wd:Period_Schedule_Data/wd:Period_Data[wd:Period_Start_Date >= $firstPayrollDate]">
				<xsl:sort select="wd:Payroll_Payment_Date"/>
				<xsl:if test="(position() &lt;= $totalPayPeriods)">
					<Pay_Periods>
						<Position>
							<xsl:value-of select="position()"/>
						</Position>
						<Period_Start_Date>
							<xsl:value-of select="wd:Period_Start_Date"/>
						</Period_Start_Date>
						<Period_End_Date>
							<xsl:value-of select="wd:Period_End_Date"/>
						</Period_End_Date>
						<Payroll_Payment_Date>
							<xsl:value-of select="wd:Payroll_Payment_Date"/>
						</Payroll_Payment_Date>
						<Period_ID>
							<xsl:value-of select="wd:Period_ID"/>
						</Period_ID>
					</Pay_Periods>

					<xsl:if test="position() = $totalPayPeriods">
						<Last_Payroll_End_Date>
							<xsl:value-of select="wd:Period_End_Date"/>
						</Last_Payroll_End_Date>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>

			<xsl:for-each
				select="env:Envelope/env:Body/wd:Get_Period_Schedules_Response/wd:Response_Data/wd:Period_Schedule/wd:Period_Schedule_Data/wd:Period_Data[wd:Period_Start_Date >= $firstPayrollStartDate]">
				<xsl:sort select="wd:Period_Start_Date"/>
				<xsl:if test="position() = 1">
					<First_Payroll_Start_Date>
						<xsl:value-of select="wd:Period_Start_Date"/>
					</First_Payroll_Start_Date>
					<First_Payroll_End_Date>
						<xsl:value-of select="wd:Period_End_Date"/>
					</First_Payroll_End_Date>
					<First_Payroll_Check_Date>
						<xsl:value-of select="wd:Payroll_Payment_Date"/>
					</First_Payroll_Check_Date>
				</xsl:if>
			</xsl:for-each>
		</Root>
	</xsl:template>

</xsl:stylesheet>
