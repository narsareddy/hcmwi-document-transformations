<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:wd="urn:com.workday/bsvc"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="xs" version="3.0">

	<xsl:mode on-no-match="shallow-skip" />

	<xsl:param name="p.emplid" />
	<xsl:param name="p.Role_Action" />

	<xsl:template match="/wd:Report_Data">
		<file>
			<xsl:apply-templates />
		</file>
	</xsl:template>

	<xsl:template match="wd:Report_Entry">
		<xsl:for-each select="wd:Program_Data">
			<xsl:if
				test="$p.Role_Action = 'ADD' or (not(fn:empty(fn:index-of(../wd:Current_CostCenter_Managers/wd:ID[@wd:type = 'Employee_ID'], $p.emplid))) and fn:empty(fn:index-of(../wd:Previous_CostCenter_Managers/wd:ID[@wd:type = 'Employee_ID'], $p.emplid))) or not(wd:ID[@wd:type = 'Program_ID'] = ../wd:Previous_Program_Data/wd:ID[@wd:type  = 'Program_ID'])">
				<line>
					<reocrd_type>
						<xsl:text>720</xsl:text>
					</reocrd_type>
					<approval_type>
						<xsl:text>REQ</xsl:text>
					</approval_type>
					<employee_id>
						<xsl:value-of select="$p.emplid" />
					</employee_id>
					<segment_1>
						<xsl:value-of select="wd:ID[@wd:type = 'Program_ID']" />
					</segment_1>
					<segment_2>
						<xsl:value-of select="../wd:Cost_Center" />
					</segment_2>
					<segment_3>
						<xsl:text />
					</segment_3>
					<segment_4>
						<xsl:text />
					</segment_4>
					<segment_5>
						<xsl:text />
					</segment_5>
					<segment_6>
						<xsl:text />
					</segment_6>
					<segment_7>
						<xsl:text />
					</segment_7>
					<segment_8>
						<xsl:text />
					</segment_8>
					<segment_9>
						<xsl:text />
					</segment_9>
					<segment_10>
						<xsl:text />
					</segment_10>
					<exception_approval>
						<xsl:text />
					</exception_approval>
					<approval_limit>
						<xsl:text />
					</approval_limit>
					<approval_limit_curr_code>
						<xsl:text />
					</approval_limit_curr_code>
					<level>
						<xsl:text>2</xsl:text>
					</level>
				</line>
				<line>
					<reocrd_type>
						<xsl:text>720</xsl:text>
					</reocrd_type>
					<approval_type>
						<xsl:text>EXP</xsl:text>
					</approval_type>
					<employee_id>
						<xsl:value-of select="$p.emplid" />
					</employee_id>
					<segment_1>
						<xsl:value-of select="wd:ID[@wd:type = 'Program_ID']" />
					</segment_1>
					<segment_2>
						<xsl:value-of select="../wd:Cost_Center" />
					</segment_2>
					<segment_3>
						<xsl:text />
					</segment_3>
					<segment_4>
						<xsl:text />
					</segment_4>
					<segment_5>
						<xsl:text />
					</segment_5>
					<segment_6>
						<xsl:text />
					</segment_6>
					<segment_7>
						<xsl:text />
					</segment_7>
					<segment_8>
						<xsl:text />
					</segment_8>
					<segment_9>
						<xsl:text />
					</segment_9>
					<segment_10>
						<xsl:text />
					</segment_10>
					<exception_approval>
						<xsl:text />
					</exception_approval>
					<approval_limit>
						<xsl:text />
					</approval_limit>
					<approval_limit_curr_code>
						<xsl:text />
					</approval_limit_curr_code>
					<level>
						<xsl:text>2</xsl:text>
					</level>
				</line>
			</xsl:if>
		</xsl:for-each>
		<xsl:if
			test="$p.Role_Action = 'REMOVE' or (fn:empty(fn:index-of(wd:Current_CostCenter_Managers/wd:ID[@wd:type = 'Employee_ID'], $p.emplid)) and not(fn:empty(fn:index-of(wd:Previous_CostCenter_Managers/wd:ID[@wd:type = 'Employee_ID'], $p.emplid))))">
			<xsl:for-each select="wd:Program_Data">
				<line>
					<reocrd_type>
						<xsl:text>750</xsl:text>
					</reocrd_type>
					<approval_type>
						<xsl:text>REQ</xsl:text>
					</approval_type>
					<employee_id>
						<xsl:value-of select="$p.emplid" />
					</employee_id>
					<segment_1>
						<xsl:value-of select="wd:ID[@wd:type = 'Program_ID']" />
					</segment_1>
					<segment_2>
						<xsl:value-of select="../wd:Cost_Center" />
					</segment_2>
					<segment_3>
						<xsl:text />
					</segment_3>
					<segment_4>
						<xsl:text />
					</segment_4>
					<segment_5>
						<xsl:text />
					</segment_5>
					<segment_6>
						<xsl:text />
					</segment_6>
					<segment_7>
						<xsl:text />
					</segment_7>
					<segment_8>
						<xsl:text />
					</segment_8>
					<segment_9>
						<xsl:text />
					</segment_9>
					<segment_10>
						<xsl:text />
					</segment_10>
				</line>
				<line>
					<reocrd_type>
						<xsl:text>750</xsl:text>
					</reocrd_type>
					<approval_type>
						<xsl:text>EXP</xsl:text>
					</approval_type>
					<employee_id>
						<xsl:value-of select="$p.emplid" />
					</employee_id>
					<segment_1>
						<xsl:value-of select="wd:ID[@wd:type = 'Program_ID']" />
					</segment_1>
					<segment_2>
						<xsl:value-of select="../wd:Cost_Center" />
					</segment_2>
					<segment_3>
						<xsl:text />
					</segment_3>
					<segment_4>
						<xsl:text />
					</segment_4>
					<segment_5>
						<xsl:text />
					</segment_5>
					<segment_6>
						<xsl:text />
					</segment_6>
					<segment_7>
						<xsl:text />
					</segment_7>
					<segment_8>
						<xsl:text />
					</segment_8>
					<segment_9>
						<xsl:text />
					</segment_9>
					<segment_10>
						<xsl:text />
					</segment_10>
				</line>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>