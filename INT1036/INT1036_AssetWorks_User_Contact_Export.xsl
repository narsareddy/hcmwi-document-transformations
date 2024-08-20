<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ws="urn:com.workday/workersync" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xtt="urn:com.workday/xtt">

    <!-- XTT Requires an input of well formed XML -->
    <xsl:output method="xml"/>

    <xsl:template match="ws:Worker_Sync">
        <File xtt:separator="&#xd;&#xa;" xtt:quotes="always" xtt:severity="warning">
            <xsl:apply-templates select="ws:Worker"/>
        </File>
    </xsl:template>

    <xsl:template match="ws:Worker">
        <Record xtt:separator="," xtt:target="{ws:Summary/ws:Name}" xtt:targetWID="{ws:Additional_Information/ws:WID}">
            <Employee_ID xtt:required="false">
                <xsl:value-of select="ws:Summary/ws:Employee_ID"/>
            </Employee_ID>
            <FirstName xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Name_Data/ws:First_Name"/>
            </FirstName>
            <LastName xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Name_Data/ws:Last_Name"/>
            </LastName>
            <Phone xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Phone_Data[ws:Phone_Type = 'WORK' and ws:Phone_Device_Type != 'Fax']/ws:Complete_Phone_Number"/>
            </Phone>
            <Phone_Extension xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Phone_Data[ws:Phone_Type = 'WORK' and ws:Phone_Device_Type != 'Fax']/ws:Phone_Extension"/>
            </Phone_Extension>
            <Fax xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Phone_Data[ws:Phone_Type = 'WORK' and ws:Phone_Device_Type = 'Fax']/ws:Complete_Phone_Number"/>
            </Fax>
            <Email xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Email_Data/ws:Email_Address"/>
            </Email>
            <Cost_Center xtt:required="false">
                <xsl:value-of select="ws:Position/ws:Organization_Data[ws:Organization_Type = 'Cost_Center']/ws:Organization"/>
            </Cost_Center>
            <Name_Prefix xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Name_Data/ws:Title"/>
            </Name_Prefix>
            <MiddleName xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Name_Data/ws:Middle_Name"/>
            </MiddleName>
            <Name_Suffix xtt:required="false">
                <xsl:value-of select="ws:Personal/ws:Name_Data/ws:Social_Suffix"/>
            </Name_Suffix>
            <Position_Title xtt:required="false">
                <xsl:value-of select="ws:Position[ws:Operation != 'REMOVE']/ws:Position_Title"/>
            </Position_Title>
            <Location xtt:required="false">
                <xsl:value-of select="ws:Additional_Information/ws:Location/@ws:Descriptor"/>
            </Location>
            <Username xtt:required="false">
                <xsl:value-of select="ws:Additional_Information/ws:ASURITE"/>
            </Username>
            <Deactivate xtt:required="false">
                <xsl:choose>
                    <xsl:when test="ws:Status/ws:Employee_Status = 'Active'">
                        <xsl:text>N</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Y</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </Deactivate>
        </Record>
    </xsl:template>

</xsl:stylesheet>
