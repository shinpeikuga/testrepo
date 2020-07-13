/******************************************************************************
*....... File Name: autoCreateReportAll.cfm  
*..... Author Name: Shinpei Kuga
*.... Date Created: 2020-07-09
*......... Purpose: This file is run daily from scheduler to generate reports which PFS stats uses
******************************************************************************
* Revision History:
* Name:				Date:			Description:
* Shinpei Kuga		2020-07-09n		Added try-catch block to detect failures on scheduled task
*
*******************************************************************************/

<cftry>
	<cfinclude template="autocreatereport10.cfm">
	<cfinclude template="autocreatereportZip10.cfm">
	<cfinclude template="autocreatereportDaily10.cfm">
	<cfinclude template="autocreatereportWeekly.cfm">
		<cfcatch>
			<cfinclude template="mailReportingError.cfm">
		</cfcatch>
</cftry>

