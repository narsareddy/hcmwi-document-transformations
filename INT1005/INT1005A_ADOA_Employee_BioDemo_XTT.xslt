<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:bc="urn:com.workday/bc"
    exclude-result-prefixes="xs" version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xtt="urn:com.workday/xtt" xmlns:etv="urn:com.workday/etv">

    <!--XTT Requires an input of well formed XML. Therefore, our XSLT must output XML and the XTT will handle the final transformation to text.-->
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="noValue" select="'N'"/>
    <xsl:variable name="headerDefault" select="'BATCH HEADER ASU '"/>
    <xsl:variable name="trailerDefault" select="'BATCH TRAILER '"/>
    <xsl:variable name="today" select="format-date(current-date(), '[M01][D01][Y0001]')"/>
    <xsl:variable name="spaces" select="'                                      '"/>

    <xsl:template match="/bc:Benefits_Extract_Employees">
        <File xtt:separator="&#xd;&#xa;" xtt:align="left">
            <Header xtt:startTag="{$headerDefault}" xtt:endTag="{concat($today, $spaces, $spaces, $spaces, $spaces, $spaces, $spaces)}">
                <xsl:value-of select="$today"/>
            </Header>
            <xsl:apply-templates select="bc:Employee"/>
            <Trailer xtt:startTag="{$trailerDefault}" xtt:numberFormat="000000"
                xtt:number="totalRowCount"
                xtt:endTag="{substring(concat(format-date(current-date(), '[M01][D01][Y0001]'), $spaces, $spaces, $spaces, $spaces, $spaces, $spaces, $spaces), 1, 241)}"/>
        </File>
    </xsl:template>

    <xsl:template match="bc:Employee">
        <xsl:if
            test="bc:Additional_Information/bc:Campus_ID ne '' 
                and bc:Additional_Information/bc:Campus_ID_Begins_With_99 = 'Y'
                and (bc:Personal/bc:Home_Country = 'USA' 
                or bc:Additional_Information/bc:Mailing_Address_Country = 'USA' 
                or bc:Additional_Information/bc:Local_Address_Country = 'USA')">
            <Record etv:severity="error" etv:target="{bc:Personal/bc:Employee_ID}"
                xtt:incrementNumber="totalRowCount">
                <Transaction_Code xtt:fixedLength="2" xtt:required="true">
                    <xsl:value-of select="bc:Additional_Information/bc:Transaction_Code"/>
                </Transaction_Code>
                <Campus_ID etv:required="true" etv:severity="error" xtt:fixedLength="9">
                    <xsl:value-of select="bc:Additional_Information/bc:Campus_ID"/>
                </Campus_ID>
                <Action_Code xtt:fixedLength="1" xtt:required="true">
                    <xsl:choose>
                        <xsl:when test="bc:Status/bc:Staffing_Event eq 'HIR'">
                            <xsl:text>N</xsl:text>
                        </xsl:when>
                        <xsl:when test="bc:Status/bc:Staffing_Event eq 'TRM'">
                            <xsl:text>T</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="bc:Status/bc:Hire_Date = bc:Status/bc:Original_Hire_Date 
                                        and bc:Status/bc:Hire_Date ge /bc:Benefits_Extract_Employees/bc:Header/bc:From_Effective_Date
                                        and bc:Status/bc:Hire_Date le /bc:Benefits_Extract_Employees/bc:Header/bc:Effective_Date">
                                    <xsl:text>N</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>C</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </Action_Code>
                <Agency_Code xtt:fixedLength="2" xtt:required="true">
                    <xsl:value-of select="bc:Additional_Information/bc:Agency_Code"/>
                </Agency_Code>
                <Demographic_Change_Flag xtt:fixedLength="1" xtt:required="true">
                    <xsl:choose>
                        <xsl:when test="bc:Status/bc:Staffing_Event = 'HIR'">
                            <xsl:text>N</xsl:text>
                        </xsl:when>
                        <xsl:when test="bc:Status/bc:Staffing_Event = 'TRM'">
                            <xsl:text>Y</xsl:text>
                        </xsl:when>
                        <xsl:when test="bc:Personal/bc:Last_Name/@bc:PriorValue
                                or bc:Personal/bc:First_Name/@bc:PriorValue
                                or bc:Personal/bc:Middle_Name/@bc:PriorValue
                                or bc:Personal/bc:Gender/@bc:PriorValue
                                or bc:Personal/bc:Marital_Status/@bc:PriorValue">
                            <xsl:text>Y</xsl:text>
                        </xsl:when>
                        <xsl:when test="
                            (bc:Personal/bc:Home_Country = 'USA' 
                                    and (bc:Personal/bc:Home_Address_Line_1/@bc:PriorValue 
                                        or bc:Personal/bc:Home_Address_Line_2/@bc:PriorValue
                                        or bc:Personal/bc:Home_Municipality/@bc:PriorValue
                                        or bc:Additional_Information/bc:Primary_Home_Address_State_Code/@bc:PriorValue
                                        or bc:Personal/bc:Home_Postal_Code/@bc:PriorValue))
                                or (bc:Personal/bc:Home_Country != 'USA' 
                                   and bc:Additional_Information/bc:Mailing_Address_Country = 'USA' 
                                   and (bc:Additional_Information/bc:Mailing_Address_Line_1/@bc:PriorValue 
                                        or bc:Additional_Information/bc:Mailing_Address_Line_2/@bc:PriorValue
                                        or bc:Additional_Information/bc:Mailing_Address_City/@bc:PriorValue
                                        or bc:Additional_Information/bc:Mailing_Address_State/@bc:PriorValue
                                        or bc:Additional_Information/bc:Mailing_Address_Postal_Code/@bc:PriorValue))
                                or (bc:Personal/bc:Home_Country != 'USA' 
                                   and bc:Additional_Information/bc:Mailing_Address_Country != 'USA' 
                                   and bc:Additional_Information/bc:Local_Address_Country = 'USA' 
                                   and (bc:Additional_Information/bc:Local_Address_Line_1/@bc:PriorValue 
                                        or bc:Additional_Information/bc:Local_Address_Line_2/@bc:PriorValue
                                        or bc:Additional_Information/bc:Local_Address_City/@bc:PriorValue
                                        or bc:Additional_Information/bc:Local_Address_State/@bc:PriorValue
                                        or bc:Additional_Information/bc:Local_Address_Postal_Code/@bc:PriorValue))">
                            <xsl:text>Y</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>N</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </Demographic_Change_Flag>
                <Work_Phone_Change_Flag xtt:fixedLength="1" xtt:required="true">
                    <xsl:value-of select="$noValue"/>
                </Work_Phone_Change_Flag>
                <LastName xtt:fixedLength="15" xtt:required="false">
                    <xsl:value-of select="upper-case(bc:Personal/bc:Last_Name)"/>
                </LastName>
                <FirstName xtt:fixedLength="15" xtt:required="false">
                    <xsl:value-of select="upper-case(bc:Personal/bc:First_Name)"/>
                </FirstName>
                <Middle_Initial xtt:fixedLength="1" xtt:required="false">
                    <xsl:value-of select="upper-case(substring(bc:Personal/bc:Middle_Name, 1, 1))"/>
                </Middle_Initial>
                <xsl:choose>
                    <xsl:when test="bc:Personal/bc:Home_Country = 'USA'">
                        <Address_Line_1 xtt:fixedLength="30" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Personal/bc:Home_Address_Line_1)"/>
                        </Address_Line_1>
                        <Address_Line_2 xtt:fixedLength="30" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Personal/bc:Home_Address_Line_2)"/>
                        </Address_Line_2>
                        <City xtt:fixedLength="18" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Personal/bc:Home_Municipality)"/>
                        </City>
                        <State xtt:fixedLength="2" xtt:required="false">
                            <xsl:value-of
                                select="upper-case(bc:Additional_Information/bc:Primary_Home_Address_State_Code)"
                            />
                        </State>
                        <Zip_Code xtt:fixedLength="5" xtt:required="false">
                            <xsl:value-of select="bc:Personal/bc:Home_Postal_Code"/>
                        </Zip_Code>
                        <Zip4 xtt:fixedLength="4" xtt:required="false">
                            <xsl:value-of select="substring(bc:Personal/bc:Home_Postal_Code, 7, 4)"
                            />
                        </Zip4>
                    </xsl:when>
                    <xsl:when test="bc:Personal/bc:Home_Country != 'USA'
                            and bc:Additional_Information/bc:Mailing_Address_Country = 'USA'">
                        <Address_Line_1 xtt:fixedLength="30" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Additional_Information/bc:Mailing_Address_Line_1)"/>
                        </Address_Line_1>
                        <Address_Line_2 xtt:fixedLength="30" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Additional_Information/bc:Mailing_Address_Line_2)"/>
                        </Address_Line_2>
                        <City xtt:fixedLength="18" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Additional_Information/bc:Mailing_Address_City)"/>
                        </City>
                        <State xtt:fixedLength="2" xtt:required="false">
                            <xsl:value-of
                                select="upper-case(bc:Additional_Information/bc:Mailing_Address_State)"
                            />
                        </State>
                        <Zip_Code xtt:fixedLength="5" xtt:required="false">
                            <xsl:value-of select="bc:Additional_Information/bc:Mailing_Address_Postal_Code"/>
                        </Zip_Code>
                        <Zip4 xtt:fixedLength="4" xtt:required="false">
                            <xsl:value-of select="substring(bc:Additional_Information/bc:Mailing_Address_Postal_Code, 7, 4)"
                            />
                        </Zip4>
                    </xsl:when>
                    <xsl:otherwise>
                        <Address_Line_1 xtt:fixedLength="30" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Additional_Information/bc:Local_Address_Line_1)"/>
                        </Address_Line_1>
                        <Address_Line_2 xtt:fixedLength="30" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Additional_Information/bc:Local_Address_Line_2)"/>
                        </Address_Line_2>
                        <City xtt:fixedLength="18" xtt:required="false">
                            <xsl:value-of select="upper-case(bc:Additional_Information/bc:Local_Address_City)"/>
                        </City>
                        <State xtt:fixedLength="2" xtt:required="false">
                            <xsl:value-of
                                select="upper-case(bc:Additional_Information/bc:Local_Address_State)"
                            />
                        </State>
                        <Zip_Code xtt:fixedLength="5" xtt:required="false">
                            <xsl:value-of select="bc:Additional_Information/bc:Local_Address_Postal_Code"/>
                        </Zip_Code>
                        <Zip4 xtt:fixedLength="4" xtt:required="false">
                            <xsl:value-of select="substring(bc:Additional_Information/bc:Local_Address_Postal_Code, 7, 4)"
                            />
                        </Zip4>
                    </xsl:otherwise>
                </xsl:choose>
                <Home_Phone xtt:fixedLength="10" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 10)"/>
                </Home_Phone>
                <Gender_Code xtt:fixedLength="1" xtt:required="false">
                    <xsl:choose>
                        <xsl:when test="bc:Personal/bc:Gender ne ''">
                            <xsl:value-of select="bc:Personal/bc:Gender"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>M</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </Gender_Code>
                <Marital_Status xtt:fixedLength="1" xtt:required="false">
                    <xsl:choose>
                        <xsl:when test="bc:Personal/bc:Marital_Status ne ''">
                            <xsl:value-of select="bc:Personal/bc:Marital_Status"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>S</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </Marital_Status>
                <Birth_Date xtt:dateFormat="MMddyyyy" xtt:fixedLength="8" xtt:required="true">
                    <xsl:value-of select="bc:Personal/bc:Birth_Date"/>
                </Birth_Date>
                <Pay_Cycle xtt:fixedLength="1" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 1)"/>
                </Pay_Cycle>
                <Date_of_Employment xtt:dateFormat="MMddyyyy" xtt:fixedLength="8"
                    xtt:required="false">
                    <xsl:value-of select="bc:Status/bc:Hire_Date"/>
                </Date_of_Employment>
                <Effective_Date xtt:fixedLength="8" xtt:required="false">
                    <xsl:choose>
                        <xsl:when test="bc:Status/bc:Staffing_Event eq 'TRM'">
                            <xsl:choose>
                                <xsl:when test="bc:Additional_Information/bc:Coverage_End_Date != ''">
                                    <xsl:value-of select="format-date(max(bc:Additional_Information/bc:Coverage_End_Date/xs:date(.)), '[M01][D01][Y0001]')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="bc:Status/bc:Termination_Date != ''">
                                            <xsl:value-of select="format-date(bc:Status/bc:Termination_Date, '[M01][D01][Y0001]')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>00000000</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>00000000</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </Effective_Date>
                <Annual_Salary xtt:fixedLength="6" xtt:required="false" xtt:numberFormat="000000">
                    <xsl:choose>
                        <xsl:when test="number(bc:Position/bc:Total_Annual_Base_Pay) le 999999">
                            <xsl:value-of select="number(bc:Position/bc:Total_Annual_Base_Pay)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:number value="999999"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </Annual_Salary>
                <Hours_Worked xtt:fixedLength="2" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 2)"/>
                </Hours_Worked>
                <Work_Phone xtt:fixedLength="10" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 10)"/>
                </Work_Phone>
                <Address_Change_Flag xtt:fixedLength="1" xtt:required="true">
                    <xsl:choose>
                        <xsl:when test="bc:Status/bc:Staffing_Event = 'HIR'">
                            <xsl:text>N</xsl:text>
                        </xsl:when>
                        <xsl:when test="
                            (bc:Personal/bc:Home_Country = 'USA' 
                                and (bc:Personal/bc:Home_Address_Line_1/@bc:PriorValue 
                                    or bc:Personal/bc:Home_Address_Line_2/@bc:PriorValue
                                    or bc:Personal/bc:Home_Municipality/@bc:PriorValue
                                    or bc:Additional_Information/bc:Primary_Home_Address_State_Code/@bc:PriorValue
                                    or bc:Personal/bc:Home_Postal_Code/@bc:PriorValue))
                            or (bc:Personal/bc:Home_Country != 'USA' 
                                and bc:Additional_Information/bc:Mailing_Address_Country = 'USA' 
                                and (bc:Additional_Information/bc:Mailing_Address_Line_1/@bc:PriorValue 
                                    or bc:Additional_Information/bc:Mailing_Address_Line_2/@bc:PriorValue
                                    or bc:Additional_Information/bc:Mailing_Address_City/@bc:PriorValue
                                    or bc:Additional_Information/bc:Mailing_Address_State/@bc:PriorValue
                                    or bc:Additional_Information/bc:Mailing_Address_Postal_Code/@bc:PriorValue))
                            or (bc:Personal/bc:Home_Country != 'USA' 
                                and bc:Additional_Information/bc:Mailing_Address_Country != 'USA' 
                                and bc:Additional_Information/bc:Local_Address_Country = 'USA' 
                                and (bc:Additional_Information/bc:Local_Address_Line_1/@bc:PriorValue 
                                    or bc:Additional_Information/bc:Local_Address_Line_2/@bc:PriorValue
                                    or bc:Additional_Information/bc:Local_Address_City/@bc:PriorValue
                                    or bc:Additional_Information/bc:Local_Address_State/@bc:PriorValue
                                    or bc:Additional_Information/bc:Local_Address_Postal_Code/@bc:PriorValue))">
                            <xsl:text>Y</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>N</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </Address_Change_Flag>
                <Name_Change_Flag xtt:fixedLength="1" xtt:required="true">
                    <xsl:choose>
                        <xsl:when test="bc:Status/bc:Staffing_Event = 'HIR'">
                            <xsl:text>N</xsl:text>
                        </xsl:when>
                        <xsl:when test="
                            (bc:Personal/bc:Last_Name/@bc:PriorValue
                            or bc:Personal/bc:First_Name/@bc:PriorValue
                            or bc:Personal/bc:Middle_Name/@bc:PriorValue)">
                            <xsl:text>Y</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>N</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </Name_Change_Flag>
                <Filler xtt:fixedLength="2" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 2)"/>
                </Filler>
                <Retirement_Code xtt:fixedLength="4" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 4)"/>
                </Retirement_Code>
                <SSN xtt:fixedLength="9" xtt:minLength="9" xtt:required="true">
                    <xsl:choose>
                        <xsl:when test="bc:Personal/bc:Social_Security_Number ne ''">
                            <xsl:value-of select="bc:Personal/bc:Social_Security_Number"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="bc:Additional_Information/bc:Campus_ID"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </SSN>
                <University_Flag xtt:fixedLength="1" xtt:required="false">
                    <xsl:value-of select="bc:Additional_Information/bc:University_Flag"/>
                </University_Flag>
                <Employee_Type xtt:fixedLength="1" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 1)"/>
                </Employee_Type>
                <Number_Of_Pay_Periods xtt:fixedLength="2" xtt:required="false">
                    <xsl:value-of select="bc:Additional_Information/bc:Number_Of_Pay_Periods"/>
                </Number_Of_Pay_Periods>
                <Foreign_Address_Indicator xtt:fixedLength="1" xtt:required="false">
                    <xsl:value-of select="$noValue"/>
                </Foreign_Address_Indicator>
                <Country xtt:fixedLength="25" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 25)"/>
                </Country>
                <Filler xtt:fixedLength="8" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 8)"/>
                </Filler>
                <Date_Of_Action xtt:fixedLength="8" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 8)"/>
                </Date_Of_Action>
                <Time_Of_Action xtt:fixedLength="6" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 6)"/>
                </Time_Of_Action>
                <System_Indicator xtt:fixedLength="1" xtt:required="false">
                    <xsl:sequence select="substring($spaces, 1, 1)"/>
                </System_Indicator>
            </Record>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>