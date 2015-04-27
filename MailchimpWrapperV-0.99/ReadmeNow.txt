Still Unfinished Version of MailchimpCFC 0.99
http://www.mailchimp.com
You need an account to be able to use it. 

Created on: 11/9/2008
Updated on: 10/9/2010
published on 5/6/2011
Birgit Pauli-Haack, bph@idxtools.com
Pauli Systems, LC & Relevanza, Inc.

I only implemented methods we actually needed for client work. If anything is missing and you add to it, please share with the rest of us.

	* isEmail 
	* login (depricated in MCApi.1.2)
	* listBatchSubscribe
	* ListBatchUnsubscribe
	* listInterestGroupAdd
	* ListInterestGRoupDel
	* ListMemberinfo
	* ListMembers
	* lists
	* listInterestGroups
	* listSubscribe
	* listUnsubscribe
	* CampaignContent
	* campaigns
	* campaignStats
	* CampaignAbuseReports
	* CampaignClickStats
	* CampaignHardBounces
	* campaignSoftBounces
	* campaignUnsubscribes
	* CampaignEmailStatsAIMAll
	* createCampaign
	* listTemplates

Here is the 1.2 invocation code (still need to read up about v1.3 of the API, sorry)

<cfset apiKey = "GetYourOwnAPIKey">
<cfset url= "http://#listlast(application.mc.apiKey, "-")#.api.mailchimp.com/1.2/">
<cfset output = "xml">
<cfset mp = createObject("component","components.mailchimp099").init(application.mc.apiKey,application.mc.url,application.mc.output)>

You need to replace "GetYourOwnAPIKey" with your account's API Key. You'll find it on Mailchimp under Account Settings > APIKeys
https://us1.admin.mailchimp.com/account/api

Feel free to contact me with suggestions, corrections and other comments.
Birgit
Follow me on Twitter: @bph
Naples, Florida May 6, 2011
