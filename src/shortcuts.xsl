<?xml version="1.0" ?> 
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:wix="http://schemas.microsoft.com/wix/2006/wi"> 

<xsl:output omit-xml-declaration="yes" indent="yes" encoding="utf-8"/>
<xsl:strip-space  elements="*"/>


<xsl:template match="@*|*">
		<xsl:copy>
				<xsl:apply-templates select="@*" />
				<xsl:apply-templates select="*" />
		</xsl:copy>
</xsl:template>

<xsl:output method="xml" indent="yes" />

<xsl:template match="wix:File[@Source='$(var.SRC)\[% lang %]\index.html']">
	<xsl:copy-of select="."/>
						<Shortcut Id="desktoplink"
							Advertise="yes"
							Directory="DesktopFolder"
							Name="!(loc.ApplicationName)"
							Icon="APP.ico"
							WorkingDirectory="pt.kle.cz"
							xmlns="http://schemas.microsoft.com/wix/2006/wi" />

						<Shortcut Id="startmenulink"
							Advertise="yes"
							Directory="ProgramMenuFolder"
							Name="!(loc.ApplicationName)"
							Icon="APP.ico"
							WorkingDirectory="pt.kle.cz"
							xmlns="http://schemas.microsoft.com/wix/2006/wi" />

</xsl:template>

</xsl:stylesheet>
