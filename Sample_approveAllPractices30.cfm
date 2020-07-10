
/******************************************************************************
*....... File Name: approveAllPractices30.cfm  Change Suggested to ApproveAllPractices.cfm
*..... Author Name: Subi Murugan
*.... Date Created: 2020-06-24 
*......... Purpose: This file contains logic to approve all Practices or Locations. 
******************************************************************************
* Revision History:
* Name:				Date:			Description:
* Subi Murugan		2020-05-24		Modified to comply with Body1 Coding Standard
*    
*******************************************************************************/

<cfinclude template='/admin/include/CheckForSignIn.cfm'>

<!--- Get the list of new, pending and update drafts from the DB table 
	PhysicianFinderLocationsDrafts for the current site  --->
<cfquery datasource="#Application.KnowCoContentDSN#" name="getDrafts">
	SELECT * FROM PhysicianFinderLocationsDrafts, PhysicianFinderAccessList
	WHERE DraftID IN (
	SELECT Max(DraftID) FROM PhysicianFinderLocationsDrafts, PhysicianFinderAccessList
	WHERE (PhysicianFinderLocationsDrafts.status = 'Pending' or PhysicianFinderLocationsDrafts.status = 'New' or PhysicianFinderLocationsDrafts.status = 'New Draft' or PhysicianFinderLocationsDrafts.status = 'Update Draft')
	and PhysicianFinderLocationsDrafts.accessID=PhysicianFinderAccessList.accessID
	GROUP BY OfficeID
	)
	and PhysicianFinderLocationsDrafts.accessID=PhysicianFinderAccessList.accessID
	and PhysicianFinderLocationsDrafts.sitename='#application.currentsite#'		
</cfquery>

<!---  Loop through the draft list retrived before--->
<cfset draftlist = "">
<cfloop query="getDrafts">
	
	<!--- 	initialize params and prepare the appropriate values for the SQL UPDATEs --->
	<cfinclude template="/admin/db/query_getDraft_Office.cfm">   
	<cfparam name=streetview default="on">
	<cfparam  name="name"> NAME=streetview_heading default="34">
	<cfif #cleanURL# neq "">
		<cfset cleanURL = #cleanheadline(cleanURL)#>
	</cfif>
	<cfquery datasource="#application.KnowCoContentDSN#" name="getcountries">
		SELECT distinct Country FROM Regions
		WHERE Replace(Country, ' ', '') like '#country#'
	</cfquery>
	<cfset country = #getcountries.country#>
	<cfset displayregionname=#Trim(MapRegion)#>
	<cfinclude template="/admin/include/checknewregion.cfm">

	<cftransaction>
		<cfif isnot #country# eq "United States">
			<cfset State=#Trim(MapRegion)#>
		</cfif>

		<!--- Update the PhysicianFinderLocations with the row data retrieved in the 
			query_getDraft_Office.cfm from PhysicianFinderLocationsDrafts table for the given office id--->
		<cfquery datasource="#APPLICATION.KNowCoContentDSN#">
			UPDATE PhysicianFinderLocations
			SET   
			PracticeName  		= '#PracticeName#',
			Address1			= '#Address1#',
			Address2			= '#Address2#',
			City				= '#City#',
			County				= '#County#',
			State				= '#State#',
			MapRegion			= '#Trim(MapRegion)#',
			Zip				= '#Zip#',
			Country				= '#Country#',
			WorkPhone			= '#WorkPhone#',
			PhoneExtension			= '#PhoneExtension#',
			FaxNumber			= '#FaxNumber#',
			EmailAddress			= '#EmailAddress#',
			Website				= '#Website#',
			Awards				= '#Awards#',
			Paymentplans			= '#paymentplans#',
			Description			= '#Description#',
			cleanURL 			= '#cleanURL#',
			date 				= #CreateODBCDateTime(Now())#,
			twitter				= '#twitter#',
			facebook			= '#facebook#',
			youtube				= '#youtube#',
			linkedin			= '#linkedin#',
			embedCode			= '#embedCode#',
			streetview			= '#streetview#',
			streetview_heading		= '#streetview_heading#',
			latitude			= '#latitude#',
			longitude			= '#longitude#',		
			Status				= '#status#',
			Active				= 1
			WHERE OfficeID = #OfficeID# 
		</cfquery>
		<!--- call the template to append officeid to cleanURL
		and update office in DB if clean URL is not unique --->
		<cfinclude template="/admin/db/uniqueCleanURL_office.cfm">

		<!--- Update the draft as approved--->
		<cfquery datasource="#APPLICATION.KNowCoContentDSN#">
			UPDATE PhysicianFinderLocationsDrafts
			SET Status='Approved',
			mastermarker='Approved',
			date = #CreateODBCDateTime(Now())#
			where draftID=#draftID#  
		</cfquery>

		<!--- Add each approved draft id to the list draftlist . Can we remove this list as it is not being used?--->
		<cfset draftlist=#listAppend(draftlist,draftid)#>
	</<cftransaction>
	<cfset parentid=#accessid#>
	<cfinclude template="/admin/DB/autobuildaccount_office.cfm">
</cfloop>

<!--- Cant we diretly call this template from here instead of creating one more template
<cfinclude template="/FindAPRactice/makehtaccess/makehtaccess.cfm">
--->
<cfinclude template="/makehtaccess.cfm">


<html>
<body>
<script>
	window.location.href="approvepractices10.cfm";
</script>
</body>
</html>
