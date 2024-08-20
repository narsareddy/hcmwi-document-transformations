<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:wd="urn:com.workday/bsvc">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/wd:Report_Data">
        <report_data>
            <xsl:apply-templates/>
        </report_data>
    </xsl:template>
    
    <xsl:template match="wd:Report_Entry">
        <report_entry>
            <worker_name>
                <xsl:value-of select="wd:Name"/>
            </worker_name>
            <count_of_all_positions>
                <xsl:value-of select="count(wd:Positions_for_Worker/wd:Position_ID)"/>
            </count_of_all_positions>
            <count_of_fws_positions>
                <xsl:value-of select="count(wd:Positions_for_Worker/wd:Position_ID[../wd:Org_Assignments[contains(wd:ID[@wd:type = 'Custom_Organization_Reference_ID'], 'FWS')] and not(exists(../wd:Org_Assignments[wd:ID[@wd:type = 'Custom_Organization_Reference_ID'] = 'Not_Work_Study_Student']))])"/>
            </count_of_fws_positions>
            <xsl:apply-templates/>
        </report_entry>
    </xsl:template>
    
    <xsl:template match="wd:Positions_for_Worker">
        <xsl:if
            test="exists(wd:Org_Assignments[contains(wd:ID[@wd:type = 'Custom_Organization_Reference_ID'], 'FWS')]) and not(exists(wd:Org_Assignments[wd:ID[@wd:type = 'Custom_Organization_Reference_ID'] = 'Not_Work_Study_Student']))">
            <position_id>
                <xsl:value-of select="wd:Position_ID"/>
            </position_id>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*"/>
    
</xsl:stylesheet>