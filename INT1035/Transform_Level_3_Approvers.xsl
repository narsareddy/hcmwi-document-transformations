<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:wd="urn:com.workday/bsvc" exclude-result-prefixes="xs"
	version="3.0">

	<xsl:mode on-no-match="shallow-skip" />

	<xsl:template match="/wd:Report_Data">
		<file>
			<xsl:apply-templates />
		</file>
	</xsl:template>

	<xsl:template
		match="wd:Report_Entry[wd:ATO_or_DeanVP_Status_Changed eq '1']">
		<line>
			<xsl:choose>
				<xsl:when test="wd:Is_ATO_or_DeanVP eq '1'">
					<reocrd_type>
						<xsl:text>720</xsl:text>
					</reocrd_type>
					<approval_type>
						<xsl:text>REQ</xsl:text>
					</approval_type>
					<employee_id>
						<xsl:value-of select="wd:Employee_ID" />
					</employee_id>
					<segment_1>
						<xsl:text />
					</segment_1>
					<segment_2>
						<xsl:text />
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
						<xsl:text>3</xsl:text>
					</level>
				</xsl:when>
				<xsl:otherwise>
					<reocrd_type>
						<xsl:text>750</xsl:text>
					</reocrd_type>
					<approval_type>
						<xsl:text>REQ</xsl:text>
					</approval_type>
					<employee_id>
						<xsl:value-of select="wd:Employee_ID" />
					</employee_id>
					<segment_1>
						<xsl:text />
					</segment_1>
					<segment_2>
						<xsl:text />
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
				</xsl:otherwise>
			</xsl:choose>
		</line>
		<line>
			<xsl:choose>
				<xsl:when test="wd:Is_ATO_or_DeanVP eq '1'">
					<reocrd_type>
						<xsl:text>720</xsl:text>
					</reocrd_type>
					<approval_type>
						<xsl:text>EXP</xsl:text>
					</approval_type>
					<employee_id>
						<xsl:value-of select="wd:Employee_ID" />
					</employee_id>
					<segment_1>
						<xsl:text />
					</segment_1>
					<segment_2>
						<xsl:text />
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
						<xsl:text>3</xsl:text>
					</level>
				</xsl:when>
				<xsl:otherwise>
					<reocrd_type>
						<xsl:text>750</xsl:text>
					</reocrd_type>
					<approval_type>
						<xsl:text>EXP</xsl:text>
					</approval_type>
					<employee_id>
						<xsl:value-of select="wd:Employee_ID" />
					</employee_id>
					<segment_1>
						<xsl:text />
					</segment_1>
					<segment_2>
						<xsl:text />
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
				</xsl:otherwise>
			</xsl:choose>
		</line>
	</xsl:template>

</xsl:stylesheet>