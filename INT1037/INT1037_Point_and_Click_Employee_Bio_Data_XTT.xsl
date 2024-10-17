<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ws="urn:com.workday/workersync" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xtt="urn:com.workday/xtt">

    <!--XTT Requires an input of well formed XML. Therefore, our XSLT must output XML and the XTT will handle the final transformation to text.-->
    <xsl:output method="xml"/>

    <!--  Write the header row -->
    <xsl:template match="ws:Worker_Sync">
        <File xtt:separator="&#xd;&#xa;" xtt:quotes="never" xtt:severity="warning">
            <Header xtt:separator="|">
                <Column1>AccountNumber</Column1>
                <Column2>EmployeeNumber</Column2>
                <Column3>OtherIDNumber</Column3>
                <Column4>UsernameInExternalDirectory</Column4>
                <Column5>LastName</Column5>
                <Column6>FirstName</Column6>
                <Column7>MiddleName</Column7>
                <Column8>DOB</Column8>
                <Column9>SexCode</Column9>
                <Column10>Email1</Column10>
                <Column11>IsEmployee</Column11>
                <Column12>DepartmentOrProgram</Column12>
                <Column13>HireStartDate</Column13>
                <Column14>HireEndDate</Column14>
                <Column15>Ethnicity</Column15>
                <Column16>Race</Column16>
                <Column17>LocalZip</Column17>
                <Column18>LocalAddr1</Column18>
                <Column19>LocalAddr2</Column19>
                <Column20>LocalCity</Column20>
                <Column21>LocalState</Column21>
                <Column22>LocalPhone</Column22>
                <Column23>MobilePhone</Column23>
            </Header>
            <xsl:apply-templates select="ws:Worker"/>
        </File>
    </xsl:template>

    <!-- Write the data row -->
    <xsl:template match="ws:Worker[ws:Eligibility eq 'true']">
        <Record xtt:separator="|" xtt:target="{ws:Summary/ws:Name}"
            xtt:targetWID="{ws:Additional_Information/ws:WID}">
            <AccountNumber xtt:required="false"/>
            <EmployeeNumber xtt:required="true" xtt:severity="error">
                <xsl:value-of select="ws:Summary/ws:Employee_ID"/>
            </EmployeeNumber>
            <OtherIDNumber xtt:required="false">
                <xsl:value-of select="ws:Additional_Information/ws:Campus_ID"/>
            </OtherIDNumber>
            <UsernameInExternalDirectory xtt:required="true" xtt:severity="error">
                <xsl:value-of select="ws:Additional_Information/ws:ASURite"/>
            </UsernameInExternalDirectory>
            <LastName xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Name_Data/ws:Last_Name"/>
            </LastName>
            <FirstName xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Name_Data/ws:First_Name"/>
            </FirstName>
            <MiddleName xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Name_Data/ws:Middle_Name"/>
            </MiddleName>
            <DOB xtt:required="false" xtt:dateFormat="MM/dd/yyyy">
                <xsl:value-of select="ws:Personal/ws:Birth_Date"/>
            </DOB>
            <SexCode xtt:required="true" xtt:severity="error">
                <xsl:value-of select="ws:Personal/ws:Gender"/>
            </SexCode>
            <Email1 xtt:required="true">
                <xsl:value-of select="ws:Personal/ws:Email_Data/ws:Email_Address"/>
            </Email1>
            <IsEmployee xtt:required="true">1</IsEmployee>
            <DepartmentOrProgram>
                <xsl:value-of select="substring(ws:Additional_Information/ws:Supervisory_Organization, 1, 100)"/>
            </DepartmentOrProgram>
            <HireStartDate xtt:required="true" xtt:severity="error" xtt:dateFormat="MM/dd/yyyy">
                <xsl:value-of select="ws:Status/ws:Hire_Date"/>
            </HireStartDate>
            <HireEndDate xtt:required="false" xtt:dateFormat="MM/dd/yyyy">
                <xsl:value-of select="ws:Status/ws:Termination_Date"/>
            </HireEndDate>
            <Ethnicity xtt:required="false">
                <xsl:if test="ws:Personal/ws:Hispanic_or_Latino = 'true'">Hispanic/Latino</xsl:if>
                <xsl:if test="ws:Personal/ws:Hispanic_or_Latino = 'false'">Not Hispanic/Latino</xsl:if>
            </Ethnicity>
            <Race xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Ethnicity"/>
            </Race>
            <LocalZip xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Address_Data/ws:Postal_Code"/>
            </LocalZip>
            <LocalAddr1 xtt:required="false">
                <xsl:value-of
                    select="ws:Personal/ws:Address_Data/ws:Address_Line_Data[@ws:Type = 'ADDRESS_LINE_1']"
                />
            </LocalAddr1>
            <LocalAddr2 xtt:required="false">
                <xsl:value-of
                    select="ws:Personal/ws:Address_Data/ws:Address_Line_Data[@ws:Type = 'ADDRESS_LINE_2']"
                />
            </LocalAddr2>
            <LocalCity xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Address_Data/ws:Municipality"/>
            </LocalCity>
            <LocalState xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Address_Data/ws:Region"/>
            </LocalState>
            <LocalPhone xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Phone_Data/ws:Complete_Phone_Number"/>
            </LocalPhone>
            <MobilePhone xtt:required="false">
                <xsl:if test="ws:Personal/ws:Phone_Data/ws:Phone_Device_Type = 'MOBILE'">
                    <xsl:value-of select="ws:Personal/ws:Phone_Data/ws:Complete_Phone_Number"/>
                </xsl:if>
            </MobilePhone>
        </Record>
    </xsl:template>

</xsl:stylesheet>
