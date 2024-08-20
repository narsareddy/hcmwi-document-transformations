<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:bc="urn:com.workday/bc"
    exclude-result-prefixes="xs" version="3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xtt="urn:com.workday/xtt" xmlns:etv="urn:com.workday/etv"
    xmlns:mdto="urn:com.workday/multiDocumentTransform/Output"
    xmlns:mdti="urn:com.workday/multiDocumentTransform/Input">
    
    <!--XTT Requires an input of well formed XML. Therefore, our XSLT must output XML and the XTT will handle the final transformation to text.-->
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:mode use-accumulators="#all" on-no-match="shallow-skip"/>
    
    <xsl:variable name="noValue" select="'N'"/>
    <xsl:variable name="today" select="format-date(current-date(), '[M01]/[D01]/[Y0001]')"/>
    
    <xsl:accumulator name="dependent-number" as="xs:integer" initial-value="0">
        <xsl:accumulator-rule match="bc:Employee" select="0"/>
        <xsl:accumulator-rule match="bc:Dependent/bc:Dependent_ID">
            <xsl:choose>
                <xsl:when test="(string-length(text()) eq 15)">
                    <xsl:value-of select="number(substring(text(), 14, 2))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value + 1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:accumulator-rule>
    </xsl:accumulator>
    
    <xsl:template match="/">
        <mdto:Files>
            <mdto:File mdto:filename="HR513.txt" mdto:deliverable="true"
                mdto:retentionPeriod="P180D" mdto:applyXTT="true" mdto:applyETV="true">
                <File xtt:separator="&#xd;&#xa;" xtt:severity="warning">
                    <Header xtt:separator=",">
                        <HeaderItem1>Fc</HeaderItem1>
                        <HeaderItem2>Company</HeaderItem2>
                        <HeaderItem3>Employee</HeaderItem3>
                        <HeaderItem4>SeqNbr</HeaderItem4>
                        <HeaderItem5>LastName</HeaderItem5>
                        <HeaderItem6>FirstName</HeaderItem6>
                        <HeaderItem7>MiddleInit</HeaderItem7>
                        <HeaderItem8>FicaNbr</HeaderItem8>
                        <HeaderItem9>EmpAddress</HeaderItem9>
                        <HeaderItem10>RelCode</HeaderItem10>
                        <HeaderItem11>DepType</HeaderItem11>
                        <HeaderItem12>Birthdate</HeaderItem12>
                        <HeaderItem13>Sex</HeaderItem13>
                        <HeaderItem14>Smoker</HeaderItem14>
                        <HeaderItem15>Student</HeaderItem15>
                        <HeaderItem16>Disabled</HeaderItem16>
                        <HeaderItem17>PrimaryCare</HeaderItem17>
                        <HeaderItem18>HlCovFlag</HeaderItem18>
                        <HeaderItem19>DnCovFlag</HeaderItem19>
                        <HeaderItem20>DlCovFlag</HeaderItem20>
                        <HeaderItem21>Addr1</HeaderItem21>
                        <HeaderItem22>Addr2</HeaderItem22>
                        <HeaderItem23>Addr3</HeaderItem23>
                        <HeaderItem24>Addr4</HeaderItem24>
                        <HeaderItem25>City</HeaderItem25>
                        <HeaderItem26>State</HeaderItem26>
                        <HeaderItem27>Zip</HeaderItem27>
                        <HeaderItem28>CountryCode</HeaderItem28>
                        <HeaderItem29>HmPhoneCntry</HeaderItem29>
                        <HeaderItem30>HmPhoneNbr</HeaderItem30>
                        <HeaderItem31>WkPhoneCntry</HeaderItem31>
                        <HeaderItem32>WkPhoneNbr</HeaderItem32>
                        <HeaderItem33>WkPhoneExt</HeaderItem33>
                        <HeaderItem34>AdoptionDate</HeaderItem34>
                        <HeaderItem35>PlacementDate</HeaderItem35>
                        <HeaderItem36>Consent</HeaderItem36>
                        <HeaderItem37>ActiveFlag</HeaderItem37>
                        <HeaderItem38>LastNamePre</HeaderItem38>
                        <HeaderItem39>NameSuffix</HeaderItem39>
                        <HeaderItem40>Deceased</HeaderItem40>
                        <HeaderItem41>DateOfDeath</HeaderItem41>
                        <HeaderItem42>PriorMonthsCov</HeaderItem42>
                        <HeaderItem43>EstabPatient</HeaderItem43>
                        <HeaderItem44>EffectDate</HeaderItem44>
                    </Header>
                    <xsl:apply-templates/>
                </File>
            </mdto:File>
        </mdto:Files>
    </xsl:template>
    
    <xsl:template match="bc:Employee">
        <xsl:if
            test="bc:Additional_Information/bc:Campus_ID ne '' 
                and bc:Additional_Information/bc:Campus_ID_Begins_With_99 = 'Y'
                and (bc:Personal/bc:Home_Country = 'USA' 
                    or bc:Additional_Information/bc:Mailing_Address_Country = 'USA' 
                    or bc:Additional_Information/bc:Local_Address_Country = 'USA')">
            <xsl:for-each select="bc:Dependent">
                <xsl:sort select="bc:Dependent_ID"/>
                <xsl:if
                    test="bc:Dependent_ID = ..//bc:Health_Plan/bc:Dependent_Coverage/bc:Dependent_ID 
                        and bc:Social_Security_Number ne '' 
                        and (bc:Operation != 'NONE' 
                        or ../bc:Health_Plan/bc:Dependent_Coverage[bc:Dependent_ID = bc:Dependent_ID]/bc:Operation != 'NONE')">
                    <Record xtt:separator=",">
                        <Fc>
                            <xsl:choose>
                                <xsl:when test="bc:Operation eq 'ADD'">
                                    <xsl:text>A</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>C</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </Fc>
                        <Company>
                            <xsl:text>7</xsl:text>
                        </Company>
                        <Employee>
                            <xsl:value-of select="../bc:Additional_Information/bc:Campus_ID"/>
                        </Employee>
                        <SeqNbr>
                            <xsl:value-of
                                select="format-number(accumulator-after('dependent-number'), '00')"/>
                        </SeqNbr>
                        <LastName xtt:quotes="always" xtt:quoteStyle="double">
                            <xsl:value-of select="upper-case(bc:Last_Name)"/>
                        </LastName>
                        <FirstName xtt:quotes="always" xtt:quoteStyle="double">
                            <xsl:value-of select="upper-case(bc:First_Name)"/>
                        </FirstName>
                        <MiddleInit>
                            <xsl:value-of select="upper-case(substring(bc:Middle_Name, 1, 1))"/>
                        </MiddleInit>
                        <FicaNbr>
                            <xsl:value-of
                                select="concat(substring(bc:Social_Security_Number, 1, 3), '-', substring(bc:Social_Security_Number, 4, 2), '-', substring(bc:Social_Security_Number, 6, 4))"
                            />
                        </FicaNbr>
                        <EmpAddress/>
                        <RelCode etv:direction="out" etv:map="Relationship Code"
                            etv:mapAppliedOnEmptyInput="true">
                            <xsl:value-of select="bc:Relationship"/>
                        </RelCode>
                        <DepType etv:direction="out" etv:map="Dependent Type"
                            etv:mapAppliedOnEmptyInput="true">
                            <xsl:value-of select="bc:Relationship"/>
                        </DepType>
                        <Birthdate xtt:dateFormat="MM/dd/yyyy">
                            <xsl:value-of select="bc:Birth_Date"/>
                        </Birthdate>
                        <Sex>
                            <xsl:value-of select="bc:Gender"/>
                        </Sex>
                        <Smoker/>
                        <Student/>
                        <Disabled>
                            <xsl:choose>
                                <xsl:when test="bc:Disabled eq '0'">
                                    <xsl:text>N</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Y</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </Disabled>
                        <PrimaryCare/>
                        <HlCovFlag>
                            <xsl:value-of select="$noValue"/>
                        </HlCovFlag>
                        <DnCovFlag>
                            <xsl:value-of select="$noValue"/>
                        </DnCovFlag>
                        <DlCovFlag>
                            <xsl:value-of select="$noValue"/>
                        </DlCovFlag>
                        <Addr1/>
                        <Addr2/>
                        <Addr3/>
                        <Addr4/>
                        <City/>
                        <State/>
                        <Zip/>
                        <CountryCode/>
                        <HmPhoneCntry/>
                        <HmPhoneNbr/>
                        <WkPhoneCntry/>
                        <WkPhoneNbr/>
                        <WkPhoneExt/>
                        <AdoptionDate>
                            <xsl:text>00/00/0000</xsl:text>
                        </AdoptionDate>
                        <PlacementDate>
                            <xsl:text>00/00/0000</xsl:text>
                        </PlacementDate>
                        <Consent/>
                        <ActiveFlag>
                            <xsl:choose>
                                <xsl:when test="(bc:Relationship = 'Ex-Spouse'
                                    or ../bc:Additional_Information/bc:Active_Status != 'Y')
                                    and (count(../bc:Health_Plan/bc:Dependent_Coverage[bc:Dependent_ID = bc:Dependent_ID]) = 0
                                    or (count(../bc:Health_Plan/bc:Dependent_Coverage[bc:Dependent_ID = bc:Dependent_ID]) = count(../bc:Health_Plan/bc:Dependent_Coverage[bc:Dependent_ID = bc:Dependent_ID]/bc:Coverage_End_Date)
                                    and max(../bc:Health_Plan/bc:Dependent_Coverage[bc:Dependent_ID = bc:Dependent_ID]/bc:Coverage_End_Date/xs:date(.)) lt current-date()))">
                                    <xsl:text>I</xsl:text>
                                </xsl:when>
                                <xsl:when test="exists(bc:Inactive_Date)">
                                    <xsl:text>I</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>A</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ActiveFlag>
                        <LastNamePre/>
                        <NameSuffix>
                            <xsl:value-of select="bc:Social_Suffix"/>
                        </NameSuffix>
                        <Deceased>
                            <xsl:value-of select="$noValue"/>
                        </Deceased>
                        <DateOfDeath>
                            <xsl:text>00/00/0000</xsl:text>
                        </DateOfDeath>
                        <PriorMonthsCov/>
                        <EstabPatient/>
                        <EffectDate>
                            <xsl:value-of select="$today"/>
                        </EffectDate>
                    </Record>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>