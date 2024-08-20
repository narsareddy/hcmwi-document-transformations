<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:wd="urn:com.workday/bsvc" version="2.0" xmlns:xtt="urn:com.workday/xtt"
    xmlns:etv="urn:com.workday/etv">

    <!--XTT Requires an input of well formed XML. Therefore, our XSLT must output XML and the XTT will handle the final transformation to text.-->
    <xsl:output indent="yes" method="xml"/>

    <!--  Write the header row -->
    <xsl:template match="/wd:Report_Data">
        <root xtt:separator="&#xd;&#xa;" xtt:quotes="never" xtt:severity="warning">
            <Header xtt:separator="," xtt:quotes="csv" xtt:quoteStyle="double">
                <psprs_contribution_type>ContributionCode</psprs_contribution_type>
                <first_name>FirstName</first_name>
                <middle_name>MiddleName</middle_name>
                <last_name>LastName</last_name>
                <ssn>SSN</ssn>
                <ss_tax_withheld>IsSocialSecurityTaxWithheld</ss_tax_withheld>
                <employee_amount>EmployeeContribution</employee_amount>
                <employer_amount>EmployerContribution</employer_amount>
                <pay_end_date>PayPeriodEnd</pay_end_date>
                <check_date>PayDate</check_date>
                <member_pensionable_salary>PensionableWages</member_pensionable_salary>
                <non_payment_reason_code>NonPaymentReasonCode</non_payment_reason_code>
            </Header>
            <xsl:apply-templates/>
        </root>
    </xsl:template>

    <xsl:template match="wd:Report_Entry">
        <row xtt:separator="," xtt:quotes="csv" xtt:quoteStyle="double">
            <psprs_contribution_type xtt:required="false">
                <xsl:choose>
                    <xsl:when
                        test="wd:Benefit_Plans_Group/wd:Benefit_Plan/wd:ID[@wd:type = 'Benefit_Plan_ID'] = 'PSPRS_ACR'">
                        <xsl:text>ALTN</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="wd:Benefit_Plans_Group/wd:Benefit_Plan/wd:ID[@wd:type = 'Benefit_Plan_ID'] = 'PSPRS_401a_Tier3DC'">
                        <xsl:text>DCCN</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="wd:Benefit_Plans_Group/wd:Benefit_Plan/wd:ID[@wd:type = 'Benefit_Plan_ID'] = 'PSPRS_Disability_Fund'">
                        <xsl:text>DCDT</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="wd:Benefit_Plans_Group/wd:Benefit_Plan/wd:ID[@wd:type = 'Benefit_Plan_ID'] = 'PSPRS_401a_EPSL'">
                        <xsl:text>EPSL</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="wd:Benefit_Plans_Group/wd:Benefit_Plan/wd:ID[@wd:type = 'Benefit_Plan_ID'] = 'PSPRS_Health_Subsidy_Fund'">
                        <xsl:text>DCHS</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DBCN</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </psprs_contribution_type>
            <first_name xtt:required="false">
                <xsl:value-of select="wd:First_Name"/>
            </first_name>
            <middle_name xtt:required="false">
                <xsl:value-of select="wd:Middle_Name"/>
            </middle_name>
            <last_name xtt:required="false">
                <xsl:value-of select="wd:Last_Name"/>
            </last_name>
            <ssn xtt:required="false">
                <xsl:value-of select="wd:SSN"/>
            </ssn>
            <ss_withheld xtt:required="false">Y</ss_withheld>
            <employee_amount>
                <xsl:value-of
                    select="sum(wd:Payroll_Result_Lines_Group[contains(wd:Deduction/wd:ID[@wd:type = 'Deduction_Code'], ' EE')]/xs:decimal(wd:Amount), 0)"
                />
            </employee_amount>
            <employer_amount>
                <xsl:value-of
                    select="sum(wd:Payroll_Result_Lines_Group[contains(wd:Deduction/wd:ID[@wd:type = 'Deduction_Code'], ' ER')]/xs:decimal(wd:Amount), 0)"
                />
            </employer_amount>
            <pay_end_date xtt:required="false" etv:dateFormat="MM/dd/yyyy">
                <xsl:value-of select="wd:Payroll_Result_Lines_Group[1]/wd:Pay_End_Date"/>
            </pay_end_date>
            <check_date xtt:required="false" etv:dateFormat="MM/dd/yyyy">
                <xsl:value-of select="wd:Payroll_Result_Lines_Group[1]/wd:Check_Date"/>
            </check_date>
            <member_pensionable_salary xtt:required="false">
                <xsl:value-of select="sum(wd:Payroll_Result_Lines_Group[wd:Pay_Comp_Groups/wd:ID[@wd:type='Pay_Component_Group_Code'] = '401aAPSPRS']/xs:decimal(wd:Amount))"/>
            </member_pensionable_salary>
            <non_payment_reason_code xtt:required="false">
                <xsl:if
                    test="sum(wd:Payroll_Result_Lines_Group[contains(wd:Deduction/wd:ID[@wd:type = 'Deduction_Code'], ' EE')]/xs:decimal(wd:Amount), 0) eq 0 and sum(wd:Payroll_Result_Lines_Group[contains(wd:Deduction/wd:ID[@wd:type = 'Deduction_Code'], ' ER')]/xs:decimal(wd:Amount), 0) eq 0">
                    <xsl:if test="wd:Terminated eq '1'">
                        <xsl:text>QU</xsl:text>
                    </xsl:if>
                    <xsl:if test="wd:Terminated ne '1' and wd:On_Leave eq '1'">
                        <xsl:choose>
                            <xsl:when test="wd:Leave_Type/wd:ID[@wd:type='Leave_of_Absence_Type_ID'] = 'FMLA_Workers_Compensation'">
                                <xsl:text>IL</xsl:text>
                            </xsl:when>
                            <xsl:when test="wd:Leave_Type/wd:ID[@wd:type='Leave_of_Absence_Type_ID'] = 'Military_Unpaid'">
                                <xsl:text>ML</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>LW</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:if>
            </non_payment_reason_code>
        </row>
    </xsl:template>

    <xsl:template match="*"/>

</xsl:stylesheet>
