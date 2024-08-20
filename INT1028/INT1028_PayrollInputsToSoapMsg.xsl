<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:wd="urn:com.workday/bsvc"
	xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs" version="3.0">

	<xsl:template match="/">
		<env:Envelope>
			<env:Body>
				<xsl:copy-of select="*"></xsl:copy-of>
			</env:Body>
		</env:Envelope>
	</xsl:template>

</xsl:stylesheet>