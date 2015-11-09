<cfsetting enablecfoutputonly="true">
<!--- @@displayname: Description Cell --->

<cfif NOT len(stObj.description)>
	<cfset stObj.description = "<em>No description</em>">
</cfif>

<cfif len(stObj.relatedTypename) AND isValid("uuid", stObj.relatedObjectUUID)>
	<cfset title = application.fapi.getContentTypeMetadata(typename=stObj.relatedTypename, md="displayname")>
	<cfoutput><a href="##" onclick="$fc.objectAdminAction('#jsStringFormat(title)#', '#application.fapi.getLink(objectid=stObj.relatedObjectUUID,type=stObj.relatedTypename,view='webtopPageModal',bodyView='webtopOverview')#');return false;" title="View Related Object"><i class="fa fa-external-link fa-fw"></i></a> #stObj.description#</cfoutput>
<cfelse>
	<cfoutput>#stObj.description#</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false">