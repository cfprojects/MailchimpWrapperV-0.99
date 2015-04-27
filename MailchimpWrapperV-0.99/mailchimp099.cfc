<cfcomponent displayname="MailChimp" hint="I use the Mail Chimp API">
<cfset instance.variables.serviceURL = "">
<cfset instance.variable.output = "">


	<cffunction name="init" access="public" returntype="Any">
		<cfargument name="apikey" required="true">
		<cfargument name="serviceURL" required="true" type="string"/>
		<cfargument name="output" required="false" default="xml" type="string"/>
	
		<cfset setServiceURL(arguments.serviceURL) />
		<cfset setOutput(arguments.output)/>
		<cfset setApiKey(arguments.apikey)>					
		<cfreturn this />
	</cffunction>

	<cffunction name="isEmail" access="private" hint="I check if the e-mail address is formatted ok">
		<cfargument name="str" required="true" type="string">
			<cfset var IsEmail = (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1>
			<!---  
				* @author Jeff Guillaume (jeff@kazoomis.com)
 			   	* @version 6, July 29, 2008 
			--->	
			
		<cfreturn isEmail> 
	
	</cffunction>

	<cffunction name="login" access="public" returntype="string" 
				hint="I login into mailchimp and get apikey back">

		<cfhttp url="#getServiceURL()#" method="post">
			<cfhttpparam name="username" value="#getUsername()#" type="URL">
			<cfhttpparam name="password" value="#getPassword()#" type="URL">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="login" type="URL">
		</cfhttp>	
	
		<cfset xmlReturn = xmlparse(cfhttp.filecontent)>
		<!--- <cfdump var="#xmlReturn#"> --->
		<cfif Isdefined("xmlreturn.mcapi.error")>
			<cfreturn xmlreturn.mcapi.error.xmltext />
		<cfelse>			
			<cfreturn xmlreturn.mcapi.xmltext />
		</cfif>	
	</cffunction>
	
	<cffunction name="listBatchSubscribe" access="public" Returntype="Any" 
				hint="I subscribe a set of members to a list">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfargument name="subscribers" required="true" type="query">
		<cfargument name="sendOptInConfirm" required="false" type="boolean" default="0">
		<cfargument name="updateExisting" required="false" type="boolean" default="1">
		<cfargument name="replaceGroups" required="false" type="boolean" default="0">
			
		<cfhttp url="#getServiceURL()#" method="post">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="listBatchSubscribe" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="id" value="#arguments.id#" type="url">
			<cfhttpparam name="double_optin" value="#arguments.sendOptInConfirm#" type="url">
			<cfhttpparam name="update_existing" value="#arguments.updateExisting#" type="url">
			<cfhttpparam name="replaceInterests" value="#arguments.replaceGroups#" type="url">
		
			<cfloop query="arguments.subscribers">
				<cfhttpparam name="batch[#currentrow#][EMAIL]" value="#email#" type="url">
				<cfhttpparam name="batch[#currentrow#][FNAME]" value="#firstname#" type="url">
				<cfhttpparam name="batch[#currentrow#][LNAME]" value="#lastname#" type="url">
				<cfhttpparam name="batch[#currentrow#][INTERESTS]" value="#groups#" type="url">
			</cfloop>
		</cfhttp>
		
		<cfdump var="#cfhttp#">
			
		<!--- <cfset xmlReturn = xmlParse(cfhttp.filecontent)> --->
						
		<cfreturn cfhttp.filecontent>	
		
	</cffunction>
	<cffunction name="listBatchUnsubscribe" access="public" Returntype="Any" hint="I subscribe the provided e-mail to a list">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfargument name="subscribers" required="true" type="query">
		<cfargument name="delete_member" required="false" type="boolean" default="1">
		<cfargument name="send_goodbye" required="false" type="boolean" default="0">
		<cfargument name="send_notify" required="false" type="boolean" default="0">
		
		
		<cfhttp url="#getServiceURL()#" method="post">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="listBatchUnsubscribe" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="id" value="#arguments.id#" type="url">
			<cfhttpparam name="delete_member" value="#arguments.delete_member#" type="url">
			<cfhttpparam name="send_goodbye" value="#arguments.send_goodbye#" type="url">
			<cfhttpparam name="send_notify" value="#arguments.send_notify#" type="url">
		
			<cfloop query="arguments.subscribers">
				<!--- We create the emails array  --->
				<cfhttpparam name="emails[#currentrow#]" value="#email#" type="url">
			</cfloop>
		</cfhttp>
		
		<cfdump var="#cfhttp#">
			
		<!--- <cfset xmlReturn = xmlParse(cfhttp.filecontent)> --->
						
		<cfreturn cfhttp.filecontent>	
		
	</cffunction>
	
	<cffunction name="listInterestGroupAdd" access="public" Returntype="Any" 
				hint="I add a group to a list.">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfargument name="groupName" required="true" type="string">
	
		<cfhttp url="#getServiceURL()#" method="post">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="listInterestGroupAdd" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="id" value="#arguments.id#" type="url">
			<cfhttpparam name="group_name" value="#arguments.groupName#" type="url"> 
		</cfhttp>
	
		<!---  <cfdump var="#cfhttp#"> --->
		<cfset xmlReturn = xmlparse(cfhttp.filecontent)>
		
		<!--- What kind of error message handling do we need? --->
		<cftry>
			<cfset xmlReturn = xmlparse(cfhttp.filecontent)>
			<cfcatch>
				<cfthrow message="Unable to load  - Invalid XML returned.">
			</cfcatch>
		</cftry>
		 
		<cfreturn xmlReturn>	
	
	</cffunction>
	
	<cffunction name="listInterestGroupDel" access="public" Returntype="Any" 
				hint="I delete a particular interest group of a list.">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfargument name="groupName" required="true" type="string">
	
		<cfhttp url="#getServiceURL()#" method="post">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="listInterestGroupDel" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="id" value="#arguments.id#" type="url">
			<cfhttpparam name="group_name" value="#arguments.groupName#" type="url"> 
		</cfhttp>
	
		<!---  <cfdump var="#cfhttp#"> --->
		<cfset xmlReturn = xmlparse(cfhttp.filecontent)>
		
		<!--- What kind of error message handling do we need? --->
		<cftry>
			<cfset xmlReturn = xmlparse(cfhttp.filecontent)>
			<cfcatch>
				<cfthrow message="Unable to load  - Invalid XML returned.">
			</cfcatch>
		</cftry>
		 
		<cfreturn xmlReturn>	
	
	</cffunction>
	
	<cffunction name="listMemberInfo" access="public" Returntype="Any" 
				hint="I list all the information for a particular member of a list">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfargument name="email" required="true" type="string">
	
		<cfset var result = "">
		<cfset var xmlResult = "">
		<cfset var strMember = StructNew()>
		<cfset var lstFields = "id,email,email_type,ip_opt,ip_signup">
		<cfset var lstStandardMerges = "fname,lname,interests">
		<cfset var arrFieldKeys = ListToArray(lstFields)>
		<cfset var arrStandardMergeKeys = ListToArray(lstStandardMerges)>
		<cfset var mergecount = 0>
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="listMemberInfo" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="id" value="#arguments.id#" type="url">
			<cfhttpparam name="email_address" value="#arguments.email#" type="url"> 
		</cfhttp>
	
		<!--- <cfdump var="#result#"> ---> 
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		
		<!--- <cfdump var="#xmlResult#"> --->
		
		<cfloop from="1" to="#Arraylen(arrFieldKeys)#" index="k">
			<cfset strMember["#arrFieldKeys[k]#"] = xmlResult.mcapi["#arrFieldKeys[k]#"].xmltext>
		</cfloop>
		
	 	<cfloop from="1" to="#Arraylen(arrStandardMergeKeys)#" index="s">
			<cfset strMember["#arrStandardMergeKeys[s]#"] = xmlResult.mcapi.merges["#arrStandardMergeKeys[s]#"].xmltext>
		</cfloop> 
		
		<!--- <cfdump var="#xmlResult.mcapi.merges#"> --->
		
		<cfloop from="1" to="#ArrayLen(xmlResult.mcapi.merges.xmlchildren)#" index="m">
			<cfif Left(xmlResult.mcapi.merges.xmlchildren[m].xmlName,5) EQ  "MERGE">
				<cfset strMember["#xmlResult.mcapi.merges.xmlchildren[m].xmlName#"] = xmlResult.mcapi.merges.xmlchildren[m].xmlText>
			</cfif>
		</cfloop>
		
		<cfreturn strMember>	
	
	</cffunction>
	
	<cffunction name="listMembers" access="public" Returntype="Any" 
				hint="I hold all subscribers of a specific list of a particular status.">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfargument name="status" required="true" type="string" default="subscribed">
		<cfargument name="start" required="false" type="numeric" default="1">
		<cfargument name="limit" required="false" type="numeric" default="200">
	
		<cfset var result = "">
		<cfset var xmlResult = "">
		<cfset var qryMembers = QueryNew("email,status,timestamp")>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="listMembers" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="id" value="#arguments.id#" type="url">
			<cfhttpparam name="status" value="#arguments.status#" type="url">
			<cfhttpparam name="start" value="#arguments.start#" type="url">
			<cfhttpparam name="limit" value="#arguments.limit#" type="url">
			 
		</cfhttp>
	
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		
		<cfloop from="1" to="#ArrayLen(xmlResult.mcapi.struct)#" index="i">
			<cfset QueryAddRow(qryMembers)>
			<cfset QuerySetCell(qryMembers, "email",xmlResult.mcapi.struct[i].email.XmlText)>
			<cfset QuerySetCell(qryMembers, "status",arguments.status)>
			<cfset QuerySetCell(qryMembers, "timestamp",xmlResult.mcapi.struct[i].timestamp.XmlText)>
		</cfloop>
		<cfreturn qryMembers>	
	
	</cffunction>
		
	<cffunction name="lists" access="public" returntype="any" hint="I get a list of lists, as query">
		<cfargument name="apiKey" required="true">
		<cfset var result = "">
		<cfset var xmlResult = "">
		<cfset var qryLists = QueryNew("id, name, createdOn, memberCount")>
		
	 	<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="lists" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
		</cfhttp>	
	
	<!--- 	<cfdump var="#result#"> --->
		<cfset xmlResult = xmlParse(result.filecontent)>
		
		<cfif StructKeyExists(xmlResult.mcapi,"struct")>		
			<cfloop from="1" to="#ArrayLen(xmlResult.mcapi.struct)#" index="i">
				 <cfset QueryAddRow(qryLists)>
				 <cfset QuerySetCell(qryLists, "id", xmlResult.mcapi.struct[i].id.xmlText)>
				 <cfset QuerySetCell(qryLists, "name", xmlResult.mcapi.struct[i].name.xmlText)>
				 <cfset QuerySetCell(qryLists, "createdOn",xmlResult.mcapi.struct[i].date_created.xmlText)>
				 <cfset QuerySetCell(qryLists, "memberCount", xmlResult.mcapi.struct[i].member_count.xmlText)>
			 </cfloop>
		</cfif>	
		
		<!--- <cfdump var="#qryLists#"> --->		
		<cfreturn qryLists>
	</cffunction>

	<cffunction name="listInterestGroups" access="public" Returntype="Any" 
				hint="I get the list of groups in a list">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfset var result = "">
		<cfset var xmlResult = "">
		<cfset var lstKeys = "name,form_field,groups">
		<cfset var strInterestGroups = StructNew()>
		<cfset var arrKeys = ListToArray(lstKeys)>
				
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="listInterestGroups" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="id" value="#arguments.id#" type="url">
		</cfhttp>
	
		<!--- 	<cfdump var="#result#"> ---> 
		<cfset xmlResult = xmlParse(result.filecontent)>
		<!--- <cfdump var="#xmlResult.mcapi.form_field#"> ---> 
				
		 <cfloop from="1" to="#ArrayLen(arrKeys)#" index="k">
				<cfset strInterestGroups["#arrKeys[k]#"] = xmlResult.mcapi["#arrKeys[k]#"].xmltext>
		</cfloop> 
	
		<cfif ArrayLen(xmlResult.mcapi.groups.struct)>
			<cfset strInterestGroups.groups = ArrayNew(1)>
			<cfloop from="1" to="#ArrayLen(xmlResult.mcapi.groups.struct)#" index="g">
				<cfset strInterestgroups.groups[g] = #xmlResult.mcapi.groups.struct[g].xmltext#>
			</cfloop> 
		</cfif> 
	
		<cfreturn strInterestGroups>
	</cffunction>

	<cffunction name="listSubscribe" access="public" Returntype="Any" hint="I subscribe the provided e-mail to a list">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfargument name="email" required="true" type="string">
		<cfargument name="firstname" required="false" type="string">
		<cfargument name="lastname" required="false" type="string">
		<cfargument name="groups" required="false" type="string">
		<cfargument name="sendOptInConfirm" required="false" type="boolean" default="0">
		
		<cfdump var="#arguments#">
	
		<cfif IsEmail(arguments.email)>
			<cfhttp url="#getServiceURL()#" method="post">
				<cfhttpparam name="output" value="#getOutput()#" type="url">
				<cfhttpparam name="method" value="listSubscribe" type="URL">
				<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
				<cfhttpparam name="id" value="#arguments.id#" type="url">
				<cfhttpparam name="email_address" value="#arguments.email#" type="url">
				<cfhttpparam name="double_optin" value="#arguments.sendOptInConfirm#" type="url">
				
				<cfif trim(arguments.firstname) NEQ "">
					<cfhttpparam name="merge_vars[FNAME]" value="#arguments.firstname#" type="url">
				</cfif>
				<cfif trim(arguments.lastname) NEQ "">
					<cfhttpparam name="merge_vars[LNAME]" value="#arguments.lastname#" type="url">
				</cfif>
				<cfif trim(arguments.groups) NEQ "">
					<cfhttpparam name="merge_vars[INTERESTS]" value="#arguments.groups#" type="url">
				</cfif>
			</cfhttp>
			
			<!--- <cfdump var="#subscribe#"> --->
				<cfset xmlResult = xmlParse(cfhttp.filecontent)>
				<cfdump var="#xmlResult#">		
			<cfreturn xmlResult.mcapi>
		<cfelse>
			<cfreturn "Sorry, not a valid e-mail address.">
		</cfif>
		
	</cffunction>
	
	<cffunction name="listUnsubscribe" access="public" Returntype="Any" 
				hint="I unsubscribe the provided e-mail from a list">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="id" required="true" type="string">
		<cfargument name="email" required="true" type="string">
		<cfargument name="delete_member" required="false" type="boolean" default="1">
		<cfargument name="send_goodbye" required="false" type="boolean" default="0">
		<cfargument name="send_notify" required="false" type="boolean" default="0">
		
		
		<cfhttp url="#getServiceURL()#" method="post">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="listUnsubscribe" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="id" value="#arguments.id#" type="url">
			<cfhttpparam name="delete_member" value="#arguments.delete_member#" type="url">
			<cfhttpparam name="send_goodbye" value="#arguments.send_goodbye#" type="url">
			<cfhttpparam name="send_notify" value="#arguments.send_notify#" type="url">
			<cfhttpparam name="email_address" value="#arguments.email#" type="url">
		</cfhttp>
		
		<cfdump var="#cfhttp#">
			
		<!--- <cfset xmlReturn = xmlParse(cfhttp.filecontent)> --->
						
		<cfreturn cfhttp.filecontent>	
		
	</cffunction>
	
	<cffunction name="campaignContent" access="public" returntype="Any" hint="I create a new draft campaign to send">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="cid" required="true" type="string">
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var campaign = StructNew()>
	
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignContent" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="cid" value="#arguments.cid#" type="url">
		</cfhttp>
		
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		
		<cfset campaign.id = arguments.cid>
		<cfset campaign.html = xmlResult.mcapi.html>
		<cfset campaign.text = xmlResult.mcapi.text>
		
		<cfreturn campaign>
	</cffunction>
	
	<cffunction name="campaigns" access="public" Returntype="Any" hint="I get all campaigns.">
		<cfargument name="apikey" required="true" type="string">
		<cfset var result = "">
		<cfset var xmlresult = "">
		<cfset var qryCampaigns = QueryNew("id,list_id,folder_id,title,type,create_time,send_time,status,from_name,from_email,subject,to_email,archive_url,emails_sent,inline_css")>
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaigns" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
		</cfhttp>	
		
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		<cfif Isdefined("xmlResult.mcapi.struct")>		
			<cfloop from="1" to="#ArrayLen(xmlResult.mcapi.struct)#" index="i">
				<cfset QueryAddRow(qryCampaigns)>
				<cfset QuerySetCell(qryCampaigns, "id",xmlResult.mcapi.struct[i].id.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "list_id",xmlResult.mcapi.struct[i].list_id.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "folder_id",xmlResult.mcapi.struct[i].folder_id.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "title",xmlResult.mcapi.struct[i].title.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "type",xmlResult.mcapi.struct[i].type.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "create_time",xmlResult.mcapi.struct[i].create_time.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "send_time",xmlResult.mcapi.struct[i].send_time.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "status",xmlResult.mcapi.struct[i].status.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "from_name",xmlResult.mcapi.struct[i].from_name.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "from_email",xmlResult.mcapi.struct[i].from_email.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "subject",xmlResult.mcapi.struct[i].subject.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "to_email",xmlResult.mcapi.struct[i].to_email.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "archive_url",xmlResult.mcapi.struct[i].archive_url.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "emails_sent",xmlResult.mcapi.struct[i].emails_sent.xmlText)>
				<cfset QuerySetCell(qryCampaigns, "inline_css",xmlResult.mcapi.struct[i].inline_css.xmlText)>
			</cfloop>		 
		</cfif>
		
		<!--- <cfdump var="#qryCampaigns#"> --->
		
		<cfreturn qryCampaigns>
		
	</cffunction>
	
	<cffunction name="campaignStats" access="public" returntype="Any" hint="I get all the relevant campaign statistics (opens, bounces, clicks, etc.) ">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="cid" required="true" type="string">
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var strStats = structNew()>
		<cfset var lstInfo = "syntax_errors,hard_bounces,soft_bounces,unsubscribes,abuse_reports,forwards,forwards_opens,opens,last_open,unique_opens,clicks,unique_clicks,users_who_clicked,last_click,emails_sent">
		<cfset var arrKeys = ListToArray(lstInfo)>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignStats" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="cid" value="#arguments.cid#" type="url">
		</cfhttp>
		
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		<!--- <cfdump var="#xmlResult#"> --->
				
		<cfset strStats.id = arguments.cid>
				
		<cfloop from="1" to="#Arraylen(arrKeys)#" index="l">
			<cfset strStats["#arrKeys[l]#"] = xmlResult.mcapi.xmlchildren[l].xmltext>
		</cfloop>
		
		<!--- <cfdump var="#stats#"> --->	
		<cfreturn strStats>  
	</cffunction>

	<cffunction name="campaignAbuseReports" access="public" returntype="Any" hint="I get all email addresses that complained about a given campaign">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="cid" required="true" type="string">
		<cfargument name="start" required="false" default="0">
		<cfargument name="limit" required="false" default="100">
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var qryAbuseReports = QueryNew("email")>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignAbuseReports" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="cid" value="#arguments.cid#" type="url">
			<cfhttpparam name="start" value="#arguments.start#" type="url">
			<cfhttpparam name="limit" value="#arguments.limit#" type="url">
		</cfhttp>
		
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		<!--- <cfdump var="#xmlResult#"> --->
		<cfif StructKeyExists(xmlResult.mcapi,"struct")>
			<cfloop from="1" to="#ArrayLen(xmlresult.mcapi.struct)#" index="u">
			 <cfset QueryAddRow(qryAbuseReports)>
			 <cfset QuerySetCell(qryAbuseReports, "email", xmlResult.mcapi.struct[u].xmlText)>
		</cfloop>
		</cfif>
		<cfreturn qryAbuseReports>
		
	</cffunction>
			
	<cffunction name="campaignClickStats" access="public" returntype="Any" hint="I get an array of the urls being tracked, and their click counts for a given campaign.">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="cid" required="true" type="string">
	
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var qryClickStats = QueryNew("url,clicks,unique")>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignClickStats" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="cid" value="#arguments.cid#" type="url">
		</cfhttp>
		
		 <cfdump var="#result#"> 
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		<!--- <cfdump var="#xmlResult#"> --->
		
		<cfreturn xmlResult>
	</cffunction>	
		
	<cffunction name="campaignHardBounces" access="public" returntype="Any" hint="I get all email addresses with Hard Bounces for a given campaign">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="cid" required="true" type="string">
		<cfargument name="start" required="false" default="0">
		<cfargument name="limit" required="false" default="100">
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var qryHardBounces = QueryNew("email")>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignHardBounces" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="cid" value="#arguments.cid#" type="url">
			<cfhttpparam name="start" value="#arguments.start#" type="url">
			<cfhttpparam name="limit" value="#arguments.limit#" type="url">
		</cfhttp>
		
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		<!--- <cfdump var="#xmlResult#"> --->
		<cfif StructKeyExists(xmlResult.mcapi,"struct")>
			<cfloop from="1" to="#ArrayLen(xmlresult.mcapi.struct)#" index="u">
				 <cfset QueryAddRow(qryHardBounces)>
				 <cfset QuerySetCell(qryHardBounces, "email", xmlResult.mcapi.struct[u].xmlText)>
			</cfloop>
		</cfif>
		<cfreturn qryHardBounces>
		
	</cffunction>
	
	<cffunction name="campaignSoftBounces" access="public" returntype="Any" hint="I get all email addresses with Soft Bounces for a given campaign">
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="cid" required="true" type="string">
		<cfargument name="start" required="false" default="0">
		<cfargument name="limit" required="false" default="100">
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var qrySoftBounces = QueryNew("email")>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignSoftBounces" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="cid" value="#arguments.cid#" type="url">
			<cfhttpparam name="start" value="#arguments.start#" type="url">
			<cfhttpparam name="limit" value="#arguments.limit#" type="url">
		</cfhttp>
		
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		<!--- <cfdump var="#xmlResult#"> --->
		<cfif StructKeyExists(xmlResult.mcapi,"struct")>
			<cfloop from="1" to="#ArrayLen(xmlresult.mcapi.struct)#" index="u">
				 <cfset QueryAddRow(qrySoftBounces)>
				 <cfset QuerySetCell(qrySoftBounces, "email", xmlResult.mcapi.struct[u].xmlText)>
			</cfloop>
		</cfif>
		<cfreturn qrySoftBounces>
	</cffunction>
	
	<cffunction name="campaignUnsubscribes" access="public" returntype="Any" hint="I get all email addresses with Soft Bounces for a given campaign">
		
		<cfargument name="apikey" required="true" type="string">
		<cfargument name="cid" required="true" type="string">
		<cfargument name="start" required="false" default="0">
		<cfargument name="limit" required="false" default="100">
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var qryUnsubscribes = QueryNew("email")>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignUnsubscribes" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="cid" value="#arguments.cid#" type="url">
			<cfhttpparam name="start" value="#arguments.start#" type="url">
			<cfhttpparam name="limit" value="#arguments.limit#" type="url">
		</cfhttp>
		
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
		<cfif StructKeyExists(xmlResult.mcapi,"struct")>
			<cfloop from="1" to="#ArrayLen(xmlresult.mcapi.struct)#" index="u">
				 <cfset QueryAddRow(qryUnsubscribes)>
				 <cfset QuerySetCell(qryUnsubscribes, "email", xmlResult.mcapi.struct[u].xmlText)>
			</cfloop>
		</cfif>
		<!--- <cfdump var="#qryUnsubscribes#"> --->
		
		<cfreturn qryUnsubscribes>
	</cffunction>

	<cffunction name="campaignEmailStatsAIMAll" access="public" returntype="Any" hint="I return the entire click and open history with timestamps, ordered by time, for every user a campaign was delivered to.">
	<cfargument name="apikey" required="true" type="string">
	<cfargument name="cid" required="true" type="string">
	<cfargument name="start" required="false" default="0">
	<cfargument name="limit" required="false" default="100">
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var qryStats = QueryNew("campaignID,email,action,timestamp,url,key,createdOn")>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignEmailStatsAIMAll" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
			<cfhttpparam name="cid" value="#arguments.cid#" type="url">
			<cfhttpparam name="start" value="#arguments.start#" type="url">
			<cfhttpparam name="limit" value="#arguments.limit#" type="url">
		</cfhttp>
		
		<!--- <cfdump var="#result#"> --->
		
		<cfset xmlResult = xmlParse(result.filecontent)>
				<!--- <cfdump var="#xmlResult#"> --->
				 	  
		<cfif Isdefined("xmlResult.mcapi.error")>
			<cfreturn xmlResult.mcapi.error.xmltext>
		<cfelse>
			
		<cfloop from="1" to="#arrayLen(xmlResult.mcapi.xmlchildren)#" index="e">
			<cfloop from="1" to="#ArrayLen(xmlResult.mcapi.xmlchildren[e].xmlchildren)#" index="c">
				
				<cfset record = StructNew()>
				<cfset record.campaignID  = arguments.cid>
				<cfset record.email = xmlResult.mcapi.xmlchildren[e].xmlattributes.key>
				<cfset record.createdon = Now()>
				<cfset record.key = xmlResult.mcapi.xmlchildren[e].xmlchildren[c].xmlAttributes.key>
			
				 <cfloop from="1" to="#ArrayLen(xmlResult.mcapi.xmlchildren[e].xmlchildren[c].xmlchildren)#" index="a">
				 	<cfset record[xmlResult.mcapi.xmlchildren[e].xmlchildren[c].xmlchildren[a].xmlname] = xmlResult.mcapi.xmlchildren[e].xmlchildren[c].xmlchildren[a].xmlText>
			     </cfloop>
				
				<cfset temp = QueryAddRow(qryStats)>
				<cfloop collection="#record#" item="key">
					<cfset temp = QuerySetCell(qryStats, key, record[key])>
				</cfloop>
			</cfloop>
		</cfloop>

	<cfreturn qryStats>	
	</cfif>
				
		
	</cffunction>

	<cffunction name="createCampaign" access="public" returntype="Any" hint="I create a new campaigndraft for a certain list">
		
			<cfargument name="apikey" required="true" type="string">
     		<cfargument name="title" required="true" type="string" default="Test Campaign">
			<cfargument name="listid" required="true" type="string">
			<cfargument name="type" required="true" type="string" default="regular">
			<cfargument name="subject" required="true" type="string" default="TestCampaign: New Listing">
			<cfargument name="templateid" required="false" type="string">
			<cfargument name="content" required="false" type="string">
			<cfargument name="contentpath" required="false" type="string">
			<cfargument name="from_email" required="true" type="string" default="naples@tillmanteam.com">
			<cfargument name="from_name" required="true" type="string" default="Jay Tillman">
			<cfargument name="to_email" required = "true" type="string" default="|:FIRST_NAME:|">
		
			
	
<!--- 		campaignCreate(string apikey, string type, array options, array content, array segment_opts, array type_opts) --->
			<cfset var result="">
			<cfset var xmlResult = "">
			<cfset var success = "">
			
			<cfhttp url="#getServiceURL()#" method="post" result="result">
				<cfhttpparam name="output" value="#getOutput()#" type="url">
				<cfhttpparam name="method" value="campaignCreate" type="URL">
				<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
				<cfhttpparam name="type" value="#arguments.type#" type="url">
				<cfhttpparam name="options[list_id]" value="#arguments.listid#" type="url">
				<cfhttpparam name="options[template_id]" value="#arguments.templateid#" type="url">
				<cfhttpparam name="options[title]" value="#arguments.title#" type="url">
				<cfhttpparam name="options[subject]" value="#arguments.subject#" type="url">
				<cfhttpparam name="options[from_email]" value="#arguments.from_email#" type="url">
				<cfhttpparam name="options[from_name]" value="#arguments.from_name#" type="url">
				<cfhttpparam name="options[to_email]" value="#arguments.to_email#" type="url">
				<cfif Isdefined("arguments.contentpath")>
					<cfhttpparam name="content[url]" value="#arguments.contentpath#" type="url">
				</cfif>
				<cfif Isdefined("arguments.content")>
					<cfhttpparam name="content[html_MAIN]" value="#arguments.content#" type="url">
				</cfif>
						
			</cfhttp>
			
<!--- 	 <cfdump var="#result#">  --->
			
			<cfset xmlResult = xmlParse(result.filecontent)>
<!---  <cfdump var="#xmlResult#">   --->
			
			<cfreturn xmlResult>
	

	</cffunction>	

	<cffunction name="listTemplates" access="public" returntype="Any" hint="I list all templates">
		<cfargument name="apikey" required="true" type="string">
			
		<cfset var result="">
		<cfset var xmlResult = "">
		<cfset var success = "">
		<cfset var lstSections = "">
		<cfset var qryTemplates = QueryNew("id, name, type, layout, sections")>
		
		<cfhttp url="#getServiceURL()#" method="post" result="result">
			<cfhttpparam name="output" value="#getOutput()#" type="url">
			<cfhttpparam name="method" value="campaignTemplates" type="URL">
			<cfhttpparam name="apikey" value="#arguments.apikey#" type="url">
		</cfhttp>

		<cfset xmlResult = xmlParse(result.filecontent)>
		
		<cfif StructKeyExists(xmlResult.mcapi,"struct")>		
			<cfloop from="1" to="#ArrayLen(xmlResult.mcapi.struct)#" index="i">
				 <cfset QueryAddRow(qryTemplates)>
				 <cfset QuerySetCell(qryTemplates, "id", xmlResult.mcapi.struct[i].id.xmlText)>
				 <cfset QuerySetCell(qryTemplates, "type", xmlResult.mcapi.struct[i].id.xmlAttributes.type)>
				 <cfset QuerySetCell(qryTemplates, "name", xmlResult.mcapi.struct[i].name.xmlText)>
 				 <cfset QuerySetCell(qryTemplates, "layout", xmlResult.mcapi.struct[i].layout.xmlText)>
 				 <cfset QuerySetCell(qryTemplates, "sections",xmlResult.mcapi.struct[i].sections)>
	
				 <cfloop from="1" to="#arrayLen(xmlResult.mcapi.struct[i].sections.struct)#" index="s">
					<cfset lstSections = Listappend(lstSections,xmlResult.mcapi.struct[i].sections.struct[s].xmlText)>
					</cfloop>
					
	 			<cfset QuerySetCell(qryTemplates, "sections",lstSections)>
				<cfset lstSections = ""> 
			 </cfloop>
		</cfif>	
		<cfreturn qryTemplates>
	</cffunction>

<!--- AIM Methods 

campaignClickDetailAIM(string apikey, string cid, string url, integer start, integer limit)

Return the list of email addresses that clicked on a given url, and how many times they clicked
static 	

campaignEmailStatsAIM(string apikey, string cid, mixed email_address)

Given a campaign and email address, return the entire click and open history with timestamps, ordered by time
static 	

campaignEmailStatsAIMAll(string apikey, string cid, integer start, integer limit)

Given a campaign and correct paging limits, return the entire click and open history with timestamps, ordered by time, for every user a campaign was delivered to.
static 	

campaignNotOpenedAIM(string apikey, string cid, integer start, integer limit)

Retrieve the list of email addresses that did not open a given campaign
static 	

campaignOpenedAIM(string apikey, string cid, integer start, integer limit)

Retrieve the list of email addresses that opened a given campaign with how many times they opened 

--->


		
	<cffunction name="getServiceURL" access="public" returntype="string" output="false">
		<cfreturn instance.variables.serviceURL />
	</cffunction>
	<cffunction name="setServiceURL" access="public" returntype="void" output="false">
		<cfargument name="serviceURL" required="true" type="string"/>
		<cfset instance.variables.serviceURL  = arguments.serviceURL  />
		<cfreturn />
	</cffunction>

<cffunction name="getApiKey" access="public" returntype="string" output="false">
		<cfreturn instance.variables.ApiKey />
	</cffunction>
	<cffunction name="setApiKey" access="public" returntype="void" output="false">
		<cfargument name="apiKey" required="true" type="string"/>
		<cfset instance.variables.ApiKey  = arguments.ApiKey  />
		<cfreturn />
	</cffunction>

	<cffunction name="getOutput" access="public" returntype="string" output="false">
		<cfreturn instance.variables.output />
	</cffunction>
	<cffunction name="setOutput" access="public" returntype="void" output="false">
		<cfargument name="output" required="true" type="string"/>
		<cfset instance.variables.output  = arguments.output  />
		<cfreturn />
	</cffunction>

</cfcomponent>